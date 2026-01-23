import 'package:flutter/material.dart';
import 'package:real_estate_flutter/widgets/common/custom_table.dart';
import 'package:real_estate_flutter/widgets/common/section_card.dart';
import 'package:real_estate_flutter/widgets/common/shared_top_bar.dart';
import 'package:real_estate_flutter/dummy_data/fake_data.dart';
import 'package:real_estate_flutter/utils/responsive_utils.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final TextEditingController _searchController = TextEditingController();

  Owner? _selectedOwner;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Iterable<Owner> _filterOwners(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const Iterable<Owner>.empty();
    return kOwners.where((o) =>
        o.name.toLowerCase().contains(q) ||
        o.phone.contains(q) ||
        o.unit.toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveUtils.isMobile(context);
    final double titleFont = IntakeLayoutTokens.pageTitleFont(context);
    final double titleTopSpacing = IntakeLayoutTokens.pageTitleSpacing(context);
    final double pageHPad = IntakeLayoutTokens.pageHorizontalPadding(context);
    final double pageTopPad = IntakeLayoutTokens.pageTopPadding(context);
    final double pageBottomPad = IntakeLayoutTokens.pageBottomPadding(context);

    //final double columnSpacing=IntakeLayoutTokens.columnSpacing(context);

    // Card height responsive by selection status
    final double cardHeight = _selectedOwner == null
        ? ResponsiveUtils.scaleHeight(context, 500, min: 360, max: 560)
        : ResponsiveUtils.scaleHeight(context, 440, min: 320, max: 520);

    // Search field width: full width on mobile, constrained on larger screens
    final double searchWidth = isMobile
        ? double.infinity
        : ResponsiveUtils.scaleWidth(context, 346, min: 220, max: 420);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: ResponsiveUtils.insetLTRB(
              context,
              pageHPad,
              pageTopPad,
              pageHPad,
              pageBottomPad,
            ),
            child: Column(
              children: [
                const SharedTopBar(
                  selectedIndex: -1,
                  role: 'ceo',
                ),
                SizedBox(height: ResponsiveUtils.scaleHeight(context, 20)),
                // Header: Title + Search
                isMobile
                    ? Padding(
                        padding: ResponsiveUtils.insetLTRB(
                          context,
                          pageHPad,
                          pageTopPad,
                          pageHPad,
                          pageBottomPad,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: titleTopSpacing),
                              child: Text(
                                'Create Invoice',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: titleFont,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    ResponsiveUtils.scaleHeight(context, 15)),
                            SizedBox(
                              width: searchWidth,
                              child: _SearchAutocomplete(
                                controller: _searchController,
                                hint: 'Select Owner or Unit',
                                onSelected: (owner) {
                                  setState(() {
                                    _selectedOwner = owner;
                                  });
                                  FocusScope.of(context).unfocus();
                                },
                                optionsBuilder: _filterOwners,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: titleTopSpacing),
                              child: Text(
                                'Create Invoice',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: titleFont,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: ResponsiveUtils.scaleWidth(context, 16)),
                          Padding(
                            padding: EdgeInsets.only(
                              top: ResponsiveUtils.scaleHeight(context, 13),
                            ),
                            child: SizedBox(
                              width: searchWidth,
                              child: _SearchAutocomplete(
                                controller: _searchController,
                                hint: 'Select Owner or Unit',
                                onSelected: (owner) {
                                  setState(() {
                                    _selectedOwner = owner;
                                  });
                                  FocusScope.of(context).unfocus();
                                },
                                optionsBuilder: _filterOwners,
                              ),
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: ResponsiveUtils.scaleHeight(context, 15)),
                isMobile
                    ? Padding(
                        padding: ResponsiveUtils.insetLTRB(
                          context,
                          pageHPad,
                          pageTopPad,
                          pageHPad,
                          pageBottomPad,
                        ),
                        child: SectionCard(
                          child: SizedBox(
                            height: cardHeight,
                            child: _selectedOwner == null
                                ? _EmptyInstallments()
                                : _OwnerDetailsAndInstallments(
                                    owner: _selectedOwner!),
                          ),
                        ),
                      )
                    : SectionCard(
                        child: SizedBox(
                          height: cardHeight,
                          child: _selectedOwner == null
                              ? _EmptyInstallments()
                              : _OwnerDetailsAndInstallments(
                                  owner: _selectedOwner!),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Overlay

class _SearchAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final void Function(Owner) onSelected;
  final Iterable<Owner> Function(String) optionsBuilder;

  const _SearchAutocomplete({
    required this.controller,
    required this.hint,
    required this.onSelected,
    required this.optionsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final double inputRadius = IntakeLayoutTokens.inputRadius(context);
    final double iconSize = IntakeLayoutTokens.smallIconSize(context);
    final EdgeInsets contentPadding = ResponsiveUtils.insetSymmetric(
      context,
      horizontal: 14,
      vertical: 14,
      minH: 10,
      maxH: 18,
      minV: 10,
      maxV: 18,
    );

    return Autocomplete<Owner>(
      displayStringForOption: (o) => o.name,
      optionsBuilder: (textEditingValue) =>
          optionsBuilder(textEditingValue.text),
      onSelected: onSelected,
      fieldViewBuilder: (context, textController, node, onFieldSubmitted) {
        // Sync external controller
        textController.text = controller.text;
        textController.selection = controller.selection;
        textController.addListener(() {
          if (controller.text != textController.text) {
            controller.value = textController.value;
          }
        });

        return TextField(
          controller: textController,
          focusNode: node, // IMPORTANT: use node provided by Autocomplete
          decoration: InputDecoration(
            contentPadding: contentPadding,
            prefixIcon: Icon(Icons.search,
                size: iconSize, color: const Color(0xFF9E9E9E)),
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(inputRadius),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(inputRadius),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(inputRadius),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
            ),
          ),
          onSubmitted: (_) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onOptionSelected, options) {
        if (options.isEmpty) return const SizedBox.shrink();
        final theme = Theme.of(context);
        final double maxW =
            ResponsiveUtils.scaleWidth(context, 346, min: 220, max: 420);
        final double maxH =
            ResponsiveUtils.scaleHeight(context, 110, min: 80, max: 140);
        final double minH =
            ResponsiveUtils.scaleHeight(context, 55, min: 44, max: 72);
        final double listHPad =
            IntakeLayoutTokens.smallHorizontalPadding(context);
        final double listVPad =
            IntakeLayoutTokens.smallHorizontalPadding(context);
        final double avatarRadius =
            ResponsiveUtils.scaleWidth(context, 18, min: 14, max: 20);

        return Align(
          alignment: ResponsiveUtils.isMobile(context)
              ? Alignment.topLeft
              : Alignment.topRight,
          child: Material(
            elevation: 4,
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: maxW, maxHeight: maxH, minHeight: minH),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(inputRadius),
                  border: Border.all(
                      color: const Color.fromARGB(255, 223, 221, 221)),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: listVPad),
                  itemBuilder: (_, index) {
                    final owner = options.elementAt(index);
                    return InkWell(
                      onTap: () => onOptionSelected(owner),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: listHPad, vertical: listVPad),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: avatarRadius,
                              backgroundColor: const Color(0xFFF2F2F2),
                              backgroundImage: owner.avatar.isNotEmpty
                                  ? AssetImage(owner.avatar)
                                  : null,
                              child: owner.avatar.isEmpty
                                  ? const Icon(Icons.person, color: Colors.grey)
                                  : null,
                            ),
                            SizedBox(
                                width: IntakeLayoutTokens.gridSpacing(context)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    owner.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          IntakeLayoutTokens.smallFont(context),
                                    ),
                                  ),
                                  SizedBox(
                                      height: IntakeLayoutTokens.xSmallSpacing(
                                          context)),
                                  Text(
                                    owner.phone,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF757575),
                                      fontSize:
                                          IntakeLayoutTokens.smallFont(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              owner.unit,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF2F80ED),
                                fontWeight: FontWeight.w600,
                                fontSize: IntakeLayoutTokens.smallFont(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Color.fromARGB(255, 216, 213, 213),
                  ),
                  itemCount: options.length,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyInstallments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double sectionTitleSize =
        IntakeLayoutTokens.sectionTitleFont(context);
    final double topPad = IntakeLayoutTokens.sectionPadding(context);
    final double dividerWidthFactor =
        ResponsiveUtils.isDesktop(context) ? 0.5 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(topPad),
          child: Text(
            'Installments',
            style: TextStyle(
              fontSize: sectionTitleSize,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: dividerWidthFactor,
          alignment: Alignment.centerLeft,
          child: const Divider(
            thickness: 1,
            height: 1,
            color: Color.fromRGBO(234, 234, 234, 1.0),
          ),
        ),
        SizedBox(height: IntakeLayoutTokens.xLargeSpacing(context)),
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: ResponsiveUtils.scaleWidth(context, 72,
                        min: 56, max: 88),
                    height: ResponsiveUtils.scaleWidth(context, 72,
                        min: 56, max: 88),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(
                        IntakeLayoutTokens.cardRadius(context),
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/group.png',
                      width: ResponsiveUtils.scaleWidth(context, 36,
                          min: 28, max: 44),
                      height: ResponsiveUtils.scaleWidth(context, 36,
                          min: 28, max: 44),
                    ),
                  ),
                  Positioned(
                    bottom:
                        ResponsiveUtils.scaleHeight(context, 6, min: 4, max: 8),
                    right:
                        ResponsiveUtils.scaleWidth(context, 6, min: 4, max: 8),
                    child: Container(
                      width: ResponsiveUtils.scaleWidth(context, 24,
                          min: 18, max: 28),
                      height: ResponsiveUtils.scaleWidth(context, 24,
                          min: 18, max: 28),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD166),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '\$',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.scaleFont(context, 14,
                                min: 12, max: 16),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),
              Text(
                'Choose a User to see Installments',
                style: TextStyle(
                  fontSize: IntakeLayoutTokens.placeholderBodyFont(context),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

extension _BorderRadiusDouble on double {
  BorderRadius get toRadius => BorderRadius.circular(this);
  double let(double Function(double) f) => f(this);
}

class _OwnerDetailsAndInstallments extends StatelessWidget {
  final Owner owner;
  const _OwnerDetailsAndInstallments({required this.owner});

  @override
  Widget build(BuildContext context) {
    final double sectionTitleSize =
        IntakeLayoutTokens.sectionTitleFont(context);
    final double sectionPad = IntakeLayoutTokens.sectionPadding(context);
    final double dividerSpace =
        IntakeLayoutTokens.dividerCompactSpacing(context);

    // Table height responsive per device
    final double tableHeight = ResponsiveUtils.isDesktop(context)
        ? ResponsiveUtils.scaleHeight(context, 700, min: 520, max: 840)
        : ResponsiveUtils.scaleHeight(context, 520, min: 420, max: 680);

    return SingleChildScrollView(
      padding: ResponsiveUtils.insetSymmetric(context, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(sectionPad),
            child: Text(
              'Installments',
              style: TextStyle(
                fontSize: sectionTitleSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const FractionallySizedBox(
            widthFactor: 1.0,
            alignment: Alignment.centerLeft,
            child: Divider(
              thickness: 1,
              height: 1,
              color: Color.fromRGBO(233, 231, 231, 1),
            ),
          ),
          SizedBox(height: dividerSpace),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: IntakeLayoutTokens.horizontalPadding(context),
            ),
            child: InvoiceTable(
              data: owner.installments,
              height: tableHeight,
            ),
          ),
          SizedBox(height: IntakeLayoutTokens.smallSpacing(context)),
        ],
      ),
    );
  }
}
