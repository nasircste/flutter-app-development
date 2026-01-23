import 'package:flutter/material.dart';
import 'package:real_estate_flutter/widgets/common/custom_dropdown.dart';
import 'package:real_estate_flutter/widgets/common/custom_text_field.dart';
import 'package:real_estate_flutter/utils/responsive_utils.dart';

class AddItemDialog extends StatefulWidget {
  AddItemDialog({Key? key}) : super(key: key);

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController _serialNoController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  String? _selectedUnit;

  @override
  void dispose() {
    _serialNoController. dispose();
    _itemNameController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _descriptionController.dispose();
    _totalAmountController. dispose();
    super.dispose();
  }

  void _calculateTotalAmount() {
    final quantity =
        double.tryParse(_quantityController.text. replaceAll(',', '')) ?? 0;
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0;
    final total = quantity * unitPrice;
    _totalAmountController.text = total.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final screenWidth = ResponsiveUtils.width(context);
    
    // Responsive dialog width
    double dialogWidth;
    if (isMobile) {
      dialogWidth = screenWidth * 0.92;
    } else if (isTablet) {
      dialogWidth = ResponsiveUtils.scaleWidth(context, 600, min: 500, max: 700);
    } else {
      dialogWidth = ResponsiveUtils. scaleWidth(context, 877, min: 700, max: 920);
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: ResponsiveUtils.radius(context, 10),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      insetPadding: isMobile 
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Container(
        width: dialogWidth,
        constraints: isMobile 
            ? BoxConstraints(maxHeight: ResponsiveUtils.height(context) * 0.88)
            : null,
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child:  Column(
            mainAxisSize:  MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: isMobile
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
                    : ResponsiveUtils.insetSymmetric(
                        context,
                        horizontal: 32,
                        vertical: 24,
                        minH: 20,
                        minV: 16,
                        maxH: 40,
                        maxV: 28,
                      ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Flexible(
                      child: Text(
                        'Add New Item',
                        style: TextStyle(
                          fontSize: isMobile 
                              ? 16
                              : isTablet
                                  ? IntakeLayoutTokens.sectionTitleFont(context)
                                  :  IntakeLayoutTokens.sectionTitleFont(context) + 2,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF3F3F3F),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon:  const Icon(Icons.close),
                      iconSize: isMobile ? 22 : ResponsiveUtils.scaleWidth(context, 28, min: 22, max:  32),
                      color: const Color(0xFF3F3F3F),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Divider
              const Divider(
                color: Color(0xFFEAEAEA),
                thickness: 1,
                height: 1,
              ),

              // Form Content
              Padding(
                padding: isMobile
                    ?  const EdgeInsets.all(16)
                    : ResponsiveUtils.insetAll(
                        context,
                        32,
                        min: 20,
                        max: 40,
                      ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Serial No and Item Name (ALWAYS IN ROW - even mobile)
                    Row(
                      children: [
                        Expanded(
                          flex: isMobile ? 1 : 1,
                          child: CustomTextField(
                            label: 'Serial No',
                            controller: _serialNoController,
                            hint: '04',
                          ),
                        ),
                        SizedBox(width: isMobile ? 12 : IntakeLayoutTokens.largeSpacing(context)),
                        Expanded(
                          flex: isMobile ? 2 : 3,
                          child: CustomTextField(
                            label: 'Item Name',
                            controller:  _itemNameController,
                            hint: 'Floor Tiles',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isMobile ? 14 : IntakeLayoutTokens. largeSpacing(context)),

                    // Row 2: Unit, Quantity, Unit Price (ALWAYS IN ROW - even mobile)
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomDropdown<String>(
                            label: 'Unit',
                            hint: 'Select Unit',
                            value: _selectedUnit,
                            items: const ['SFT', 'PCS', 'LTR'],
                            itemAsString: (String item) => item,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedUnit = newValue;
                              });
                            },
                            height: isMobile ? 42 : IntakeLayoutTokens. dropdownHeight(context) - 2,
                            borderRadius: isMobile ? 5 : IntakeLayoutTokens.inputRadius(context),
                          ),
                        ),
                        SizedBox(width: isMobile ? 10 : IntakeLayoutTokens. largeSpacing(context)),
                        Expanded(
                          flex: 1,
                          child: CustomTextField(
                            label: 'Quantity',
                            controller:  _quantityController,
                            hint: '8,000',
                            onChanged: (value) => _calculateTotalAmount(),
                          ),
                        ),
                        SizedBox(width: isMobile ? 10 : IntakeLayoutTokens.largeSpacing(context)),
                        Expanded(
                          flex: 1,
                          child: CustomTextField(
                            label: 'Unit Price',
                            controller:  _unitPriceController,
                            hint: '58. 5',
                            onChanged: (value) => _calculateTotalAmount(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isMobile ? 14 : IntakeLayoutTokens.largeSpacing(context)),

                    // Row 3: Description
                    CustomTextField(
                      label: 'Description',
                      controller:  _descriptionController,
                      hint: 'Homegenerous off White Sph-3301 12X12',
                    ),

                    SizedBox(height: isMobile ? 14 : IntakeLayoutTokens. largeSpacing(context)),

                    // Row 4: Total Amount
                    CustomTextField(
                      controller: _totalAmountController,
                      label: 'Total Amount',
                      readOnly: true,
                      hint: '4,68,000',
                      prefixText: '৳  ',
                    ),

                    SizedBox(height: isMobile ? 20 : IntakeLayoutTokens. xxLargeSpacing(context) - 8),

                    // Add Item Button
                    Center(
                      child: SizedBox(
                        width:  isMobile ? 140 :  ResponsiveUtils.scaleWidth(context, 178, min: 140, max:  200),
                        height: isMobile ? 44 : ResponsiveUtils.scaleHeight(context, 53, min: 44, max:  60),
                        child: ElevatedButton(
                          onPressed: () {
                            // Collect data
                            final itemData = {
                              'serialNo': _serialNoController.text,
                              'itemName': _itemNameController.text,
                              'unit': _selectedUnit,
                              'quantity': _quantityController. text,
                              'unitPrice': _unitPriceController. text,
                              'description':  _descriptionController.text,
                              'totalAmount': _totalAmountController.text,
                            };
                            Navigator.of(context).pop(itemData);
                          },
                          style: ElevatedButton. styleFrom(
                            backgroundColor:  const Color(0xFF1F89B7),
                            shape:  RoundedRectangleBorder(
                              borderRadius:  BorderRadius.circular(7),
                            ),
                            elevation:  0,
                          ),
                          child: Text(
                            'Add Item',
                            style: TextStyle(
                              fontSize: isMobile ? 14 : IntakeLayoutTokens. buttonFont(context) + 4,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}