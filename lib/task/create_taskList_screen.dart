
import 'package:flutter/material.dart';
import 'package:real_estate_flutter/screens/task/popups/create_task_popup.dart';
import 'package:real_estate_flutter/screens/task/task_model/task_model.dart';
import 'package:real_estate_flutter/widgets/common/custom_button.dart';
import 'package:real_estate_flutter/widgets/common/custom_dropdown.dart';
import 'package:real_estate_flutter/widgets/common/custom_text_field.dart';
import 'package:real_estate_flutter/widgets/common/page_layout.dart';
import '../../utils/responsive_utils.dart';


class TaskListPage extends StatefulWidget {
  final String role;

  const TaskListPage({
    super.key,
    required this.role,
  });

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String? selectedDate;
  String selectedPriority = 'Medium';
  int currentPage = 1;
  final int totalPages = 3;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedProject = 'Medium';

  late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    tasks = [
      Task(
        dueDate: '2nd Nov 25',
        assignedTo: 'Paul Samuelson',
        project: 'Sky View Tower',
        category: 'MEP Engineer',
        priority: 'Medium',
        hasAttachment: true,
      ),
      Task(
        dueDate: '5th Nov 25',
        assignedTo: 'Pulok Paul',
        project: 'Gazi bhaban',
        category: 'Foundation & Piling',
        priority: 'Medium',
        hasAttachment: true,
      ),
    
    ];
  }

  DateTime _selectedDate = DateTime.now();

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addNewTask(Task newTask) {
    setState(() {
      tasks.add(newTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return PageLayout(
      role: widget.role,
      selectedIndex: 1,
      titleRow: isMobile ? _buildMobileTitleRow() : _buildDesktopTitleRow(),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildMobileSearchRow(),
            SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),
          ],

          _buildFiltersRow(),
          SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),

          _buildTaskTable(),
          SizedBox(height: IntakeLayoutTokens.xxLargeSpacing(context)),

          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildMobileTitleRow() {
    return Row(
      children: [
        Text(
          'Task List',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: IntakeLayoutTokens.pageTitleFont(context),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF3F3F3F),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileSearchRow() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            height: ResponsiveUtils.scaleHeight(context, 44, min: 36, max: 48),
            controller: _searchController,
            hint: 'Search Task',
            keyboardType: TextInputType.text,
          ),
        ),
        SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildDesktopTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Task List',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: IntakeLayoutTokens.pageTitleFont(context),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF3F3F3F),
          ),
        ),
        Row(
          children: [
            CustomTextField(
              height:
                  ResponsiveUtils.scaleHeight(context, 44, min: 36, max: 48),
              width:
                  ResponsiveUtils.scaleWidth(context, 360, min: 200, max: 400),
              controller: _searchController,
              hint: 'Search Task',
              keyboardType: TextInputType.text,
            ),
            SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
            _buildAddButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    final buttonSize =
        ResponsiveUtils.scaleWidth(context, 44, min: 36, max: 58);
    final iconSize = ResponsiveUtils.scaleWidth(context, 24, min: 18, max: 26);

    return CustomButton(
      icon: Icon(
        Icons.add,
        size: iconSize,
        color: Colors.white,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CreateTaskDialog(
             
              onTaskCreated: _addNewTask,
            );
          },
        );
      },
      width: buttonSize + 10,
      height: ResponsiveUtils.scaleHeight(context, 44, min: 36, max: 48),
    );
  }

  Widget _buildFiltersRow() {
    return Row(
      children: [
        _buildDateFilter(),
        SizedBox(width: IntakeLayoutTokens.mediumSpacing(context)),
        _buildPriorityFilter(),
        SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
        _buildSortButton(),
      ],
    );
  }

  Widget _buildDateFilter() {
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
        height: ResponsiveUtils.scaleHeight(context, 44, min: 36, max: 48),
        padding: ResponsiveUtils.insetLTRB(context, 10, 1, 10, 1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: ResponsiveUtils.radius(context, 5, min: 4, max: 6),
          border: Border.all(color: const Color(0xFFACACAC)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/vector.png',
              width: IntakeLayoutTokens.smallIconSize(context),
              height: IntakeLayoutTokens.smallIconSize(context),
              color: const Color(0xFF757575),
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.calendar_today,
                  size: IntakeLayoutTokens.smallIconSize(context),
                  color: const Color(0xFF757575),
                );
              },
            ),
            SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
            Text(
              '${_selectedDate.day.toString().padLeft(2, '0')} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
              style: TextStyle(
                fontSize:
                    ResponsiveUtils.scaleFont(context, 18, min: 12, max: 20),
                color: const Color(0xFFACACAC),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityFilter() {
    return CustomDropdown<String>(
      borderRadius: 5,
      buttonTextColor: Color(0xFFFFA72C),
      height: ResponsiveUtils.scaleHeight(context, 46, min: 36, max: 52),
      width: ResponsiveUtils.scaleWidth(context, 158, min: 100, max: 160),
      hint: '',
      value: _selectedProject,
      items: const ['Medium', 'High', 'Low'],
      itemAsString: (String item) => item,
      onChanged: (String? newValue) {
        setState(() {
          _selectedProject = newValue;
        });
      },
    );
  }

  Widget _buildSortButton() {
    final buttonSize =
        ResponsiveUtils.scaleWidth(context, 40, min: 32, max: 44);
    final iconSize = ResponsiveUtils.scaleWidth(context, 20, min: 16, max: 22);

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF3F3F3F),
        minimumSize: Size(buttonSize, buttonSize),
        maximumSize: Size(buttonSize, buttonSize),
        padding: EdgeInsets.zero,
        elevation: 0,
      ),
      child: Padding(
        padding: ResponsiveUtils.insetAll(context, 10, min: 6, max: 12),
        child: Image.asset(
          'assets/images/toggle_button.png',
          width: iconSize,
          height: iconSize,
          color: const Color(0xFF3F3F3F),
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.tune,
              size: iconSize,
              color: const Color(0xFF3F3F3F),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskTable() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: ResponsiveUtils.radius(context, 10, min: 6, max: 12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          ...tasks.map((task) => _buildTableRow(task)).toList(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    final horizontalPadding =
        ResponsiveUtils.scaleWidth(context, 95, min: 12, max: 95);
    final verticalPadding =
        ResponsiveUtils.scaleHeight(context, 20, min: 12, max: 24);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.only(
          topLeft: ResponsiveUtils.radius(context, 8, min: 6, max: 10).topLeft,
          topRight:
              ResponsiveUtils.radius(context, 8, min: 6, max: 10).topRight,
        ),
      ),
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: ResponsiveUtils.scaleWidth(context, 10, min: 8, max: 12),
        top: verticalPadding,
        bottom: verticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeaderCell('Due Date', flex: 3),
          _buildHeaderCell('Assigned to', flex: 4),
          _buildHeaderCell('Projects', flex: 4),
          _buildHeaderCell('Task Catogory', flex: 4),
          _buildHeaderCell('Task Priority', flex: 3),
          _buildHeaderCell('Attachments', flex: 3),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveUtils.scaleFont(context, 18, min: 10, max: 22),
          fontWeight: FontWeight.w400,
          color: const Color(0xFF3F3F3F),
        ),
      ),
    );
  }

  Widget _buildTableRow(Task task) {
    final horizontalPadding =
        ResponsiveUtils.scaleWidth(context, 95, min: 12, max: 95);
    final verticalPadding =
        ResponsiveUtils.scaleHeight(context, 20, min: 12, max: 24);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: ResponsiveUtils.scaleWidth(context, 10, min: 8, max: 12),
        top: verticalPadding,
        bottom: verticalPadding,
      ),
      child: Row(
        children: [
          _buildCell(task.dueDate, flex: 3),
          _buildCell(task.assignedTo, flex: 4),
          _buildCell(task.project, flex: 4),
          _buildCell(task.category, flex: 4),
          _buildPriorityCell(task.priority, flex: 3),
          _buildAttachmentCell(task.hasAttachment, flex: 3),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveUtils.scaleFont(context, 20, min: 10, max: 24),
          color: const Color(0xFF3F3F3F),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildPriorityCell(String priority, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        priority,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: ResponsiveUtils.scaleFont(context, 20, min: 10, max: 24),
          color: const Color(0xFFE68F0E),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildAttachmentCell(bool hasAttachment, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: hasAttachment
          ? Text(
              'See File',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize:
                    ResponsiveUtils.scaleFont(context, 20, min: 10, max: 24),
                color: const Color(0xFF1F89B7),
                fontWeight: FontWeight.w400,
              ),
            )
          : Text(
              '-------------------',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize:
                    ResponsiveUtils.scaleFont(context, 14, min: 10, max: 16),
                color: const Color(0xFFC2C2C2),
              ),
            ),
    );
  }

  Widget _buildPagination() {
    final pageNumSize =
        ResponsiveUtils.scaleWidth(context, 32, min: 24, max: 36);
    final iconSize = ResponsiveUtils.scaleWidth(context, 25, min: 18, max: 28);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPageNumber(1, pageNumSize),
        SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
        _buildPageNumber(2, pageNumSize),
        SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
        _buildPageNumber(3, pageNumSize),
        SizedBox(width: IntakeLayoutTokens.smallSpacing(context)),
        SizedBox(
          width: pageNumSize,
          height: pageNumSize,
          child: Icon(
            Icons.arrow_forward,
            size: iconSize,
            color: const Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }

  Widget _buildPageNumber(int pageNumber, double size) {
    final isSelected = pageNumber == currentPage;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(
              '$pageNumber',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize:
                    ResponsiveUtils.scaleFont(context, 26, min: 16, max: 28),
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF1F89B7)
                    : const Color(0xFFC8C8C8),
              ),
            ),
          ),
        ),
        SizedBox(height: IntakeLayoutTokens.xSmallSpacing(context)),
        Container(
          width: size,
          height: 1,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1F89B7) : Colors.transparent,
            borderRadius: ResponsiveUtils.radius(context, 2, min: 1, max: 3),
          ),
        ),
      ],
    );
  }
}