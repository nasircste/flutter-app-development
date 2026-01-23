import 'package:flutter/material.dart';
import 'package:real_estate_flutter/utils/responsive_utils.dart';
import 'package:real_estate_flutter/widgets/common/custom_button.dart';
import 'package:real_estate_flutter/widgets/common/custom_dropdown.dart';
import 'package:real_estate_flutter/widgets/common/custom_text_field.dart';
import 'package:real_estate_flutter/widgets/common/universal_photo_uploader.dart';

class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({Key? key}) : super(key: key);

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedProject = 'Sky View Tower';

  List<PendingPhoto> _pendingPhotos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  DateTime _selectedDate = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtils.isTablet(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: ResponsiveUtils.radius(context, 10, min: 8, max: 12),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      child: Container(
        height: 950,
        width: MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.scaleWidth(context, 870, min: 300, max: 870),
        ),
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: ResponsiveUtils.insetLTRB(
                  context,
                  40, 30, 40, 30,
                  minH: 16, maxH: 40,
                  minV: 16, maxV: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Transaction',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.scaleFont(context, 30, min: 20, max: 30),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: const Color(0xFF3F3F3F),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: ResponsiveUtils.scaleWidth(context, 28, min: 20, max: 28),
                      ),
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

              // Tab Bar and Date Selector Row
              Padding(
                padding: ResponsiveUtils.insetLTRB(
                  context,
                  40, 30, 40, 0,
                  minH: 12, maxH: 40,
                  minV: 12, maxV: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: _buildTabBar(context)),
                    SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
                    _buildDateSelector(context),
                  ],
                ),
              ),
              SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),

              // Tab Bar View Content
              Column(
                children: [
                  SizedBox(
                    height: ResponsiveUtils.scaleHeight(
                      context,
                      isTablet ? 550 : 500,
                      min: 320,
                      max: 550,
                    ),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Cash In Content
                        _buildTransactionForm(context),

                        // Cash Out Content
                        _buildTransactionForm(context),
                      ],
                    ),
                  ),

                  // Create Transaction Button
                  Padding(
                    padding: ResponsiveUtils.insetAll(context, 18, min: 12, max: 20),
                    child: Center(
                      child: CustomButton(
                        text: 'Create Transaction',
                        onPressed: () {},
                        width: ResponsiveUtils.scaleWidth(context, 259, min: 180, max: 280),
                        height: ResponsiveUtils.scaleHeight(context, 47, min: 40, max: 52),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      width: ResponsiveUtils.scaleWidth(context, 280, min: 180, max: 320),
      height: ResponsiveUtils.scaleHeight(context, 50, min: 38, max: 58),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: ResponsiveUtils.radius(context, 8, min: 6, max: 10),
      ),
      padding: ResponsiveUtils.insetAll(context, 4, min: 3, max: 5),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFFD6F0FF),
          borderRadius: ResponsiveUtils.radius(context, 6, min: 4, max: 8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFF0097D9),
        unselectedLabelColor: const Color(0xFF9E9E9E),
        labelStyle: TextStyle(
          fontSize: ResponsiveUtils.scaleFont(context, 16, min: 11, max: 18),
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          color: const Color(0xFFAAB9BF),
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: ResponsiveUtils.scaleFont(context, 16, min: 11, max: 18),
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          color: const Color(0xFFAAB9BF),
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'Cash In',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: ResponsiveUtils.scaleWidth(context, 3, min: 2, max: 4)),
                Icon(Icons.arrow_downward, size: ResponsiveUtils.scaleWidth(context, 14, min: 10, max: 16)),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'Cash Out',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: ResponsiveUtils.scaleWidth(context, 3, min: 2, max: 4)),
                Icon(Icons.arrow_upward, size: ResponsiveUtils.scaleWidth(context, 14, min: 10, max: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return GestureDetector(
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
                    foregroundColor: const Color(0xFF424242),
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
          borderRadius: ResponsiveUtils.radius(context, 5),
          border: Border.all(color: const Color(0xFF868686)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/vector.png',
              width: IntakeLayoutTokens.smallIconSize(context),
              height: IntakeLayoutTokens.smallIconSize(context),
              color: const Color(0xFF757575),
            ),
            SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
            Text(
              '${_selectedDate.day.toString().padLeft(2, '0')} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
              style: TextStyle(
                fontSize: IntakeLayoutTokens.inputFont(context),
                color: const Color(0xFF2A2A2A),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionForm(BuildContext context) {
    return Padding(
      padding: ResponsiveUtils.insetSymmetric(
        context,
        horizontal: 40,
        minH: 12,
        maxH: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount and Project Row - Always Row layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildAmountField(context)),
              SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
              Expanded(child: _buildProjectDropdown(context)),
            ],
          ),
          SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),

          // Title, Description (Left) and Attachment (Right) Row - Always Row layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex:1, child: _buildTitleDescriptionFields(context)),
              SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
              Expanded(flex: 1, child: _buildAttachmentSection(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: IntakeLayoutTokens.smallSpacing(context)),
        CustomTextField(
          controller: _amountController,
          hint: '৳',
          label: 'Amount',
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: IntakeLayoutTokens.smallSpacing(context)),
        Text(
          'Current Balance ৳51,00,000',
          style: TextStyle(
            fontSize: ResponsiveUtils.scaleFont(context, 16, min: 12, max: 16),
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            color: const Color(0xFF1F89B7),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectDropdown(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: ResponsiveUtils.scaleHeight(context, 10, min: 6, max: 10)),
      child: CustomDropdown<String>(
        label: 'Project',
        hint: 'Sky View Tower',
        value: _selectedProject,
        items: const ['Sky View Tower', 'PCS', 'LTR'],
        itemAsString: (String item) => item,
        onChanged: (String? newValue) {
          setState(() {
            _selectedProject = newValue;
          });
        },
      ),
    );
  }

  Widget _buildTitleDescriptionFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ResponsiveUtils.scaleHeight(context, 2, min: 1, max: 2)),
        CustomTextField(
          controller: _titleController,
          hint: '',
          label: 'Title',
        ),
        SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),
        CustomTextField(
          controller: _descriptionController,
          label: 'Description',
          maxline: 4,
          hint: '',
          height: ResponsiveUtils.scaleHeight(context, 120, min: 80, max: 130),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: ResponsiveUtils.scaleWidth(context, 5, min: 3, max: 6)),
          child: Text(
            'Attachment',
            style: TextStyle(
              fontSize: ResponsiveUtils.scaleFont(context, 18, min: 12, max: 18),
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: const Color(0xFF3F3F3F),
            ),
          ),
        ),
        SizedBox(height: IntakeLayoutTokens.smallSpacing(context)),
        // Attachment Box - matches the full height of title + description
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF3F3F3),
          ),
          height: ResponsiveUtils.scaleHeight(
            context,
            210,
            min: 145,
            max: 253,
          ),
          child: BuildingPhotoUploader(
            photos: _pendingPhotos,
            onPhotosChanged: (photos) {
              setState(() {
                _pendingPhotos = photos;
              });
            },
          ),
        ),
      ],
    );
  }
}
