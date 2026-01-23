
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../widgets/common/colors.dart';
import '../../widgets/common/section_card.dart';
import '../../widgets/common/shared_top_bar.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String role;
  final String assetId;
  final String? selectedUnitId;

  const PropertyDetailsScreen({
    super.key,
    required this.role,
    required this.assetId,
    this.selectedUnitId,
  });

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool _loading = true;
  String? _errorMessage;
  bool _entryWasProject = true;

  String? _projectId;
  String? _selectedUnitId;
  String? _expandedFloorId;

  _PropertyDetailsData? _details;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void didUpdateWidget(PropertyDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetId != widget.assetId ||
        oldWidget.selectedUnitId != widget.selectedUnitId ||
        oldWidget.role != widget.role) {
      _loadInitialData();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final selectedUnitId = widget.selectedUnitId;
    if (selectedUnitId != null && selectedUnitId.isNotEmpty) {
      _entryWasProject = true;
      await _loadUsingProjectEntry(widget.assetId, selectedUnitId);
    } else {
      await _loadUsingAssetId(widget.assetId);
    }
  }

  Future<void> _loadUsingProjectEntry(
    String projectId,
    String selectedUnitId,
  ) async {
    try {
      final project = await _fetchProject(projectId);
      final units = await _fetchUnits(projectId);
      _applyDetails(project, units);
      _entryWasProject = true;
      _applySelection(selectedUnitId);
    } catch (e) {
      _loadMockData(assetId: projectId, selectedUnitId: selectedUnitId);
    } finally {
      _finishLoading();
    }
  }

  Future<void> _loadUsingAssetId(String assetId) async {
    try {
      final unit = await _tryFetchUnit(assetId);
      if (unit != null) {
        _projectId = unit.projectId;
        final project = await _tryFetchProject(unit.projectId);
        final units = await _fetchUnits(unit.projectId);
        _applyDetails(project, units);

        if (unit.type == _UnitType.unit) {
          _entryWasProject = false;
          _applySelection(unit.id);
        } else {
          _entryWasProject = true;
          _applySelection(null);
        }
        _finishLoading();
        return;
      }

      final project = await _tryFetchProject(assetId);
      if (project != null) {
        _projectId = assetId;
        final units = await _fetchUnits(assetId);
        _applyDetails(project, units);
        _entryWasProject = true;
        _applySelection(null);
        _finishLoading();
        return;
      }

      _loadMockData(assetId: assetId);
    } catch (e) {
      _loadMockData(assetId: assetId);
    } finally {
      _finishLoading();
    }
  }

  void _finishLoading() {
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }
  void _applyDetails(_ProjectData? project, List<_UnitData> units) {
    final details = _buildHierarchy(project, units);
    _details = details;
    _projectId = project?.id ?? _projectId;
  }

  void _applySelection(String? unitId) {
    _selectedUnitId = unitId;
    if (unitId == null || _details == null) {
      _expandedFloorId = null;
      return;
    }

    final unit = _details!.unitsById[unitId];
    if (unit == null) {
      _selectedUnitId = null;
      _expandedFloorId = null;
      return;
    }
    _expandedFloorId = unit.parentUnitId;
  }

  Future<_ProjectData?> _tryFetchProject(String projectId) async {
    try {
      return await _fetchProject(projectId);
    } on NotFoundException {
      return null;
    }
  }

  Future<_UnitData?> _tryFetchUnit(String unitId) async {
    try {
      return await _fetchUnit(unitId);
    } on NotFoundException {
      return null;
    }
  }

  Future<_ProjectData> _fetchProject(String projectId) async {
    final data = await ApiService.authenticatedGet('/projects/$projectId');
    return _ProjectData.fromJson(data);
  }

  Future<_UnitData> _fetchUnit(String unitId) async {
    final data = await ApiService.authenticatedGet('/units/$unitId');
    return _UnitData.fromJson(data);
  }

  Future<List<_UnitData>> _fetchUnits(String projectId) async {
    final data = await ApiService.authenticatedGet('/projects/$projectId/units');
    final items = data['data'];
    if (items is! List) {
      return [];
    }
    return items
        .map((item) => _UnitData.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  _PropertyDetailsData _buildHierarchy(
    _ProjectData? project,
    List<_UnitData> units,
  ) {
    final unitsById = <String, _UnitData>{};
    for (final unit in units) {
      unitsById[unit.id] = unit;
    }

    var building = units.firstWhere(
      (unit) => unit.type == _UnitType.building,
      orElse: () => _UnitData.empty(),
    );
    if (building.type != _UnitType.building) {
      building = units.firstWhere(
        (unit) => unit.parentUnitId == null,
        orElse: () => units.isNotEmpty ? units.first : _UnitData.empty(),
      );
    }
    final resolvedBuilding = building;

    final floors = units
        .where(
          (unit) =>
              unit.type == _UnitType.floor &&
              unit.parentUnitId == resolvedBuilding.id,
        )
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final floorGroups = floors.map((floor) {
      final flats = units
          .where(
            (unit) =>
                unit.type == _UnitType.unit &&
                unit.parentUnitId == floor.id,
          )
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      return _FloorGroup(floor: floor, flats: flats);
    }).toList();

    return _PropertyDetailsData(
      project: project,
      building: resolvedBuilding,
      floors: floorGroups,
      unitsById: unitsById,
    );
  }

  void _loadMockData({required String assetId, String? selectedUnitId}) {
    final demo = _PropertyDetailsData.demo();
    _details = demo;
    _projectId = demo.project?.id;
    if (selectedUnitId != null) {
      _entryWasProject = true;
      _applySelection(selectedUnitId);
      return;
    }
    if (demo.unitsById.containsKey(assetId) &&
        demo.unitsById[assetId]?.type == _UnitType.unit) {
      _entryWasProject = false;
      _applySelection(assetId);
    } else {
      _entryWasProject = true;
      _applySelection(null);
    }
    _errorMessage ??=
        'Live property data not available. Showing sample details.';
  }

  void _handleSelectProjectOverview() {
    if (_details == null) return;
    setState(() {
      _selectedUnitId = null;
    });

    if (!_entryWasProject && _projectId != null) {
      context.go('/${widget.role}/properties/$_projectId');
    }
  }

  void _handleSelectUnit(_UnitData unit) {
    if (_details == null) return;
    setState(() {
      _selectedUnitId = unit.id;
      _expandedFloorId = unit.parentUnitId;
    });

    if (!_entryWasProject && _projectId != null) {
      context.go(
        '/${widget.role}/properties/$_projectId',
        extra: {'selectedUnitId': unit.id},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashboardBackground,
      bottomNavigationBar: SharedBottomNavBar(
        selectedIndex: -1,
        role: widget.role,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SharedTopBar(selectedIndex: -1, role: widget.role),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final details = _details;
    if (details == null) {
      return Center(
        child: Text(_errorMessage ?? 'No property details found'),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 1200;
    final padding = EdgeInsets.symmetric(
      horizontal: isNarrow ? 24 : 50,
      vertical: 32,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(details),
            const SizedBox(height: 24),
            isNarrow
                ? Column(
                    children: [
                      _buildSidebar(details),
                      const SizedBox(height: 20),
                      _buildDetailsPanel(details, isNarrow: true),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 320, child: _buildSidebar(details)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildDetailsPanel(details)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader(_PropertyDetailsData details) {
    final building = details.building;
    final title = building?.name ?? 'Property Details';
    final subtitle = details.project?.address ?? 'Project Overview';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3F3F3F),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.remove_red_eye_outlined,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildSidebar(_PropertyDetailsData details) {
    final floors = details.floors;
    final selectedUnitId = _selectedUnitId;
    final isProjectSelected = selectedUnitId == null;

    return Container(
      height: 640,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderGrey),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Text(
              'Floors',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3F3F3F),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.borderGrey),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildProjectOverviewTile(isProjectSelected),
                const SizedBox(height: 8),
                ...floors.map((floorGroup) {
                  return _buildFloorTile(floorGroup, selectedUnitId);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectOverviewTile(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: _handleSelectProjectOverview,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFE7F2FB)
                : const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(6),
            border: isSelected
                ? Border.all(color: AppColors.ceoPrimary, width: 1.5)
                : null,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.apartment,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Project Overview',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color:
                        isSelected ? AppColors.ceoPrimary : const Color(0xFF3F3F3F),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloorTile(_FloorGroup group, String? selectedUnitId) {
    final floor = group.floor;
    final isExpanded = _expandedFloorId == floor.id;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEBEBEB),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _expandedFloorId = isExpanded ? null : floor.id;
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/stairs.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        floor.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3F3F3F),
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  children: group.flats.map((flat) {
                    final isSelected = flat.id == selectedUnitId;
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () => _handleSelectUnit(flat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFD0E8FF)
                                : const Color(0xFFDEDEDE),
                            borderRadius: BorderRadius.circular(6),
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.ceoPrimary,
                                    width: 1.5,
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  flat.name,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF3F3F3F),
                                  ),
                                ),
                              ),
                              _StatusDot(color: _statusColor(flat.status)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildDetailsPanel(
    _PropertyDetailsData details, {
    bool isNarrow = false,
  }) {
    final displayUnit = _currentDisplayUnit(details);
    final galleryPhotos = displayUnit?.photoUrls ?? const [];
    final amenities = displayUnit?.amenities ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUnitHeader(displayUnit, details.project),
        const SizedBox(height: 16),
        SectionCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGallery(galleryPhotos),
                const SizedBox(height: 12),
                _buildAmenities(amenities),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        isNarrow
            ? Column(
                children: [
                  _buildSummaryCard(displayUnit, details),
                  const SizedBox(height: 16),
                  _buildInstallmentsCard(displayUnit),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildSummaryCard(displayUnit, details)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInstallmentsCard(displayUnit)),
                ],
              ),
      ],
    );
  }

  Widget _buildUnitHeader(_UnitData? unit, _ProjectData? project) {
    final title = unit?.name ?? project?.name ?? 'Property';
    final status = unit?.status ?? 'AVAILABLE';

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3F3F3F),
            ),
          ),
        ),
        _StatusBadge(status: status),
      ],
    );
  }

  Widget _buildGallery(List<String> photos) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final mainWidth = maxWidth * 0.65;
        final sideWidth = maxWidth - mainWidth - 12;

        return SizedBox(
          height: 220,
          child: Row(
            children: [
              _GalleryTile(
                width: mainWidth,
                imageUrl: photos.isNotEmpty ? photos.first : null,
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: sideWidth,
                child: Column(
                  children: [
                    _GalleryTile(
                      width: sideWidth,
                      height: 104,
                      imageUrl: photos.length > 1 ? photos[1] : null,
                    ),
                    const SizedBox(height: 12),
                    _GalleryTile(
                      width: sideWidth,
                      height: 104,
                      imageUrl: photos.length > 2 ? photos[2] : null,
                      overlayText:
                          photos.length > 3 ? '+${photos.length - 3}' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmenities(List<String> amenities) {
    if (amenities.isEmpty) {
      return const Text(
        'No amenities listed',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: AppColors.textHint,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: amenities.map((amenity) {
        return _AmenityChip(label: amenity);
      }).toList(),
    );
  }

  Widget _buildSummaryCard(_UnitData? unit, _PropertyDetailsData details) {
    final building = details.building;
    final isProject = unit == null || unit.type != _UnitType.unit;

    final title = isProject ? 'Project Summary' : 'Unit Summary';
    final primaryName = unit?.ownerName ?? 'Unassigned';
    final primaryPhone = unit?.ownerPhone ?? '-';

    final infoRows = <_InfoRow>[
      _InfoRow(label: 'Owner', value: primaryName),
      _InfoRow(label: 'Phone Number', value: primaryPhone),
      _InfoRow(
        label: 'Size',
        value: unit?.sizeSqft != null ? '${unit!.sizeSqft} sqft' : '-',
      ),
      _InfoRow(label: 'Face', value: _formatFacing(unit?.facing)),
      _InfoRow(
        label: 'Parking',
        value: unit?.parkingSpaces != null
            ? unit!.parkingSpaces.toString()
            : '-',
      ),
      _InfoRow(
        label: 'Bedroom',
        value: unit?.bedrooms != null ? unit!.bedrooms.toString() : '-',
      ),
      _InfoRow(
        label: 'Bathroom',
        value: unit?.bathrooms != null ? unit!.bathrooms.toString() : '-',
      ),
      _InfoRow(
        label: 'Living Room',
        value: unit?.livingRooms != null ? unit!.livingRooms.toString() : '-',
      ),
    ];

    if (isProject && building != null) {
      infoRows.addAll([
        _InfoRow(
          label: 'Total Floors',
          value: building.details['total_floors']?.toString() ?? '-',
        ),
        _InfoRow(
          label: 'Price per sqft',
          value: building.pricePerSqft != null
              ? building.pricePerSqft!.toStringAsFixed(0)
              : '-',
        ),
      ]);
    }

    return SectionCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3F3F3F),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: infoRows.map((row) => _SummaryTile(row: row)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallmentsCard(_UnitData? unit) {
    final installments = _InstallmentItem.sample(unit?.name ?? 'Flat');

    return SectionCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Installments',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3F3F3F),
                    ),
                  ),
                ),
                Text(
                  '${installments.where((i) => i.status == _InstallmentStatus.pending).length} installment remains',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: installments.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _InstallmentTile(item: item),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  _UnitData? _currentDisplayUnit(_PropertyDetailsData details) {
    if (_selectedUnitId == null) {
      return details.building;
    }
    return details.unitsById[_selectedUnitId];
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SOLD':
        return AppColors.error;
      case 'RESERVED':
        return AppColors.warning;
      case 'AVAILABLE':
      default:
        return AppColors.success;
    }
  }

  String _formatFacing(String? facing) {
    if (facing == null || facing.isEmpty) return '-';
    switch (facing.toUpperCase()) {
      case 'N':
        return 'North';
      case 'S':
        return 'South';
      case 'E':
        return 'East';
      case 'W':
        return 'West';
      default:
        return facing;
    }
  }
}
class _PropertyDetailsData {
  final _ProjectData? project;
  final _UnitData? building;
  final List<_FloorGroup> floors;
  final Map<String, _UnitData> unitsById;

  _PropertyDetailsData({
    required this.project,
    required this.building,
    required this.floors,
    required this.unitsById,
  });

  static _PropertyDetailsData demo() {
    final project = _ProjectData(
      id: 'demo-project',
      name: 'Sky View Tower',
      address: 'Gulshan Avenue, Dhaka',
    );
    final building = _UnitData(
      id: 'demo-building',
      projectId: project.id,
      parentUnitId: null,
      name: project.name,
      type: _UnitType.building,
      status: 'AVAILABLE',
      sizeSqft: null,
      pricePerSqft: 3200,
      facing: 'N',
      bedrooms: null,
      bathrooms: null,
      livingRooms: null,
      parkingSpaces: null,
      amenities: const [
        'Gas Supply',
        'Boundary Wall',
        'Kitchen Cabinet',
        'Power Backup',
        'Parking',
        'Lift',
        'Servant Room',
      ],
      photoUrls: const [],
      details: const {'total_floors': 10, 'location': 'Gulshan Avenue'},
      ownerName: null,
      ownerPhone: null,
    );

    final floor1 = _UnitData(
      id: 'floor-1',
      projectId: project.id,
      parentUnitId: building.id,
      name: '1st Floor',
      type: _UnitType.floor,
      status: 'AVAILABLE',
      sizeSqft: null,
      pricePerSqft: null,
      facing: null,
      bedrooms: null,
      bathrooms: null,
      livingRooms: null,
      parkingSpaces: null,
      amenities: const [],
      photoUrls: const [],
      details: const {'number_of_flats': 2},
      ownerName: null,
      ownerPhone: null,
    );

    final flatA = _UnitData(
      id: 'flat-1a',
      projectId: project.id,
      parentUnitId: floor1.id,
      name: 'Flat 1A',
      type: _UnitType.unit,
      status: 'AVAILABLE',
      sizeSqft: 1450,
      pricePerSqft: 3400,
      facing: 'N',
      bedrooms: 3,
      bathrooms: 2,
      livingRooms: 1,
      parkingSpaces: 1,
      amenities: const [
        'Gas Supply',
        'Boundary Wall',
        'Kitchen Cabinet',
        'Power Backup',
        'Parking',
        'Lift',
      ],
      photoUrls: const [],
      details: const {'price': 5200000},
      ownerName: 'Siam Ali',
      ownerPhone: '01234567890',
    );

    final flatB = flatA.copyWith(
      id: 'flat-1b',
      name: 'Flat 1B',
      status: 'SOLD',
    );

    final floor2 = floor1.copyWith(id: 'floor-2', name: '2nd Floor');
    final flat2A = flatA.copyWith(
      id: 'flat-2a',
      parentUnitId: floor2.id,
      name: 'Flat 2A',
      status: 'AVAILABLE',
    );

    final units = [building, floor1, floor2, flatA, flatB, flat2A];
    final unitsById = {for (final unit in units) unit.id: unit};

    return _PropertyDetailsData(
      project: project,
      building: building,
      floors: [
        _FloorGroup(floor: floor1, flats: [flatA, flatB]),
        _FloorGroup(floor: floor2, flats: [flat2A]),
      ],
      unitsById: unitsById,
    );
  }
}

class _ProjectData {
  final String id;
  final String name;
  final String? address;

  _ProjectData({
    required this.id,
    required this.name,
    required this.address,
  });

  factory _ProjectData.fromJson(Map<String, dynamic> json) {
    return _ProjectData(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Project',
      address: json['address']?.toString(),
    );
  }
}

enum _UnitType { building, floor, unit, unknown }
class _UnitData {
  final String id;
  final String projectId;
  final String? parentUnitId;
  final String name;
  final _UnitType type;
  final String status;
  final int? sizeSqft;
  final double? pricePerSqft;
  final String? facing;
  final int? bedrooms;
  final int? bathrooms;
  final int? livingRooms;
  final int? parkingSpaces;
  final List<String> amenities;
  final List<String> photoUrls;
  final Map<String, dynamic> details;
  final String? ownerName;
  final String? ownerPhone;

  const _UnitData({
    required this.id,
    required this.projectId,
    required this.parentUnitId,
    required this.name,
    required this.type,
    required this.status,
    required this.sizeSqft,
    required this.pricePerSqft,
    required this.facing,
    required this.bedrooms,
    required this.bathrooms,
    required this.livingRooms,
    required this.parkingSpaces,
    required this.amenities,
    required this.photoUrls,
    required this.details,
    required this.ownerName,
    required this.ownerPhone,
  });

  factory _UnitData.fromJson(Map<String, dynamic> json) {
    return _UnitData(
      id: json['id']?.toString() ?? '',
      projectId: json['project_id']?.toString() ?? '',
      parentUnitId: json['parent_unit_id']?.toString(),
      name: json['name']?.toString() ?? '',
      type: _parseUnitType(json['type']),
      status: json['status']?.toString() ?? 'AVAILABLE',
      sizeSqft: _asInt(json['size_sqft']),
      pricePerSqft: _asDouble(json['price_per_sqft']),
      facing: json['facing']?.toString(),
      bedrooms: _asInt(json['bedrooms']),
      bathrooms: _asInt(json['bathrooms']),
      livingRooms: _asInt(json['living_rooms']),
      parkingSpaces: _asInt(json['parking_spaces']),
      amenities: _asStringList(json['amenities']),
      photoUrls: _asStringList(json['photo_urls']),
      details: _asMap(json['details_json']),
      ownerName: json['owner_name']?.toString(),
      ownerPhone: json['owner_phone']?.toString(),
    );
  }

  static _UnitType _parseUnitType(dynamic value) {
    final type = value?.toString().toUpperCase();
    switch (type) {
      case 'BUILDING':
        return _UnitType.building;
      case 'FLOOR':
        return _UnitType.floor;
      case 'UNIT':
        return _UnitType.unit;
      default:
        return _UnitType.unknown;
    }
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String && value.isNotEmpty) return int.tryParse(value);
    return null;
  }

  static double? _asDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String && value.isNotEmpty) return double.tryParse(value);
    return null;
  }

  static List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((item) => item.toString()).toList();
        }
      } catch (_) {}
    }
    return [];
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is String && value.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {}
    }
    return {};
  }

  _UnitData copyWith({
    String? id,
    String? projectId,
    String? parentUnitId,
    String? name,
    _UnitType? type,
    String? status,
    int? sizeSqft,
    double? pricePerSqft,
    String? facing,
    int? bedrooms,
    int? bathrooms,
    int? livingRooms,
    int? parkingSpaces,
    List<String>? amenities,
    List<String>? photoUrls,
    Map<String, dynamic>? details,
    String? ownerName,
    String? ownerPhone,
  }) {
    return _UnitData(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      parentUnitId: parentUnitId ?? this.parentUnitId,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      sizeSqft: sizeSqft ?? this.sizeSqft,
      pricePerSqft: pricePerSqft ?? this.pricePerSqft,
      facing: facing ?? this.facing,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      livingRooms: livingRooms ?? this.livingRooms,
      parkingSpaces: parkingSpaces ?? this.parkingSpaces,
      amenities: amenities ?? this.amenities,
      photoUrls: photoUrls ?? this.photoUrls,
      details: details ?? this.details,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
    );
  }

  static _UnitData empty() {
    return const _UnitData(
      id: '',
      projectId: '',
      parentUnitId: null,
      name: '',
      type: _UnitType.unknown,
      status: 'AVAILABLE',
      sizeSqft: null,
      pricePerSqft: null,
      facing: null,
      bedrooms: null,
      bathrooms: null,
      livingRooms: null,
      parkingSpaces: null,
      amenities: [],
      photoUrls: [],
      details: {},
      ownerName: null,
      ownerPhone: null,
    );
  }
}
class _FloorGroup {
  final _UnitData floor;
  final List<_UnitData> flats;

  _FloorGroup({required this.floor, required this.flats});
}

class _InfoRow {
  final String label;
  final String value;

  _InfoRow({required this.label, required this.value});
}

class _SummaryTile extends StatelessWidget {
  final _InfoRow row;

  const _SummaryTile({required this.row});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            row.label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            row.value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3F3F3F),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final Color color;

  const _StatusDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SOLD':
        return AppColors.error;
      case 'RESERVED':
        return AppColors.warning;
      case 'AVAILABLE':
      default:
        return AppColors.success;
    }
  }
}
class _AmenityChip extends StatelessWidget {
  final String label;

  const _AmenityChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 14,
            color: AppColors.ceoPrimary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color(0xFF3F3F3F),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  final double width;
  final double? height;
  final String? imageUrl;
  final String? overlayText;

  const _GalleryTile({
    required this.width,
    this.height,
    this.imageUrl,
    this.overlayText,
  });

  @override
  Widget build(BuildContext context) {
    final tileHeight = height ?? double.infinity;
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: width,
        height: tileHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _placeholder(),
              )
            else
              _placeholder(),
            if (overlayText != null)
              Container(
                color: Colors.black.withValues(alpha: 0.35),
                child: Center(
                  child: Text(
                    overlayText!,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFECECEC),
      child: const Center(
        child: Icon(Icons.image, size: 40, color: AppColors.textHint),
      ),
    );
  }
}

class _InstallmentItem {
  final String title;
  final String date;
  final String amount;
  final _InstallmentStatus status;

  _InstallmentItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
  });

  static List<_InstallmentItem> sample(String unitName) {
    return [
      _InstallmentItem(
        title: '$unitName | Down Payment',
        date: '5 Dec 2025',
        amount: '2,500,000',
        status: _InstallmentStatus.pending,
      ),
      _InstallmentItem(
        title: '$unitName | Installment 1',
        date: '4 Nov 2025',
        amount: '1,200,000',
        status: _InstallmentStatus.paid,
      ),
      _InstallmentItem(
        title: '$unitName | Installment 2',
        date: '3 Oct 2025',
        amount: '1,200,000',
        status: _InstallmentStatus.paid,
      ),
      _InstallmentItem(
        title: '$unitName | Installment 3',
        date: '2 Sep 2025',
        amount: '1,200,000',
        status: _InstallmentStatus.paid,
      ),
    ];
  }
}

enum _InstallmentStatus { paid, pending }

class _InstallmentTile extends StatelessWidget {
  final _InstallmentItem item;

  const _InstallmentTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final statusColor = item.status == _InstallmentStatus.paid
        ? AppColors.success
        : AppColors.error;
    final statusText =
        item.status == _InstallmentStatus.paid ? 'Paid' : 'Due';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.date,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFF3F3F3F),
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.amount,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3F3F3F),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
