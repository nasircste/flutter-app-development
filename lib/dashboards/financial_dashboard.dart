import 'package:flutter/material.dart';
//import 'package: flutter/scheduler.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:real_estate_flutter/widgets/common/custom_dropdown2.dart';
import 'package:real_estate_flutter/widgets/common/shared_top_bar.dart';
import 'package:real_estate_flutter/utils/responsive_utils.dart';

class FinancialDashboardPage extends StatefulWidget {
  const FinancialDashboardPage({Key? key}) : super(key: key);

  @override
  State<FinancialDashboardPage> createState() => _FinancialDashboardPageState();
}

class _FinancialDashboardPageState extends State<FinancialDashboardPage> {
  int selectedTab = 0;
  DateTime? _selectedDate;
  String _selectedProject = 'All Projects';

  @override
  Widget build(BuildContext context) {
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
                padding:
                    ResponsiveUtils.insetAll(context, 24, min: 16, max: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),
                    _buildSummaryCards(),
                    SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),
                    _buildCashFlowChart(),
                    SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),
                    _buildExpenseAndOverdueSection(),
                    SizedBox(height: IntakeLayoutTokens.largeSpacing(context)),
                    _buildTransactionTable(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isMobile = ResponsiveUtils.isMobile(context);

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              _buildHeaderTitle(),
              SizedBox(height: IntakeLayoutTokens.mediumSpacing(context)),
              // Filters Row (All Projects + Date Range)
              Row(
                children: [
                  Expanded(
                    flex: 1, // 1/3 of the row
                    child: _buildProjectDropdown(),
                  ),
                  SizedBox(
                      width: ResponsiveUtils.scaleWidth(context, 8,
                          min: 6, max: 12)),
                  Expanded(
                    flex: 2, // 2/3 of the row
                    child: _buildDateRangePicker(),
                  ),
                ],
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title on Left
              _buildHeaderTitle(),
              // Filters on Right
              Row(
                children: [
                  _buildProjectDropdown(),
                  SizedBox(
                      width: ResponsiveUtils.scaleWidth(context, 12,
                          min: 8, max: 16)),
                  _buildDateRangePicker(),
                ],
              ),
            ],
          );
  }

  Widget _buildHeaderTitle() {
    return Text(
      'Financial Dashboard',
      style: TextStyle(
        fontSize: IntakeLayoutTokens.pageTitleFont(context),
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildProjectDropdown() {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      width: isMobile
          ? null
          : ResponsiveUtils.scaleWidth(context, 250, min: 200, max: 280),
      padding: ResponsiveUtils.insetSymmetric(
        context,
        horizontal: isMobile ? 8 : 12,
        vertical: isMobile ? 8 : 10,
        minH: 6,
        maxH: 16,
        minV: 6,
        maxV: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: ResponsiveUtils.radius(context, 5, min: 4, max: 6),
        border: Border.all(color: const Color(0xFF868686)),
      ),
      child: Row(
        mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/project.png',
            width: ResponsiveUtils.scaleWidth(context, isMobile ? 20 : 21,
                min: 16, max: 24),
            height: ResponsiveUtils.scaleHeight(context, isMobile ? 20 : 21,
                min: 16, max: 24),
            color: const Color(0xFF3F3F3F),
          ),
          SizedBox(
              width: ResponsiveUtils.scaleWidth(context, isMobile ? 6 : 8,
                  min: 4, max: 10)),
          Expanded(
            child: CustomDropdown2<String>(
              width:
                  ResponsiveUtils.scaleWidth(context, 250, min: 200, max: 280),
              label: '',
              value: _selectedProject,
              items: const [
                'All Projects',
                'Sunrise Tower',
                'Sky View Tower - 2A',
                'Khutan Tower - 7C',
                'Blue Sapphire - 11B',
              ],
              itemAsString: (item) => item,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedProject = val;
                  });
                }
              },
              height:
                  ResponsiveUtils.scaleHeight(context, 25, min: 17, max: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangePicker() {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Container(
      height: ResponsiveUtils.scaleHeight(context, 44, min: 38, max: 48),
      constraints: BoxConstraints(
        minWidth: isMobile
            ? 0
            : ResponsiveUtils.scaleWidth(context, 200, min: 180, max: 400),
      ),
      padding: ResponsiveUtils.insetSymmetric(
        context,
        horizontal: isMobile ? 6 : (isTablet ? 10 : 16),
        vertical: isMobile ? 8 : 10,
        minH: 4,
        maxH: 20,
        minV: 6,
        maxV: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: ResponsiveUtils.radius(context, 5, min: 4, max: 6),
        border: Border.all(color: const Color(0xFF868686)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          // Left Date
          Flexible(
            child: Text(
              isMobile
                  ? '02 Nov 2025'
                  : (isTablet ? '02 Nov 2025' : '02nd November 2025'),
              style: TextStyle(
                fontSize:
                    ResponsiveUtils.scaleFont(context, 14, min: 14, max: 16),
                color: Colors.black87,
              ),
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(
              width: ResponsiveUtils.scaleWidth(context, isMobile ? 4 : 8,
                  min: 3, max: 10)),

          // Arrow Icon
          Image.asset(
            'assets/images/arrow_cool_down.png',
            width: ResponsiveUtils.scaleWidth(context, isMobile ? 16 : 21,
                min: 14, max: 22),
            height: ResponsiveUtils.scaleHeight(context, isMobile ? 16 : 21,
                min: 14, max: 22),
            color: Colors.black54,
          ),
          SizedBox(
              width: ResponsiveUtils.scaleWidth(context, isMobile ? 4 : 8,
                  min: 3, max: 10)),

          // Right Date
          Flexible(
            child: Text(
              isMobile
                  ? '01 Jan 2028'
                  : (isTablet ? '01 Jan 2028' : '01 January 2028'),
              style: TextStyle(
                fontSize:
                    ResponsiveUtils.scaleFont(context, 14, min: 14, max: 16),
                color: Colors.black87,
              ),
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(
              width: ResponsiveUtils.scaleWidth(context, isMobile ? 4 : 8,
                  min: 3, max: 10)),

          // Calendar Icon
          CalendarIconButtonSingle(
            asset: 'assets/images/Vector.png',
            initialDate: _selectedDate,
            iconSize: ResponsiveUtils.scaleWidth(context, isMobile ? 16 : 18,
                min: 14, max: 20),
            tapTargetSize: ResponsiveUtils.scaleWidth(
                context, isMobile ? 28 : 40,
                min: 24, max: 44),
            onChanged: (date) {
              setState(() => _selectedDate = date);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final isDesktop = ResponsiveUtils.isDesktop(context);

    if (isMobile) {
      // Mobile:  Stack all 3 vertically
      return Column(
        children: [
          _buildSummaryCard(
            title: 'Net Cash Balance',
            amount: '৳25,00,000',
            indicator: '5% Vs Next month',
            indicatorColor: const Color(0xFF4CAF50),
            backgroundColor: const Color(0xFFF1F8F4),
            backgroundImageAsset: 'assets/images/bac1.png',
          ),
          SizedBox(height: IntakeLayoutTokens.cardSpacing(context)),
          _buildSummaryCard(
            title: 'Due Installments',
            amount: '৳89,000',
            indicator: 'from 5 transaction',
            indicatorColor: const Color(0xFFFFA726),
            backgroundColor: const Color(0xFFFFF8E1),
            backgroundImageAsset: 'assets/images/bac2.png',
          ),
          SizedBox(height: IntakeLayoutTokens.cardSpacing(context)),
          _buildSummaryCard(
            title: 'Monthly Expenses',
            amount: '৳80,000',
            indicator: '7% higher than last month',
            indicatorColor: const Color(0xFFEF5350),
            backgroundColor: const Color(0xFFFFEBEE),
            backgroundImageAsset: 'assets/images/bac3.png',
          ),
        ],
      );
    } else if (isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Net Cash Balance',
                  amount: '৳25,00,000',
                  indicator: '5% Vs Next month',
                  indicatorColor: const Color(0xFF4CAF50),
                  backgroundColor: const Color(0xFFF1F8F4),
                  backgroundImageAsset: 'assets/images/bac1.png',
                ),
              ),
              SizedBox(width: IntakeLayoutTokens.cardSpacing(context)),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Due Installments',
                  amount: '৳89,000',
                  indicator: 'from 5 transaction',
                  indicatorColor: const Color(0xFFFFA726),
                  backgroundColor: const Color(0xFFFFF8E1),
                  backgroundImageAsset: 'assets/images/bac2.png',
                ),
              ),
            ],
          ),
          SizedBox(height: IntakeLayoutTokens.cardSpacing(context)),
          _buildSummaryCard(
            title: 'Monthly Expenses',
            amount: '৳80,000',
            indicator: '7% higher than last month',
            indicatorColor: const Color(0xFFEF5350),
            backgroundColor: const Color(0xFFFFEBEE),
            backgroundImageAsset: 'assets/images/bac3.png',
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Net Cash Balance',
              amount: '৳25,00,000',
              indicator: '5% Vs Next month',
              indicatorColor: const Color(0xFF4CAF50),
              backgroundColor: const Color(0xFFF1F8F4),
              backgroundImageAsset: 'assets/images/bac1.png',
            ),
          ),
          SizedBox(width: IntakeLayoutTokens.cardSpacing(context)),
          Expanded(
            child: _buildSummaryCard(
              title: 'Due Installments',
              amount: '৳89,000',
              indicator: 'from 5 transaction',
              indicatorColor: const Color(0xFFFFA726),
              backgroundColor: const Color(0xFFFFF8E1),
              backgroundImageAsset: 'assets/images/bac2.png',
            ),
          ),
          SizedBox(width: IntakeLayoutTokens.cardSpacing(context)),
          Expanded(
            child: _buildSummaryCard(
              title: 'Monthly Expenses',
              amount: '৳80,000',
              indicator: '7% higher than last month',
              indicatorColor: const Color(0xFFEF5350),
              backgroundColor: const Color(0xFFFFEBEE),
              backgroundImageAsset: 'assets/images/bac3.png',
            ),
          ),
        ],
      );
    }
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required String indicator,
    required Color indicatorColor,
    required Color backgroundColor,
    String? backgroundImageAsset,
    Alignment backgroundImageAlignment = Alignment.center,
  }) {
    return Container(
      height: ResponsiveUtils.scaleHeight(context, 170, min: 140, max: 190),
      padding: ResponsiveUtils.insetAll(context, 20, min: 16, max: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: ResponsiveUtils.radius(context, 12, min: 8, max: 16),
        image: backgroundImageAsset != null
            ? DecorationImage(
                image: AssetImage(backgroundImageAsset),
                fit: BoxFit.cover,
                alignment: backgroundImageAlignment,
                colorFilter: ColorFilter.mode(
                  backgroundColor.withOpacity(0.88),
                  BlendMode.srcATop,
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.scaleFont(context, 18,
                        min: 14, max: 20),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF3F3F3F),
                  ),
                ),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.scaleFont(context, 40,
                        min: 24, max: 44),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3F3F3F),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              width: ResponsiveUtils.scaleWidth(context, 16, min: 12, max: 20)),
          Container(
            padding: ResponsiveUtils.insetSymmetric(
              context,
              horizontal: 12,
              vertical: 8,
              minH: 8,
              maxH: 16,
              minV: 6,
              maxV: 10,
            ),
            decoration: BoxDecoration(
              color: indicatorColor.withOpacity(0.08),
              borderRadius: ResponsiveUtils.radius(context, 5, min: 4, max: 6),
            ),
            child: Text(
              indicator,
              style: TextStyle(
                fontSize:
                    ResponsiveUtils.scaleFont(context, 18, min: 12, max: 20),
                fontWeight: FontWeight.w400,
                color: indicatorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowChart() {
    return Container(
      padding: ResponsiveUtils.insetAll(context, 24, min: 16, max: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: ResponsiveUtils.radius(context, 12, min: 8, max: 16),
        border: Border.all(color: const Color(0xFFDADADA), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius:
                ResponsiveUtils.scaleWidth(context, 10, min: 6, max: 12),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cash Flow Chart',
            style: TextStyle(
              fontSize: IntakeLayoutTokens.sectionTitleFont(context),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: const Color(0xFF3F3F3F),
            ),
          ),
          SizedBox(height: IntakeLayoutTokens.xSmallSpacing(context)),
          Text(
            'Income vs Expenses (Last 6 Month)',
            style: TextStyle(
              fontSize:
                  ResponsiveUtils.scaleFont(context, 18, min: 14, max: 20),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: const Color(0xFFB1B1B1),
            ),
          ),
          SizedBox(height: IntakeLayoutTokens.xLargeSpacing(context)),
          SizedBox(
            height:
                ResponsiveUtils.scaleHeight(context, 200, min: 160, max: 240),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun'
                        ];
                        return Padding(
                          padding: EdgeInsets.only(
                            top: ResponsiveUtils.scaleHeight(context, 2,
                                min: 2, max: 10),
                          ),
                          child: Text(
                            months[value.toInt()],
                            style: TextStyle(
                              fontSize: ResponsiveUtils.scaleFont(context, 10,
                                  min: 10, max: 14),
                              color: Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: ResponsiveUtils.scaleWidth(context, 40,
                          min: 32, max: 48),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}k',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.scaleFont(context, 11,
                                min: 9, max: 13),
                            color: Colors.black54,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(0, 85, 50),
                  _buildBarGroup(1, 70, 55),
                  _buildBarGroup(2, 60, 45),
                  _buildBarGroup(3, 75, 80),
                  _buildBarGroup(4, 65, 55),
                  _buildBarGroup(5, 90, 95),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double value1, double value2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value1,
          color: const Color(0xFF42A5F5),
          width: ResponsiveUtils.scaleWidth(context, 20, min: 12, max: 24),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
                ResponsiveUtils.scaleWidth(context, 4, min: 3, max: 5)),
            topRight: Radius.circular(
                ResponsiveUtils.scaleWidth(context, 4, min: 3, max: 5)),
          ),
        ),
        BarChartRodData(
          toY: value2,
          color: const Color(0xFFEF5350),
          width: ResponsiveUtils.scaleWidth(context, 20, min: 12, max: 24),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
                ResponsiveUtils.scaleWidth(context, 4, min: 3, max: 5)),
            topRight: Radius.circular(
                ResponsiveUtils.scaleWidth(context, 4, min: 3, max: 5)),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseAndOverdueSection() {
    return ResponsiveUtils.isDesktop(context)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildExpenseBreakdown()),
              SizedBox(width: IntakeLayoutTokens.cardSpacing(context)),
              Expanded(child: _buildOverdueClients()),
            ],
          )
        : Column(
            children: [
              _buildExpenseBreakdown(),
              SizedBox(height: IntakeLayoutTokens.cardSpacing(context)),
              _buildOverdueClients(),
            ],
          );
  }

  Widget _buildExpenseBreakdown() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth <1024;
    final isDesktop = screenWidth > 1024;

    return Container(
      height: ResponsiveUtils.scaleHeight(context, 520, min: 460, max: 580),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: ResponsiveUtils.radius(context, 12, min: 8, max: 16),
        border: Border.all(color: const Color(0xFFDADADA), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius:
                ResponsiveUtils.scaleWidth(context, 10, min: 6, max: 12),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveUtils.insetLTRB(context, 20, 18, 25, 0,
                minH: 35, maxH: 32, minV: 2, maxV: 18),
            child: Text(
              'Expense Breakdown',
              style: TextStyle(
                fontSize: IntakeLayoutTokens.sectionTitleFont(context),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: const Color(0xFF3F3F3F),
              ),
            ),
          ),
          SizedBox(
              height:
                  ResponsiveUtils.scaleHeight(context, 22, min: 16, max: 28)),
          const Divider(thickness: 1, height: 1, color: Color(0xFFDADADA)),
          Expanded(
            child: Padding(
              padding: ResponsiveUtils.insetSymmetric(
                context,
                horizontal: 30,
                vertical: 20,
                minH: 20,
                maxH: 40,
                minV: 16,
                maxV: 32,
              ),
              child: isMobile
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Pie Chart - Top Center for mobile
                        Center(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: _buildPieChart(isMobile: true),
                          ),
                        ),
                        SizedBox(height: 40),
                        // Legends - Bottom Center for mobile
                        Center(
                          child: _buildLegendColumn(isMobile: true),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Pie Chart - Left Center for tablet/desktop
                        SizedBox(
                          width: isTablet ? 280 : 220,
                          height: isTablet ? 280 : 220,
                          child: _buildPieChart(isTablet: isTablet),
                        ),
                        // Maximum spacing between chart and legends
                        Expanded(child: Container()),
                        // Legends - Right Center for tablet/desktop
                        _buildLegendColumn(isTablet: isTablet),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart({bool isMobile = false, bool isTablet = false}) {
    // Responsive sizing
    double centerSpaceRadius;
    double sectionRadius;
    double totalFontSize;
    double labelFontSize;

    if (isMobile) {
      centerSpaceRadius = 60;
      sectionRadius = 25;
      totalFontSize = 22;
      labelFontSize = 14;
    } else if (isTablet) {
      centerSpaceRadius = 85;
      sectionRadius = 35;
      totalFontSize = 28;
      labelFontSize = 16;
    } else {
      centerSpaceRadius = 100;
      sectionRadius = 30;
      totalFontSize = 26;
      labelFontSize = 16;
    }

    return Stack(
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: centerSpaceRadius,
            sections: [
              PieChartSectionData(
                value: 45,
                color: const Color(0xFF7275F2),
                radius: sectionRadius,
                showTitle: false,
              ),
              PieChartSectionData(
                value: 25,
                color: const Color(0xFF72AEF2),
                radius: sectionRadius,
                showTitle: false,
              ),
              PieChartSectionData(
                value: 20,
                color: const Color(0xFF72C1F2),
                radius: sectionRadius,
                showTitle: false,
              ),
              PieChartSectionData(
                value: 20,
                color: const Color(0xFFC372F2),
                radius: sectionRadius,
                showTitle: false,
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: labelFontSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF969696),
                ),
              ),
              Text(
                '৳80,000',
                style: TextStyle(
                  fontSize: totalFontSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF3F3F3F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendColumn({bool isMobile = false, bool isTablet = false}) {
    // Responsive sizing for legend items
    double itemSpacing;

    if (isMobile) {
      itemSpacing = 14;
    } else if (isTablet) {
      itemSpacing = 20;
    } else {
      itemSpacing = 16;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegendItem('Raw Materials', const Color(0xFF7275F2),
            isMobile: isMobile, isTablet: isTablet),
        SizedBox(height: itemSpacing),
        _buildLegendItem('Labor & Subcontracting', const Color(0xFF72AEF2),
            isMobile: isMobile, isTablet: isTablet),
        SizedBox(height: itemSpacing),
        _buildLegendItem('Logistics & Equipment', const Color(0xFF72C1F2),
            isMobile: isMobile, isTablet: isTablet),
        SizedBox(height: itemSpacing),
        _buildLegendItem('Operational Overheads', const Color(0xFFC372F2),
            isMobile: isMobile, isTablet: isTablet),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color,
      {bool isMobile = false, bool isTablet = false}) {
    // Responsive sizing for legend items
    double boxSize;
    double fontSize;
    double spacing;

    if (isMobile) {
      boxSize = 20;
      fontSize = 16;
      spacing = 8;
    } else if (isTablet) {
      boxSize = 28;
      fontSize = ResponsiveUtils.scaleFont(context, 18, min: 16, max: 22);
      spacing = 8;
    } else {
      boxSize = 24;
      fontSize = ResponsiveUtils.scaleFont(context, 14, min: 14, max: 35);
      spacing = 8;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: spacing),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Poppins',
            color: const Color(0xFF3F3F3F),
          ),
        ),
      ],
    );
  }

  Widget _buildOverdueClients() {
    final clients = [
      {
        'name': 'Pulok Kanti Paul',
        'location': 'Sky View Tower -2A',
        'amount': '৳35,000'
      },
      {
        'name': 'Pankaj Roy',
        'location': 'Khelan Tower -7C',
        'amount': '৳40,000'
      },
      {
        'name': 'Nafis Ahmed',
        'location': 'Sunrise Tower -3D',
        'amount': '৳42,000'
      },
      {
        'name': 'Nasir Ahmed',
        'location': 'Jam Jam Tower -4A',
        'amount': '৳45,000'
      },
      {
        'name': 'Karim Ahmed',
        'location': 'Golden Tower -5B',
        'amount': '৳38,000'
      },
      {
        'name': 'Rahim Khan',
        'location': 'Silver Tower -6C',
        'amount': '৳50,000'
      },
      {
        'name': 'Rahim Khan',
        'location': 'Silver Tower -6C',
        'amount': '৳50,000'
      },
      {
        'name': 'Rahim Khan',
        'location': 'Silver Tower -6C',
        'amount': '৳50,000'
      },
      {
        'name': 'Rahim Khan',
        'location': 'Silver Tower -6C',
        'amount': '৳50,000'
      },
      {
        'name': 'Rahim Khan',
        'location': 'Silver Tower -6C',
        'amount': '৳50,000'
      },
    ];

    return Container(
      height: ResponsiveUtils.scaleHeight(context, 520, min: 460, max: 580),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: ResponsiveUtils.radius(context, 12, min: 8, max: 16),
        border: Border.all(color: const Color(0xFFDADADA), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius:
                ResponsiveUtils.scaleWidth(context, 10, min: 6, max: 12),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveUtils.insetAll(context, 8, min: 8, max: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: ResponsiveUtils.insetLTRB(context, 25, 14, 30, 6,
                        minH: 16, maxH: 32, minV: 10, maxV: 16),
                    child: Text(
                      'Overdue Client Installments',
                      style: TextStyle(
                        fontSize: IntakeLayoutTokens.sectionTitleFont(context),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3F3F3F),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.scaleFont(context, 18,
                          min: 14, max: 20),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1F89B7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 1, color: Color(0xFFDADADA)),
          SizedBox(
              height:
                  ResponsiveUtils.scaleHeight(context, 20, min: 12, max: 24)),
          Expanded(
            // child: Scrollbar(
            // thumbVisibility: false,
            //thickness: 6,
            //radius: Radius.circular(IntakeLayoutTokens.scrollRadius(context)),
            child: Padding(
              padding: ResponsiveUtils.insetSymmetric(context,
                  horizontal: 20, minH: 12, maxH: 28),
              child: ListView.separated(
                itemCount: clients.length,
                padding: ResponsiveUtils.insetSymmetric(context,
                    horizontal: 15, minH: 10, maxH: 20),
                itemBuilder: (context, index) {
                  final client = clients[index];
                  return Padding(
                    padding: ResponsiveUtils.insetSymmetric(context,
                        vertical: 16, minV: 12, maxV: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                client['name']!,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.scaleFont(
                                      context, 20,
                                      min: 12, max: 22),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF3F3F3F),
                                ),
                              ),
                              if (client['location']!.isNotEmpty)
                                SizedBox(
                                    height: IntakeLayoutTokens.xSmallSpacing(
                                        context)),
                              if (client['location']!.isNotEmpty)
                                Text(
                                  client['location']!,
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.scaleFont(
                                        context, 16,
                                        min: 10, max: 18),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF8C8C8C),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: ResponsiveUtils.insetSymmetric(context,
                              horizontal: 8, minH: 6, maxH: 10),
                          child: Text(
                            client['amount']!,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.scaleFont(context, 16,
                                  min: 12, max: 18),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF3F3F3F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE5E7EB),
                  indent: 10,
                  endIndent: 10,
                ),
              ),
            ),
            //),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTable() {
    final transactions = [
      {
        'date': '6th Jan 25',
        'description': 'Sky View Tower Flat 2B ',
        'subtitle': 'Installment of Jan 2025',
        'added': '+৳35,000',
        'spent': '',
        'balance': '৳25,00,000',
      },
      {
        'date': '3rd Jan 25',
        'description': 'Raw Material Bought',
        'subtitle': 'Sunrise Tower',
        'added': '',
        'spent': '৳1,35,000',
        'balance': '৳23,65,000',
      },
      {
        'date': '31st Dec 25',
        'description': 'Design & Engineering Fees',
        'subtitle': 'Sunrise Tower',
        'added': '',
        'spent': '৳4,55,000',
        'balance': '৳19,10,000',
      },
      {
        'date': '27th Dec 25',
        'description': 'Concept Branding & Pre-Marketing',
        'subtitle': 'Sunrise Tower',
        'added': '+৳50,000',
        'spent': '৳60,000',
        'balance': '৳18,50,000',
      },
      {
        'date': '27th Dec 25',
        'description': 'Concept Branding & Pre-Marketing',
        'subtitle': 'Sunrise Tower',
        'added': '',
        'spent': '৳60,000',
        'balance': '৳18,50,000',
      },
      {
        'date': '27th Dec 25',
        'description': 'Concept Branding & Pre-Marketing',
        'subtitle': 'Sunrise Tower',
        'added': '',
        'spent': '৳60,000',
        'balance': '৳18,50,000',
      },
      {
        'date': '27th Dec 25',
        'description': 'Concept Branding & Pre-Marketing',
        'subtitle': 'Sunrise Tower',
        'added': '+৳20,000',
        'spent': '৳60,000',
        'balance': '৳18,50,000',
      },
    ];

    return ClipRRect(
      borderRadius: ResponsiveUtils.radius(context, 10, min: 8, max: 12),
      child: Container(
        height: ResponsiveUtils.scaleHeight(context, 646, min: 480, max: 720),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius:
                  ResponsiveUtils.scaleWidth(context, 10, min: 6, max: 12),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: ResponsiveUtils.radius(context, 10, min: 8, max: 12),
          border: Border.all(color: const Color(0xFFDADADA), width: 1),
        ),
        child: Column(
          children: [
            // Header
            Container(
              height:
                  ResponsiveUtils.scaleHeight(context, 70, min: 56, max: 80),
              padding: ResponsiveUtils.insetSymmetric(
                context,
                horizontal: 24,
                vertical: 16,
                minH: 16,
                maxH: 32,
                minV: 12,
                maxV: 20,
              ),
              decoration: const BoxDecoration(color: Color(0xFFF9F9F9)),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.scaleFont(context, 18,
                            min: 14, max: 20),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3F3F3F),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.scaleFont(context, 18,
                            min: 14, max: 20),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3F3F3F),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Money added',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.scaleFont(context, 18,
                            min: 14, max: 20),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3F3F3F),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Money Spent',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.scaleFont(context, 18,
                            min: 14, max: 20),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3F3F3F),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Balance',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.scaleFont(context, 18,
                            min: 14, max: 20),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3F3F3F),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: IntakeLayoutTokens.scrollbarThickness(context),
                radius:
                    Radius.circular(IntakeLayoutTokens.scrollRadius(context)),
                child: ListView.builder(
                  itemCount: transactions.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final t = transactions[index];
                    return Container(
                      padding: ResponsiveUtils.insetSymmetric(
                        context,
                        horizontal: 24,
                        vertical: 20,
                        minH: 16,
                        maxH: 32,
                        minV: 16,
                        maxV: 24,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Date
                          Expanded(
                            flex: 2,
                            child: Text(
                              t['date']!,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.scaleFont(context, 18,
                                    min: 12, max: 20),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF3F3F3F),
                              ),
                            ),
                          ),

                          // Description
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t['description']!,
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.scaleFont(
                                        context, 18,
                                        min: 12, max: 20),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF3F3F3F),
                                  ),
                                ),
                                SizedBox(
                                    height: IntakeLayoutTokens.xSmallSpacing(
                                        context)),
                                Text(
                                  t['subtitle']!,
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.scaleFont(
                                        context, 16,
                                        min: 10, max: 18),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF8C8C8C),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Money Added
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: (t['added']?.trim().isEmpty ?? true)
                                  ? const _EmptyAmountPlaceholder()
                                  : Text(
                                      t['added']!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils.scaleFont(
                                            context, 18,
                                            min: 12, max: 20),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF56B368),
                                      ),
                                    ),
                            ),
                          ),

                          // Money Spent
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: (t['spent']?.trim().isEmpty ?? true)
                                  ? const _EmptyAmountPlaceholder()
                                  : Text(
                                      t['spent']!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: ResponsiveUtils.scaleFont(
                                            context, 18,
                                            min: 12, max: 20),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFF24A4A),
                                      ),
                                    ),
                            ),
                          ),

                          // Balance
                          Expanded(
                            flex: 2,
                            child: Text(
                              t['balance']!,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.scaleFont(context, 18,
                                    min: 12, max: 20),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF3F3F3F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAmountPlaceholder extends StatelessWidget {
  const _EmptyAmountPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveUtils.scaleWidth(context, 60, min: 40, max: 80),
      child: Container(
        height: 1,
        decoration: const BoxDecoration(
          color: Color(0xFFDADADA),
        ),
      ),
    );
  }
}

class CalendarIconButtonSingle extends StatelessWidget {
  final String asset;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onChanged;

  final double iconSize;
  final double tapTargetSize;
  final Color iconColor;

  const CalendarIconButtonSingle({
    super.key,
    required this.asset,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.iconSize = 18,
    this.tapTargetSize = 40,
    this.iconColor = Colors.black54,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(now.year - 5, 1, 1),
      lastDate: lastDate ?? DateTime(now.year + 5, 12, 31),
      helpText: 'Select date',
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: const Color(0xFF2563EB),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF111827),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2563EB),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _pickDate(context),
        child: Tooltip(
          message: 'Pick date',
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: tapTargetSize,
              minHeight: tapTargetSize,
            ),
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Image.asset(
                  asset,
                  width: iconSize,
                  height: iconSize,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
