import 'package:flutter/material.dart';
import 'package:real_estate_flutter/screens/task/task_model/task_model.dart';
import 'package:real_estate_flutter/utils/responsive_utils.dart';
import 'package:real_estate_flutter/widgets/common/custom_button.dart';
import 'package:real_estate_flutter/widgets/common/custom_dropdown.dart';
import 'package:real_estate_flutter/widgets/common/custom_search_dropdown.dart';
import 'package:real_estate_flutter/widgets/common/custom_text_field.dart';
import 'package:real_estate_flutter/widgets/common/universal_photo_uploader.dart';

class CreateTaskDialog extends StatefulWidget {
  final Function(Task) onTaskCreated;

  const CreateTaskDialog({
    Key? key,
    required this.onTaskCreated,
  }) : super(key: key);

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers
  final TextEditingController _assignToController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _employeeController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();

  // Dropdown values
  String? _selectedCategory;
  String? _selectedPriority;
  String? _selectedProject;

  DateTime _selectedDate = DateTime.now();
  List<PendingPhoto> _pendingPhotos = [];

  final FocusNode _assignToFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging && mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _assignToController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _employeeController.dispose();
    _projectController.dispose();
    _assignToFocusNode.dispose();
    super.dispose();
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

  void _createTask() {
    if (_assignToController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedPriority == null ||
        _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final newTask = Task(
      dueDate:
          '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
      assignedTo: _assignToController.text,
      project:
          _projectController.text.isEmpty ? 'N/A' : _projectController.text,
      category: _selectedCategory ?? 'N/A',
      priority: _selectedPriority ?? 'Medium',
      hasAttachment: _pendingPhotos.isNotEmpty,
      attachmentFiles: _pendingPhotos.map((p) => p.file).toList(),
    );

    widget.onTaskCreated(newTask);

    Navigator.of(context).pop();
  }

  void _assignProject() {
    if (_employeeController.text.isEmpty || _projectController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both employee and project')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project assigned successfully')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveUtils.isMobile(context);
    final double dialogWidth =
        ResponsiveUtils.width(context) * (isMobile ? 0.95 : 0.9);
    final double projectTabHeight =
        ResponsiveUtils.scaleHeight(context, 300, min: 100);
    final double taskTabHeight = isMobile
        ? (ResponsiveUtils.height(context) * 0.75)
            .clamp(360.0, ResponsiveUtils.height(context) - 120.0)
        : ResponsiveUtils.scaleHeight(context, 800, min: 360);

    final double selectedTabHeight =
        (_tabController.index == 0) ? projectTabHeight : taskTabHeight;
    final horizPad = isMobile ? 18.0 : 30.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: ResponsiveUtils.radius(context, 8),
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: dialogWidth,
        constraints: const BoxConstraints(maxWidth: 880),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: horizPad, vertical: 21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        _tabController.index == 0
                            ? 'Assigning Project'
                            : 'Creating Task',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: Color(0xFF3F3F3F),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 26),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFFEAEAEA), thickness: 1, height: 1),

              // Body
              SizedBox(
                height: selectedTabHeight,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProjectTab(isMobile),
                    _buildTaskTab(isMobile),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(bool isMobile) {
    final double extraLeft =
        isMobile ? ResponsiveUtils.scaleWidth(context, 30) : 0.0;

    return Padding(
      padding: EdgeInsets.only(left: extraLeft),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 205,
            height: IntakeLayoutTokens.inputHeight(context),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: ResponsiveUtils.radius(context, 10),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF066F8C),
              unselectedLabelColor: const Color(0xFF6B7280),
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: const Color(0xFFE0F3FB),
                borderRadius: ResponsiveUtils.radius(context, 6),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              tabs: const [
                Tab(
                  child: Text(
                    'Project',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      color: Color(0xFF3F3F3F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      color: Color(0xFF3F3F3F),
                      fontWeight: FontWeight.w500,
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

  Widget _buildProjectTab(bool isMobile) {
    if (isMobile) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: ResponsiveUtils.insetSymmetric(
                context,
                horizontal: isMobile ? 18 : 30,
                vertical: isMobile ? 12 : 16,
              ),
              child: _buildTabBar(isMobile),
            ),
            Padding(
              padding: ResponsiveUtils.insetSymmetric(context,
                  horizontal: isMobile ? 50 : 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomSearchDropdown(
                          controller: _employeeController,
                          label: '',
                          hint: 'Search & Select an Employee',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: IntakeLayoutTokens.xSmallSpacing(context)),
                  Row(
                    children: [
                      Expanded(
                        child: CustomSearchDropdown(
                          controller: _projectController,
                          label: '',
                          hint: 'Select a Project',
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 35.0),
                    child: Center(
                      child: CustomButton(
                        text: 'Assign Project',
                        onPressed: _assignProject,
                        width: isMobile
                            ? double.infinity
                            : IntakeLayoutTokens.buttonWidth(context) * 1.3,
                        height: IntakeLayoutTokens.buttonHeight(context),
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

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: ResponsiveUtils.insetSymmetric(
              context,
              horizontal: isMobile ? 18 : 30,
              vertical: isMobile ? 12 : 16,
            ),
            child: _buildTabBar(isMobile),
          ),
          Padding(
            padding: ResponsiveUtils.insetSymmetric(context,
                horizontal: isMobile ? 50 : 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomSearchDropdown(
                        controller: _employeeController,
                        label: '',
                        hint: 'Search & Select an Employee',
                      ),
                    ),
                    SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
                    Expanded(
                      child: CustomSearchDropdown(
                        controller: _projectController,
                        label: '',
                        hint: 'Select a Project',
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 35.0),
                  child: Center(
                    child: CustomButton(
                      text: 'Assign Project',
                      onPressed: _assignProject,
                      width: isMobile
                          ? double.infinity
                          : IntakeLayoutTokens.buttonWidth(context) * 1.3,
                      height: IntakeLayoutTokens.buttonHeight(context),
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

  Widget _buildTaskTab(bool isMobile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: ResponsiveUtils.insetSymmetric(
              context,
              horizontal: isMobile ? 18 : 30,
              vertical: isMobile ? 12 : 16,
            ),
            child: _buildTabBar(isMobile),
          ),
          Padding(
            padding: ResponsiveUtils.insetSymmetric(context,
                horizontal: isMobile ? 50 : 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: IntakeLayoutTokens.xSmallSpacing(context)),
                CustomSearchDropdown(
                  controller: _assignToController,
                  label: 'Assign to',
                  hint: '',
                  focusNode: _assignToFocusNode,
                ),
                SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),

                // Due Date, Category, Priority
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due Date',
                            style: TextStyle(
                              fontSize: IntakeLayoutTokens.inputFont(context),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: const Color(0xFF3F3F3F),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null && picked != _selectedDate) {
                                setState(() {
                                  _selectedDate = picked;
                                });
                              }
                            },
                            child: Container(
                              height:
                                  IntakeLayoutTokens.dropdownHeight(context),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: !isMobile
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${_selectedDate.day.toString().padLeft(2, '0')} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                                            style: TextStyle(
                                              fontSize:
                                                  IntakeLayoutTokens.inputFont(
                                                      context),
                                              color: const Color(0xFF333333),
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/images/vector.png',
                                          width:
                                              IntakeLayoutTokens.smallIconSize(
                                                  context),
                                          height:
                                              IntakeLayoutTokens.smallIconSize(
                                                  context),
                                          color: const Color(0xFF757575),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          'assets/images/vector.png',
                                          width:
                                              IntakeLayoutTokens.smallIconSize(
                                                  context),
                                          height:
                                              IntakeLayoutTokens.smallIconSize(
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
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomDropdown<String>(
                        label: 'Task Category',
                        value: _selectedCategory,
                        items: const [
                          'Development',
                          'Design',
                          'Testing',
                          'MEP Engineer',
                          'Foundation & Piling',
                          'Concrete Works',
                          'Masonry',
                          'HVAC Systems'
                        ],
                        itemAsString: (item) => item,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CustomDropdown<String>(
                        label: 'Task Priority',
                        value: _selectedPriority,
                        items: const ['Low', 'Medium', 'High'],
                        itemAsString: (item) => item,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPriority = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),

                // Task Title
                CustomTextField(
                  controller: _titleController,
                  hint: '',
                  label: 'Task Title',
                ),
                SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),

                // Task Description
                CustomTextField(
                  controller: _descriptionController,
                  hint: '',
                  label: 'Task Description',
                  height: ResponsiveUtils.scaleHeight(context, 100, min: 90),
                ),
                SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),

                // Attachment
                SizedBox(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: IntakeLayoutTokens.smallHorizontalPadding(
                              context),
                        ),
                        child: Text(
                          'Attachment',
                          style: TextStyle(
                            fontSize: IntakeLayoutTokens.inputFont(context),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: const Color(0xFF3F3F3F),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: IntakeLayoutTokens.smallSpacing(context)),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F3F3),
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
                      ),
                    ],
                  ),
                ),
//
                SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),

                // Create Task Button
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 35.0),
                  child: Center(
                    child: CustomButton(
                      text: 'Create Task',
                      onPressed: _createTask,
                      width: isMobile
                          ? double.infinity
                          : IntakeLayoutTokens.buttonWidth(context) * 1.3,
                      height: IntakeLayoutTokens.buttonHeight(context),
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
}
