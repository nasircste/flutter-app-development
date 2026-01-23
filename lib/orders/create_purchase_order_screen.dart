import 'package:flutter/material.dart';
import 'package:real_estate_flutter/screens/orders/popups/add_item_popup.dart';
import 'package:real_estate_flutter/widgets/common/custom_button.dart';
import 'package:real_estate_flutter/widgets/common/custom_search_dropdown.dart';
import 'package:real_estate_flutter/widgets/common/custom_text_field.dart';
import 'package:real_estate_flutter/widgets/common/shared_top_bar.dart';
import 'package:real_estate_flutter/utils/responsive_utils.dart';

class CreatePurchaseOrderPage extends StatefulWidget {
  const CreatePurchaseOrderPage({Key? key}) : super(key: key);

  @override
  State<CreatePurchaseOrderPage> createState() =>
      _CreatePurchaseOrderPageState();
}

class _CreatePurchaseOrderPageState extends State<CreatePurchaseOrderPage> {
  final TextEditingController _purchaseOrderController =
      TextEditingController();
  final TextEditingController _requisitionController = TextEditingController();
  final TextEditingController _paymentDaysController = TextEditingController();

  //Project Information controller
  final TextEditingController _projectAddressController =
      TextEditingController();
  final TextEditingController _projectMobileController =
      TextEditingController();

  //Supplier Information controller
  final TextEditingController _supplierAddressController =
      TextEditingController();
  final TextEditingController _supplierMobileController =
      TextEditingController();
  final TextEditingController _supplierIdController = TextEditingController();

  final _addressController = TextEditingController();
  bool _addressError = false;

  bool _locationError = false;
  final LayerLink _locationLayerLink = LayerLink();
  OverlayEntry? _locationOverlayEntry;
  final FocusNode _locationFocusNode = FocusNode();
  List<String> _filteredAddresses = [];

  // Dummy addresses
  final List<String> _projectallAddresses = [
    'House 10, Road 5, Gulshan 1, Dhaka 1212',
    'Flat 3B, Block C, Banani, Dhaka 1213',
    'Plot 25, Sector 7, Uttara, Dhaka 1230',
    'House 15, Road 27, Dhanmondi, Dhaka 1209',
    'Apartment 5A, Mohakhali DOHS, Dhaka 1206',
    'Villa 8, Bashundhara R/A, Dhaka 1229',
    'House 12, Road 3, Baridhara, Dhaka 1212',
    'Flat 2C, Mirpur DOHS, Dhaka 1216',
  ];

  // Dummy addresses
  final List<String> _supplierallAddresses = [
    'House 10, Road 5, Gulshan 1, Dhaka 1212',
    'Flat 3B, Block C, Banani, Dhaka 1213',
    'Plot 25, Sector 7, Uttara, Dhaka 1230',
    'House 15, Road 27, Dhanmondi, Dhaka 1209',
    'Apartment 5A, Mohakhali DOHS, Dhaka 1206',
    'Villa 8, Bashundhara R/A, Dhaka 1229',
    'House 12, Road 3, Baridhara, Dhaka 1212',
    'Flat 2C, Mirpur DOHS, Dhaka 1216',
  ];

  @override
  void initState() {
    super.initState();
    _projectAddressController.addListener(_onLocationSearchChanged);
    _locationFocusNode.addListener(_onLocationFocusChange);
  }

  void _onLocationSearchChanged() {
    final query = _projectAddressController.text.toLowerCase();
    if (query.isEmpty) {
      _removeLocationOverlay();
      return;
    }

    setState(() {
      _filteredAddresses = _projectallAddresses
          .where((address) => address.toLowerCase().contains(query))
          .toList();
    });

    if (_filteredAddresses.isNotEmpty) {
      _showLocationOverlay();
    } else {
      _removeLocationOverlay();
    }
  }

  void _onLocationFocusChange() {
    if (!_locationFocusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _removeLocationOverlay();
      });
    }
  }

  void _showLocationOverlay() {
    _removeLocationOverlay();

    _locationOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: ResponsiveUtils.isMobile(context)
            ? ResponsiveUtils.width(context) * 0.9
            : 450,
        child: CompositedTransformFollower(
          link: _locationLayerLink,
          showWhenUnlinked: false,
          offset: Offset(
              0, ResponsiveUtils.scaleHeight(context, 60, min: 50, max: 65)),
          child: Material(
            elevation: 8,
            borderRadius: ResponsiveUtils.radius(context, 8),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: ResponsiveUtils.scaleHeight(context, 200,
                    min: 150, max: 250),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: ResponsiveUtils.radius(context, 8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredAddresses.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _projectAddressController.text =
                            _filteredAddresses[index];
                        _locationError = false;
                      });
                      _removeLocationOverlay();
                      _locationFocusNode.unfocus();
                    },
                    child: Container(
                      padding: ResponsiveUtils.insetSymmetric(
                        context,
                        horizontal: 16,
                        vertical: 12,
                        minH: 12,
                        minV: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: index == _filteredAddresses.length - 1
                                ? Colors.transparent
                                : const Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        _filteredAddresses[index],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: IntakeLayoutTokens.smallFont(context),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF3F3F3F),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_locationOverlayEntry!);
  }

  void _removeLocationOverlay() {
    _locationOverlayEntry?.remove();
    _locationOverlayEntry = null;
  }

  @override
  void dispose() {
    _removeLocationOverlay();
    _projectAddressController.removeListener(_onLocationSearchChanged);
    _locationFocusNode.removeListener(_onLocationFocusChange);
    _locationFocusNode.dispose();

    _purchaseOrderController.dispose();
    _requisitionController.dispose();
    _projectAddressController.dispose();
    _projectMobileController.dispose();
    _supplierMobileController.dispose();
    _supplierIdController.dispose();
    _paymentDaysController.dispose();
    _addressController.dispose();
    _supplierAddressController.dispose();
    super.dispose();
  }

  // Checkbox states
  bool _isPaymentDueChecked = false;
  bool _isMaterialConditionChecked = false;
  bool _isDeliveryChallanChecked = false;

  String? _selectedSupplier;
  DateTime _selectedDate = DateTime.now();

  List<Map<String, dynamic>> _items = [];

  void _showAddItemDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AddItemDialog();
      },
    );

    if (result != null) {
      setState(() {
        _items.add(result);
      });
    }
  }

  double _calculateSubtotal() {
    double subtotal = 0;
    for (var item in _items) {
      final totalAmount = double.tryParse(
              item['totalAmount']?.toString().replaceAll(',', '') ?? '0') ??
          0;
      subtotal += totalAmount;
    }
    return subtotal;
  }

  String _formatNumber(String number) {
    final parts = number.split('.');
    final integerPart = parts[0];
    final regex = RegExp(r'\B(?=(\d{3})+(?!\d))');
    final formatted = integerPart.replaceAllMapped(regex, (match) => ',');
    return parts.length > 1 ? '$formatted. ${parts[1]}' : formatted;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            const SharedTopBar(
              selectedIndex: 0,
              role: 'ceo',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Padding(
                      padding: ResponsiveUtils.insetLTRB(
                        context,45.0,10.0,45.0,0.0
                      
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Create Purchase Order',
                              style: TextStyle(
                                fontSize:
                                    IntakeLayoutTokens.pageTitleFont(context),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF3F3F3F),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: IntakeLayoutTokens.smallSpacing(context)),
                          GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color(0xFF424242),
                                        onPrimary: Colors.white,
                                        onSurface: Color(0xFF424242),
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              const Color(0xFF424242),
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null && picked != _selectedDate) {
                                setState(() {
                                  _selectedDate = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: ResponsiveUtils.insetSymmetric(
                                context,
                                horizontal: 16,
                                vertical: 10,
                                minH: 10,
                                minV: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius:
                                    ResponsiveUtils.radius(context, 5),
                                border:
                                    Border.all(color: const Color(0xFF868686)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${_selectedDate.day.toString().padLeft(2, '0')} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                                    style: TextStyle(
                                      fontSize:
                                          IntakeLayoutTokens.inputFont(context),
                                      color: const Color(0xFF2A2A2A),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                      width: IntakeLayoutTokens.smallSpacing(
                                          context)),
                                  Image.asset(
                                    'assets/images/vector.png',
                                    width: IntakeLayoutTokens.smallIconSize(
                                        context),
                                    height: IntakeLayoutTokens.smallIconSize(
                                        context),
                                    color: const Color(0xFF757575),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),

                    // Cards Section - Responsive Layout
                    Padding(
                      padding: ResponsiveUtils.insetSymmetric(
                        context,
                        horizontal: 50,
                        minH: 16,
                        maxH: 72,
                      ),
                      child: _buildCardsSection(isMobile, isTablet, isDesktop),
                    ),

                    SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),

                    // Item List Section
                    Container(
                            padding: ResponsiveUtils.insetSymmetric(
                                context,
                                horizontal: 16,
                                vertical: 10,
                                minH: 10,
                                minV: 6,
                              ),
                            
                      child: _buildItemListSection(isMobile, isTablet, isDesktop)
                      
                      
                      ),

                    SizedBox(
                        height: IntakeLayoutTokens.xxLargeSpacing(context)),

                    // Create Purchase Order Button
                    Center(
                      child: SizedBox(
                        height: IntakeLayoutTokens.buttonHeight(context) + 17,
                        width: ResponsiveUtils.scaleWidth(context, 301,
                            min: 200, max: 340),
                        child: CustomButton(
                          onPressed: () {
                            // Create purchase order logic
                          },
                          text: 'Create Purchase Order',
                           
                        ),
                      ),
                    ),
                    SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



Widget _buildCardsSection(bool isMobile, bool isTablet, bool isDesktop) {
  if (isMobile) {
    // Mobile:   All cards in a single column
    return Column(
      children: [
        _buildPurchaseOrderRequisitionCard(),
        SizedBox(height: IntakeLayoutTokens.cardSpacing(context)),
        _buildTermsAndConditionCard(),
        SizedBox(height: IntakeLayoutTokens.cardSpacing(context)),
        _buildProjectInformationCard(),
        SizedBox(height: IntakeLayoutTokens.cardSpacing(context)),
        _buildSupplierInformationCard(),
      ],
    );
  } else if (isTablet) {
    // Tablet: Purchase Order & Requisition + Terms & Condition (left column)
    // Project Information (right column)
    // Supplier Information (full row below)
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Column:  Purchase Order & Terms
              Expanded(
                flex: 1,
                child: Column(
                  children:  [
                    _buildPurchaseOrderRequisitionCard(),
                    SizedBox(height:  IntakeLayoutTokens.cardSpacing(context)),
                    Expanded(child: _buildTermsAndConditionCard()),
                  ],
                ),
              ),
              SizedBox(width: IntakeLayoutTokens.cardSpacing(context)),
              
              // Right Column: Project Information
              Expanded(
                flex:  1,
                child: _buildProjectInformationCard(),
              ),
            ],
          ),
        ),
        SizedBox(height:  IntakeLayoutTokens. cardSpacing(context)),
        
        // Full Row: Supplier Information
        _buildSupplierInformationCard(),
      ],
    );
  } else {
    // Desktop: Original 3-column layout
    return IntrinsicHeight(
      child:  Row(
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        children: [
          // Left Card
          Expanded(
            flex: 1,
            child:    Column(
              children: [
                _buildPurchaseOrderRequisitionCard(),
                SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),
                Expanded(child: _buildTermsAndConditionCard()),
              ],
            ),
          ),
          SizedBox(width: IntakeLayoutTokens.cardSpacing(context)),
          Expanded(
            flex:  1,
            child: _buildProjectInformationCard(),
          ),
          SizedBox(width: IntakeLayoutTokens. cardSpacing(context)),
          Expanded(
            flex: 1,
            child: _buildSupplierInformationCard(),
          ),
        ],
      ),
    );
  }
}





  Widget _buildPurchaseOrderRequisitionCard() {
    return Container(
      padding: ResponsiveUtils.insetAll(context, 20, min: 12, max: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: ResponsiveUtils.radius(context, 10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: IntakeLayoutTokens.cardShadowBlur(context) * 2.2,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomTextField(
              controller: _purchaseOrderController,
              label: 'Purchase Order No',
              hint: '000',
              width:
                  ResponsiveUtils.scaleWidth(context, 141, min: 100, max: 160),
            ),
          ),
          SizedBox(width: IntakeLayoutTokens.mediumSpacing(context)),
          Expanded(
            child: CustomTextField(
              controller: _requisitionController,
              label: 'Requisition No',
              hint: '000',
              width:
                  ResponsiveUtils.scaleWidth(context, 141, min: 100, max: 160),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditionCard() {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: ResponsiveUtils.radius(context, 10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: IntakeLayoutTokens.cardShadowBlur(context) * 2.2,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveUtils.insetLTRB(context, 18, 15, 18, 6,
                minH: 12, minV: 10),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/terms.png',
                  width: IntakeLayoutTokens.smallIconSize(context),
                  height: IntakeLayoutTokens.smallIconSize(context),
                  color: const Color(0xFF3F3F3F),
                ),
                SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
                Text(
                  'Terms and Condition',
                  style: TextStyle(
                    fontSize: IntakeLayoutTokens.inputFont(context),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3F3F3F),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),
          const Divider(
            color: Color(0xFFEAEAEA),
            thickness: 1,
            height: 1,
          ),
          SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),

          // 1st Row
          Padding(
            padding: ResponsiveUtils.insetLTRB(context, 18, 10, 18, 1,
                minH: 12, minV: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width:
                      ResponsiveUtils.scaleWidth(context, 20, min: 16, max: 22),
                  height:
                      ResponsiveUtils.scaleWidth(context, 20, min: 16, max: 22),
                  child: Checkbox(
                    value: _isPaymentDueChecked,
                    onChanged: (value) {
                      setState(() {
                        _isPaymentDueChecked = value ?? false;
                      });
                    },
                    shape: const CircleBorder(),
                    activeColor: const Color(0xFF4CAF50),
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xFF4CAF50);
                        }
                        return Colors.transparent;
                      },
                    ),
                    side: const BorderSide(
                      color: Color(0xFFBDBDBD),
                      width: 1.5,
                    ),
                  ),
                ),
                SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
                Flexible(
                  child: Text(
                    'Total Payment Due',
                    style: TextStyle(
                      fontSize: IntakeLayoutTokens.smallFont(context) + 2,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8F8F8F),
                    ),
                  ),
                ),
                SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
                Container(
                  width:
                      ResponsiveUtils.scaleWidth(context, 50, min: 40, max: 60),
                  height: ResponsiveUtils.scaleHeight(context, 34,
                      min: 30, max: 38),
                  child: TextFormField(
                    controller: _paymentDaysController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: IntakeLayoutTokens.smallFont(context) + 2,
                      fontFamily: 'Poppins',
                      color: const Color(0xFF3F3F3F),
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFEBEBEB),
                      border: OutlineInputBorder(
                        borderRadius: ResponsiveUtils.radius(context, 5),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: ResponsiveUtils.insetSymmetric(
                        context,
                        horizontal: 4,
                        vertical: 8,
                        minH: 3,
                        minV: 6,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
                Flexible(
                  child: Text(
                    isMobile ? 'Days' : 'Days after completion.',
                    style: TextStyle(
                      fontSize: IntakeLayoutTokens.smallFont(context) + 2,
                      fontFamily: 'Poppins',
                      color: const Color(0xFF8F8F8F),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: IntakeLayoutTokens.smallSpacing(context) + 4),

          // 2nd Row
          Padding(
            padding: ResponsiveUtils.insetLTRB(context, 18, 1, 18, 1,
                minH: 12, minV: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: SizedBox(
                    width: ResponsiveUtils.scaleWidth(context, 20,
                        min: 16, max: 22),
                    height: ResponsiveUtils.scaleWidth(context, 20,
                        min: 16, max: 22),
                    child: Checkbox(
                      value: _isMaterialConditionChecked,
                      onChanged: (value) {
                        setState(() {
                          _isMaterialConditionChecked = value ?? false;
                        });
                      },
                      shape: const CircleBorder(),
                      activeColor: const Color(0xFF4CAF50),
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFF4CAF50);
                          }
                          return Colors.transparent;
                        },
                      ),
                      side: const BorderSide(
                        color: Color(0xFFBDBDBD),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
                Expanded(
                  child: Text(
                    'Material Should be received in good condition',
                    style: TextStyle(
                      fontSize: IntakeLayoutTokens.smallFont(context) + 2,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8F8F8F),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: IntakeLayoutTokens.smallSpacing(context) + 4),

          // 3rd Row
          Padding(
            padding: ResponsiveUtils.insetLTRB(context, 18, 1, 18, 22,
                minH: 12, minV: 8, maxV: 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: SizedBox(
                    width: ResponsiveUtils.scaleWidth(context, 20,
                        min: 16, max: 22),
                    height: ResponsiveUtils.scaleWidth(context, 20,
                        min: 16, max: 22),
                    child: Checkbox(
                      value: _isDeliveryChallanChecked,
                      onChanged: (value) {
                        setState(() {
                          _isDeliveryChallanChecked = value ?? false;
                        });
                      },
                      shape: const CircleBorder(),
                      activeColor: const Color(0xFF4CAF50),
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFF4CAF50);
                          }
                          return Colors.transparent;
                        },
                      ),
                      side: const BorderSide(
                        color: Color(0xFFBDBDBD),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
                Expanded(
                  child: Text(
                    'Please send the bill with delivery challan received copy.',
                    style: TextStyle(
                      fontSize: IntakeLayoutTokens.smallFont(context) + 2,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8F8F8F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectInformationCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: ResponsiveUtils.radius(context, 10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: IntakeLayoutTokens.cardShadowBlur(context) * 2.2,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveUtils.insetLTRB(context, 18, 15, 18, 6,
                minH: 12, minV: 10),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/project.png',
                  width: IntakeLayoutTokens.iconSize(context) - 2,
                  height: IntakeLayoutTokens.iconSize(context) - 2,
                  color: const Color(0xFF3F3F3F),
                ),
                SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
                Text(
                  'Project Information',
                  style: TextStyle(
                    fontSize: IntakeLayoutTokens.inputFont(context),
                    fontFamily: 'Poppins',
                    color: const Color(0xFF3F3F3F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: IntakeLayoutTokens.mediumSpacing(context) - 1),
          const Divider(
            color: Color(0xFFEAEAEA),
            thickness: 1,
            height: 1,
          ),
          SizedBox(height: IntakeLayoutTokens.smallSpacing(context)),

          // Project Address
          Padding(
            padding: ResponsiveUtils.insetLTRB(context, 18, 15, 18, 6,
                minH: 12, minV: 10),
            child: CustomSearchDropdown(
              controller: _projectAddressController,
              label: 'Project Address',
              hint: 'Write Down the Address',
              focusNode: _locationFocusNode,
              errorText: _locationError ? 'This field is required' : null,
            ),
          ),
          SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),

          // Project Mobile No
          Padding(
            padding: ResponsiveUtils.insetLTRB(context, 18, 0, 18, 6,
                minH: 12, minV: 10),
            child: CustomTextField(
              controller: _projectMobileController,
              label: 'Mobile No',
              hint: '+880',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierInformationCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: ResponsiveUtils.radius(context, 10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: IntakeLayoutTokens.cardShadowBlur(context) * 2.2,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveUtils.insetLTRB(context, 18, 15, 18, 6,
                minH: 12, minV: 10),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/supplier.png',
                  width: IntakeLayoutTokens.iconSize(context) - 2,
                  height: IntakeLayoutTokens.iconSize(context) - 2,
                  color: const Color(0xFF3F3F3F),
                ),
                SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
                Text(
                  'Supplier Information',
                  style: TextStyle(
                    fontSize: IntakeLayoutTokens.inputFont(context),
                    fontFamily: 'Poppins',
                    color: const Color(0xFF3F3F3F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: IntakeLayoutTokens.mediumSpacing(context) - 2),
          const Divider(
            color: Color(0xFFEAEAEA),
            thickness: 1,
            height: 1,
          ),
          SizedBox(height: IntakeLayoutTokens.smallSpacing(context)),

          // Supplier Address
          Padding(
            padding: ResponsiveUtils.insetLTRB(context, 18, 15, 18, 6,
                minH: 12, minV: 10),
            child: CustomSearchDropdown(
              controller: _addressController,
              label: 'Supplier Address',
              hint: 'Select a Supplier',
              errorText: _addressError ? 'This field is required' : null,
            ),
          ),

          SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),

          // Mobile No and Supplier ID Row
          Padding(
            padding: ResponsiveUtils.insetLTRB(context, 18, 0, 18, 6,
                minH: 12, minV: 10),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _supplierMobileController,
                    label: 'Mobile No',
                    hint: '+880',
                  ),
                ),
                SizedBox(width: IntakeLayoutTokens.smallSpacing(context) + 4),
                Expanded(
                  child: CustomTextField(
                    controller: _supplierIdController,
                    label: 'Supplier ID',
                    hint: '000',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemListSection(bool isMobile, bool isTablet, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveUtils.insetSymmetric(
              context,
              horizontal: 50,
              minH: 16,
              maxH: 72,
            ),
            child: Text(
              'Item List',
              style: TextStyle(
                fontSize: IntakeLayoutTokens.sectionTitleFont(context),
                fontFamily: 'Poppins',
                color: const Color(0xFF3F3F3F),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),

          // Table
          isMobile ? _buildMobileItemList() : _buildDesktopItemList(),

          SizedBox(height: IntakeLayoutTokens.xSmallSpacing(context)),

          // Add Item Button
          Padding(
            padding: ResponsiveUtils.insetSymmetric(
              context,
              horizontal: 50,
              minH: 16,
              maxH: 72,
            ),
            child: TableBorderContainer(
              child: InkWell(
                onTap: () {
                  _showAddItemDialog();
                },
                child: Container(
                  padding: ResponsiveUtils.insetSymmetric(
                    context,
                    vertical: 10,
                    minV: 8,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/add_icon.png',
                          width: IntakeLayoutTokens.smallIconSize(context) - 1,
                          height: IntakeLayoutTokens.smallIconSize(context) - 1,
                          color: const Color(0xFF3F3F3F),
                        ),
                        SizedBox(
                            width: IntakeLayoutTokens.smallSpacing(context)),
                        Text(
                          'Click here to add Item',
                          style: TextStyle(
                            fontSize:
                                IntakeLayoutTokens.buttonFont(context) ,
                            fontFamily: 'Poppins',
                            color: const Color(0xFFB3B3B3),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: IntakeLayoutTokens.xSmallSpacing(context) ),

          // Subtotal row
          if (_items.isNotEmpty)
            Padding(
              padding: ResponsiveUtils.insetSymmetric(
                context,
                horizontal: 50,
                minH: 16,
                maxH: 72,
              ),
              child: Container(
                margin: EdgeInsets.only(
                    top: IntakeLayoutTokens.xSmallSpacing(context)),
                padding: ResponsiveUtils.insetSymmetric(
                  context,
                  horizontal: 16,
                  vertical: 12,
                  minH: 12,
                  minV: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: ResponsiveUtils.radius(context, 5),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: ResponsiveUtils.scaleWidth(context, 100,
                          min: 60, max: 120),
                      child: Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: IntakeLayoutTokens.inputFont(context),
                          fontFamily: 'Poppins',
                          color: const Color(0xFF3F3F3F),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Padding(
                      padding: EdgeInsets.only(
                        right: ResponsiveUtils.scaleWidth(context, 50,
                            min: 16, max: 100),
                      ),
                      child: SizedBox(
                        width: ResponsiveUtils.scaleWidth(context, 250,
                            min: 120, max: 280),
                        child: Text(
                          _formatNumber(
                              _calculateSubtotal().toStringAsFixed(0)),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: IntakeLayoutTokens.inputFont(context),
                            fontFamily: 'Poppins',
                            color: const Color(0xFF3F3F3F),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

Widget _buildMobileItemList() {
  return Padding(
    padding: ResponsiveUtils.insetSymmetric(
      context,
      horizontal: 50,
      minH: 16,
      maxH: 72,
    ),
    child: Column(
      children: [
        // Header
        Container(
          padding:  ResponsiveUtils.insetSymmetric(
            context,
            horizontal: 8,
            vertical: 10,
            minH: 8,
            minV: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: ResponsiveUtils.radius(context, 5),
          ),
          child: Row(
            children: [
              // SL
              SizedBox(
                width: 30,
                child: Text(
                  'SL',
                  style: TextStyle(
                    fontSize: IntakeLayoutTokens.smallFont(context) ,
                    fontFamily: 'Poppins',
                    color: const Color(0xFF3F3F3F),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Name
              Expanded(
                flex: 1,
                child:  Text(
                  'Name',
                  style: TextStyle(
                    fontSize: IntakeLayoutTokens.smallFont(context) ,
                    fontFamily: 'Poppins',
                    color: const Color(0xFF3F3F3F),
                    fontWeight:  FontWeight.w400,
                  ),
                ),
              ),
              // Description
              Expanded(
                flex:  2,
                child: Text(
                  'Description',
                  style: TextStyle(
                    fontSize: IntakeLayoutTokens. smallFont(context) ,
                    fontFamily: 'Poppins',
                    color: const Color(0xFF3F3F3F),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Unit
              SizedBox(
                width: 35,
                child: Text(
                  'Unit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: IntakeLayoutTokens.smallFont(context) ,
                    fontFamily: 'Poppins',
                    color: const Color(0xFF3F3F3F),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Quantity
              SizedBox(
                width: 45,
                child: Text(
                  'Qty',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: IntakeLayoutTokens.smallFont(context) ,
                    fontFamily: 'Poppins',
                    color: const Color(0xFF3F3F3F),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Unit Price
              SizedBox(
                width:  50,
                child: Text(
                  'Price',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: IntakeLayoutTokens.smallFont(context) ,
                    fontFamily: 'Poppins',
                    color: const Color(0xFF3F3F3F),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Total Amount
              SizedBox(
                width: 60,
                child: Text(
                  'Total',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: IntakeLayoutTokens.smallFont(context) ,
                    fontFamily: 'Poppins',
                    color: const Color(0xFF3F3F3F),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: IntakeLayoutTokens.xSmallSpacing(context) ),

        // Items
        if (_items.isNotEmpty)
          ... List.generate(_items.length, (index) {
            final item = _items[index];
            return Container(
              margin: EdgeInsets.only(
                bottom: IntakeLayoutTokens.xSmallSpacing(context),
              ),
              padding: ResponsiveUtils.insetSymmetric(
                context,
                horizontal: 8,
                vertical: 10,
                minH: 8,
                minV: 10,
              ),
              decoration:  BoxDecoration(
                color:  const Color(0xFFF1F1F1),
                borderRadius: ResponsiveUtils.radius(context, 5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Serial No
                  SizedBox(
                    width: 30,
                    child: Text(
                      item['serialNo'] ?? '',
                      style: TextStyle(
                        fontSize: IntakeLayoutTokens.smallFont(context) ,
                        fontFamily: 'Poppins',
                        color: const Color(0xFF3F3F3F),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  // Name
                  Expanded(
                    flex: 1,
                    child: Text(
                      item['itemName'] ?? '',
                      style: TextStyle(
                        fontSize: IntakeLayoutTokens.smallFont(context) ,
                        fontFamily: 'Poppins',
                        color: const Color(0xFF3F3F3F),
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Description
                  Expanded(
                    flex: 2,
                    child: Text(
                      item['description'] ?? '',
                      style:  TextStyle(
                        fontSize:  IntakeLayoutTokens.smallFont(context) ,
                        fontFamily: 'Poppins',
                        color: const Color(0xFF3F3F3F),
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Unit
                  SizedBox(
                    width:  35,
                    child:  Text(
                      item['unit'] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: IntakeLayoutTokens.smallFont(context) ,
                        fontFamily: 'Poppins',
                        color: const Color(0xFF3F3F3F),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  // Quantity
                  SizedBox(
                    width: 45,
                    child: Text(
                      item['quantity'] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: IntakeLayoutTokens.smallFont(context) ,
                        fontFamily: 'Poppins',
                        color: const Color(0xFF3F3F3F),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  // Unit Price
                  SizedBox(
                    width: 50,
                    child: Text(
                      item['unitPrice'] ??  '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: IntakeLayoutTokens.smallFont(context) ,
                        fontFamily: 'Poppins',
                        color: const Color(0xFF3F3F3F),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  // Total Amount
                  SizedBox(
                    width:  60,
                    child:  Text(
                      item['totalAmount'] ?? '',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: IntakeLayoutTokens.smallFont(context) ,
                        fontFamily: 'Poppins',
                        color: const Color(0xFF3F3F3F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    ),
  );
}




Widget _buildDesktopItemList() {
  return Column(
    children: [
      // Header
      Padding(
        padding: ResponsiveUtils.insetSymmetric(
          context,
          horizontal: 50,
          minH: 16,
          maxH: 72,
        ),
        child: Container(
          padding: ResponsiveUtils.insetSymmetric(
            context,
            horizontal: 16,
            vertical: 12,
            minH: 12,
            minV: 8,
          ),
          decoration:  BoxDecoration(
            color:  const Color(0xFFE8E8E8),
            borderRadius: ResponsiveUtils.radius(context, 5),
          ),
          child: _buildTableHeader(),
        ),
      ),
      SizedBox(height: IntakeLayoutTokens.xSmallSpacing(context)),

      // Items
      if (_items.isNotEmpty)
        ... List.generate(_items.length, (index) {
          final item = _items[index];
          return Padding(
            padding: ResponsiveUtils.insetSymmetric(
              context,
              horizontal: 50,
              minH: 16,
              maxH: 72,
            ),
            child: Container(
              margin: EdgeInsets.only(
                bottom: ResponsiveUtils.scaleHeight(context, 8, min: 6, max: 10),
              ),
              padding: ResponsiveUtils.insetSymmetric(
                context,
                horizontal: 16,
                vertical: 12,
                minH: 12,
                minV: 10,
              ),
              decoration:  BoxDecoration(
                color:  const Color(0xFFF1F1F1),
                borderRadius: ResponsiveUtils.radius(context, 5),
              ),
              child: _buildTableRow(item),
            ),
          );
        }),
    ],
  );
}

Widget _buildTableHeader() {
   return Padding(
    padding: EdgeInsets.only(
      left: ResponsiveUtils.scaleWidth(context, 0, min: 0, max: 0),  
      right: ResponsiveUtils.scaleWidth(context, 16, min: 12, max: 20),
    ),
  child: Row(
    children: [
      // SL
      Expanded(
        flex: 1,
        child:  Text(
          'SL',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens. inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      // Name
      Expanded(
        flex: 1,
        child:  Text(
          'Name',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens.inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight:  FontWeight.w400,
          ),
        ),
      ),
      // Description
      Expanded(
        flex: 2,
        child: Text(
          'Description',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens.inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight: FontWeight. w400,
          ),
        ),
      ),
      // Unit
      Expanded(
        flex: 1,
        child:  Text(
          'Unit',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens.inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight:  FontWeight.w400,
          ),
        ),
      ),
      // Quantity
      Expanded(
        flex: 1,
        child: Text(
          'Quantity',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens.inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      // Unit Price
      Expanded(
        flex: 1,
        child: Text(
          'Unit Price',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens.inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      // Total Amount
      Expanded(
        flex: 1,
        child: Text(
          'Total Amount',
          textAlign:  TextAlign.center,
          style: TextStyle(
            fontSize:  IntakeLayoutTokens.inputFont(context),
            fontFamily:  'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ],
  )
   );
}

Widget _buildTableRow(Map<String, dynamic> item) {
    return Padding(
    padding: EdgeInsets.only(
      left: ResponsiveUtils.scaleWidth(context, 0, min: 0, max: 0),  
      right: ResponsiveUtils.scaleWidth(context, 16, min:  12, max: 20),
    ),
  
  child: Row(
    children: [
      // SL
      Expanded(
        flex: 1,
        child: Text(
          item['serialNo'] ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens.inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      // Name
      Expanded(
        flex: 1,
        child: Text(
          item['itemName'] ??  '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens.inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      // Description
      Expanded(
        flex: 2,
        child: Text(
          item['description'] ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens.inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight:  FontWeight.w400,
          ),
        ),
      ),
      // Unit
      Expanded(
        flex: 1,
        child: Text(
          item['unit'] ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens. inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      // Quantity
      Expanded(
        flex: 1,
        child: Text(
          item['quantity'] ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens.inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight: FontWeight. w400,
          ),
        ),
      ),
      // Unit Price
      Expanded(
        flex: 1,
        child: Text(
          item['unitPrice'] ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens.inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight: FontWeight. w400,
          ),
        ),
      ),
      // Total Amount
      Expanded(
        flex: 1,
        child: Text(
          item['totalAmount'] ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: IntakeLayoutTokens.inputFont(context),
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
            fontWeight:  FontWeight.w400,
          ),
        ),
      ),
    ],
  )
    );
}




  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

class TableBorderContainer extends StatelessWidget {
  final Widget child;

  const TableBorderContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TableBorderPainter(),
      child: child,
    );
  }
}

class TableBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD5D5D5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 20.0;
    const dashSpace = 20.0;
    const radius = 4.0;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(radius),
        ),
      );

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final segment = pathMetric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
