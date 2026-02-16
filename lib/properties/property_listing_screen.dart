import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../widgets/properties/property_card_widget.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_search_field.dart';
import '../../widgets/common/page_layout.dart';
import '../../widgets/common/pagination_widget.dart';
import '../../widgets/common/universal_photo_uploader.dart';
import '../../utils/responsive_utils.dart';

class PropertyManagementPage extends StatefulWidget {
  final String role;

  const PropertyManagementPage({
    super.key,
    required this.role,
  });

  @override
  State<PropertyManagementPage> createState() => _PropertyManagementPageState();
}

class _PropertyManagementPageState extends State<PropertyManagementPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Property> _allProperties = []; // Cache of all loaded properties
  List<Property> _properties = [];          // Filtered/displayed properties
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadProperties();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query != _searchQuery) {
      _searchQuery = query;
      _applySearch();
    }
  }

  /// Apply fuzzy search across property name, location, and amenities
  /// Uses scoring system with priority: exact > word start > substring > fuzzy
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _properties = List.from(_allProperties);
      });
      return;
    }

    final queryLower = _searchQuery.toLowerCase();

    // Words that are pure filler (no search value)
    final fillerWords = {'in', 'at', 'the', 'a', 'an', 'with', 'by', 'for', 'of', 'to', 'and', 'or', 'is', 'are', 'my', 'me', 'i'};

    // Words that refer to properties - ignore these and ANY partial typing of them
    final propertyAliases = [
      'property', 'properties',
      'apartment', 'apartments',
      'building', 'buildings',
      'project', 'projects',
      'site', 'sites',
      'flat', 'flats',
      'unit', 'units',
      'house', 'houses',
      'home', 'homes',
      'estate', 'estates',
      'complex', 'complexes',
      'tower', 'towers',
      'residential', 'commercial',
      'plot', 'plots',
      'land', 'lands',
    ];

    // Action words to ignore (and their partial forms)
    final actionAliases = [
      'starting', 'named', 'called', 'like', 'containing',
      'has', 'having', 'show', 'showing', 'find', 'finding',
      'search', 'searching', 'list', 'listing', 'all', 'get', 'getting',
      'display', 'displaying', 'view', 'viewing',
    ];

    // Check if a word matches or is a partial of any ignored word
    // "pro" matches "property", "prop" matches "property", etc.
    // "apartm" matches "apartments", "bui" matches "building", etc.
    bool isIgnoredWord(String word) {
      if (word.isEmpty) return true;
      // Check against property aliases
      for (final alias in propertyAliases) {
        if (alias.startsWith(word) || word.startsWith(alias)) return true;
      }
      // Check against action aliases
      for (final alias in actionAliases) {
        if (alias.startsWith(word) || word.startsWith(alias)) return true;
      }
      return false;
    }

    // Parse query - keep meaningful words only
    final allWords = queryLower.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final queryWords = allWords
        .where((w) => !fillerWords.contains(w) && !isIgnoredWord(w))
        .toList();

    // If only property aliases/filler (e.g., "apartments", "apartm", "show homes"), show all
    if (queryWords.isEmpty) {
      setState(() {
        _properties = List.from(_allProperties);
      });
      return;
    }

    // Score each property and filter
    final scoredProperties = <MapEntry<Property, int>>[];

    for (final property in _allProperties) {
      final score = _calculateMatchScore(property, queryWords);
      if (score > 0) {
        scoredProperties.add(MapEntry(property, score));
      }
    }

    // Sort by score (higher = better match)
    scoredProperties.sort((a, b) => b.value.compareTo(a.value));

    setState(() {
      _properties = scoredProperties.map((e) => e.key).toList();
    });
  }

  /// Calculate match score - higher is better
  /// Priority: exact word match > word start > substring > fuzzy
  int _calculateMatchScore(Property property, List<String> queryWords) {
    final name = property.name.toLowerCase();
    final address = property.address.toLowerCase();
    final amenities = property.amenities.map((a) => a.toLowerCase()).join(' ');

    int score = 0;
    int matchedWords = 0;

    for (final word in queryWords) {
      int wordScore = 0;

      // Check name (highest base priority)
      final nameScore = _matchScore(name, word);
      if (nameScore > 0) {
        wordScore = nameScore * 3; // Name match multiplier
      }

      // Check address/location
      final addressScore = _matchScore(address, word);
      if (addressScore > 0) {
        final addrPoints = addressScore * 2; // Address match multiplier
        wordScore = wordScore > 0 ? wordScore + addrPoints : addrPoints;
      }

      // Check amenities (lowest priority)
      final amenityScore = _matchScore(amenities, word);
      if (amenityScore > 0 && wordScore == 0) {
        wordScore = amenityScore; // No multiplier for amenities-only match
      }

      if (wordScore > 0) {
        score += wordScore;
        matchedWords++;
      }
    }

    // Require at least one word to match
    if (matchedWords == 0) return 0;

    // Bonus for matching more query words
    score += matchedWords * 5;

    // Big bonus for name starting with first query word (e.g., "I" → "I am awesome")
    if (queryWords.isNotEmpty && name.startsWith(queryWords.first)) {
      score += 50;
    }

    return score;
  }

  /// Score a match - higher = better match type
  /// Returns: 20 for exact word, 15 for word start, 10 for substring, 5 for fuzzy, 0 for no match
  int _matchScore(String text, String query) {
    final words = text.split(RegExp(r'[\s,]+'));

    // Exact word match (highest priority)
    if (words.contains(query)) return 20;

    // Word starts with query
    for (final word in words) {
      if (word.startsWith(query)) return 15;
    }

    // Substring match
    if (text.contains(query)) return 10;

    // Fuzzy match (typo tolerance) - only for 4+ char queries
    if (query.length >= 4) {
      for (final word in words) {
        if (word.length >= query.length - 1 && word.length <= query.length + 1) {
          if (_isCloseMatch(word, query)) return 5;
        }
      }
    }

    return 0;
  }

  /// Check if two strings are close enough (1 character difference)
  bool _isCloseMatch(String a, String b) {
    if ((a.length - b.length).abs() > 1) return false;

    int differences = 0;
    final minLen = a.length < b.length ? a.length : b.length;

    for (int i = 0; i < minLen && differences <= 1; i++) {
      if (a[i] != b[i]) differences++;
    }

    differences += (a.length - b.length).abs();
    return differences <= 1;
  }

  Future<void> _loadProperties({int page = 1}) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _currentPage = page;
    });

    try {
      // Single request with preloaded units, sorted newest first
      final data = await ApiService.authenticatedGet(
        '/projects?page=$page&pageSize=20&preload=Units&sortBy=created_at&sortOrder=desc',
      );
      final List<dynamic> projectsList = _extractList(data);

      // Parse pagination metadata
      final metadata = data['metadata'];
      int totalPages = 0;
      if (metadata is Map<String, dynamic>) {
        totalPages = (metadata['totalPages'] as num?)?.toInt() ?? 0;
      }

      final List<Property> loaded = [];

      for (final p in projectsList) {
        if (p is! Map<String, dynamic>) continue;
        final id = (p['id'] ?? p['project_id'] ?? '').toString();
        if (id.isEmpty) continue;
        final name = (p['name'] ?? p['project_name'] ?? 'Unnamed Project').toString();
        final address = (p['address'] ?? '').toString();

        // Parse units from preloaded data (no separate API call)
        int unitCount = 0;
        final Set<String> amenitiesSet = {};
        final List<String> photoUrls = [];

        final units = p['units'];
        if (units is List) {
          for (final u in units) {
            if (u is! Map<String, dynamic>) continue;
            final type = (u['type']?.toString() ?? '').toUpperCase();

            // Count only UNIT-type entries for flat count
            if (type == 'UNIT') {
              unitCount++;
            }

            // Collect amenities from ALL unit types (BUILDING, FLOOR, UNIT)
            final unitAmenities = u['amenities'];
            if (unitAmenities is List) {
              for (final a in unitAmenities) {
                final s = a?.toString().trim() ?? '';
                if (s.isNotEmpty) amenitiesSet.add(s);
              }
            }

            // Extract photo file_url from photo objects and convert to full Storage URL
            final photos = u['photo_urls'];
            debugPrint('[PropertyListing] Unit ${u['id']} (type=$type) photo_urls raw: $photos');
            if (photos is List && photos.isNotEmpty) {
              for (final photo in photos) {
                if (photo is Map<String, dynamic>) {
                  final fileUrl = photo['file_url']?.toString() ?? '';
                  if (fileUrl.isNotEmpty) {
                    final fullUrl = convertStoragePathToUrl(fileUrl);
                    photoUrls.add(fullUrl);
                  }
                }
              }
            }
          }
        }

        debugPrint('[PropertyListing] Project "$name" - units: $unitCount, amenities: ${amenitiesSet.length}, photos: ${photoUrls.length}');
        if (photoUrls.isNotEmpty) {
          debugPrint('[PropertyListing] First photo URL: ${photoUrls.first}');
        }

        // Use first found photo URL as the card image
        final imageUrl = photoUrls.isNotEmpty ? photoUrls.first : '';

        loaded.add(Property(
          id: id,
          name: name,
          address: address,
          imageUrl: imageUrl,
          unitCount: unitCount,
          amenities: amenitiesSet.toList(),
        ));
      }

      if (!mounted) return;
      setState(() {
        _allProperties.clear();
        _allProperties.addAll(loaded);
        _totalPages = totalPages;
        _isLoading = false;
      });
      _applySearch(); // Apply any active search filter
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<dynamic> _extractList(Map<String, dynamic> data) {
    if (data.containsKey('projects')) {
      final v = data['projects'];
      if (v is List) return v;
    }
    if (data.containsKey('data')) {
      final v = data['data'];
      if (v is List) return v;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.width(context);
    final isXs = screenWidth < AppBreakpoints.xs;
    final isSm = screenWidth >= AppBreakpoints.xs && screenWidth < AppBreakpoints.sm;
    final isMdAndAbove = screenWidth >= AppBreakpoints.sm;

    return PageLayout(
      role: widget.role,
      selectedIndex: 1,
      titleRow: _buildTitleRow(isXs, isSm, isMdAndAbove),
      child: _buildBody(isXs, isSm, isMdAndAbove),
    );
  }

  Widget _buildBody(bool isXs, bool isSm, bool isMdAndAbove) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Failed to load properties',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF3F3F3F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: const Color(0xFF717171),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProperties,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_properties.isEmpty) {
      // Distinguish between no results from search vs no properties at all
      final isSearchActive = _searchQuery.isNotEmpty;
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSearchActive ? Icons.search_off : Icons.apartment,
                color: const Color(0xFFCCCCCC),
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                isSearchActive ? 'No Results Found' : 'No Properties Found',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3F3F3F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isSearchActive
                    ? 'No properties match "$_searchQuery"'
                    : 'Properties will appear here once projects are created',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Color(0xFF717171),
                ),
                textAlign: TextAlign.center,
              ),
              if (isSearchActive) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  child: const Text('Clear Search'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (isXs) ...[
            _buildMobileSearchRow(),
            SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),
          ],
          if (isSm || isMdAndAbove)
            SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),
          _buildPropertyList(isXs, isSm, isMdAndAbove),
          SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),
          PaginationWidget(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPageChanged: (page) => _loadProperties(page: page),
          ),
          SizedBox(height: IntakeLayoutTokens.xxLargeSpacing(context)),
        ],
      ),
    );
  }

  Widget _buildTitleRow(bool isXs, bool isSm, bool isMdAndAbove) {
    if (isXs) {
      return Row(
        children: [
          Text(
            'Properties',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: IntakeLayoutTokens.pageTitleFont(context),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF3F3F3F),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Properties',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: IntakeLayoutTokens.pageTitleFont(context),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF3F3F3F),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveUtils.scaleWidth(context, 360, min: 180, max: 400),
                    ),
                    child: CustomSearchField(
                      controller: _searchController,
                      hint: isSm ? 'Search' : 'Search by name, location...',
                    ),
                  ),
                ),
                SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
                _buildAddButton(),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildMobileSearchRow() {
    return Row(
      children: [
        Expanded(
          child: CustomSearchField(
            controller: _searchController,
            hint: 'Search name, location...',
          ),
        ),
        SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildAddButton() {
    final btnHeight = IntakeLayoutTokens.inputHeight(context);
    final iconSize = ResponsiveUtils.scaleWidth(context, 24, min: 18, max: 26);

    return CustomButton(
      icon: Icon(Icons.add, size: iconSize, color: Colors.white),
      onPressed: () {
        context.go('/${widget.role}/building/create');
      },
      width: btnHeight,
      height: btnHeight,
    );
  }

  Widget _buildPropertyList(bool isXs, bool isSm, bool isMdAndAbove) {
    if (isXs || isSm) {
      return Column(
        children: _properties.asMap().entries.map((entry) {
          return Column(
            children: [
              PropertyCardWidget(
                property: entry.value,
                onTap: () => _navigateToProperty(entry.value),
              ),
              if (entry.key < _properties.length - 1)
                SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),
            ],
          );
        }).toList(),
      );
    }

    // >= 768: 2 column layout
    List<Widget> rows = [];
    for (int i = 0; i < _properties.length; i += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PropertyCardWidget(
                property: _properties[i],
                onTap: () => _navigateToProperty(_properties[i]),
              ),
            ),
            SizedBox(width: IntakeLayoutTokens.mediumSpacing(context)),
            Expanded(
              child: i + 1 < _properties.length
                  ? PropertyCardWidget(
                      property: _properties[i + 1],
                      onTap: () => _navigateToProperty(_properties[i + 1]),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < _properties.length) {
        rows.add(SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)));
      }
    }
    return Column(children: rows);
  }

  void _navigateToProperty(Property property) {
    context.go('/${widget.role}/properties/${property.id}');
  }
}
