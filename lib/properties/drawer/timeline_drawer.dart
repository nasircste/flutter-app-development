// import 'package:flutter/material.dart';

// enum DateChipVariant { primary, secondary }

// class DateChip extends StatelessWidget {
//   final String date;
//   final DateChipVariant variant;
//   final Color? backgroundColor;
//   final Color? color;
//   final Color? iconColor;
//   final Color borderColor;
  

//   const DateChip(
//       {super.key,
//       required this.date,
//       this.variant = DateChipVariant.secondary,
//       required this.backgroundColor,
//       this.color,
//       this.iconColor,
//       this.borderColor = Colors.grey});

//   @override
//   Widget build(BuildContext context) {
//     final isPrimary = variant == DateChipVariant.primary;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(
//           color: borderColor,
//           width: 1,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.calendar_today_outlined,
//             size: 11,
//             color: iconColor,
//           ),
//           const SizedBox(width: 5),
//           Text(
//             date,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//               color: color,
//               fontFamily: 'Poppins',
//               letterSpacing: 0.1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DateRangeRow extends StatelessWidget {
//   final String startDate;
//   final String endDate;

//   const DateRangeRow({
//     super.key,
//     required this.startDate,
//     required this.endDate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 6,
//       runSpacing: 5,
//       children: [
//         DateChip(
//           date: startDate,
//           variant: DateChipVariant.secondary,
//           backgroundColor: Color(0xFFFFFFFF),
//           borderColor: Color(0xFF1F89B7),
//           iconColor: Color(0xFF1F89B7),
//           color: Color(0xFF1F89B7),
          
//         ),
//          const  SizedBox(width: 2,),
//         DateChip(
//             date: endDate,
//             variant: DateChipVariant.primary,
//             backgroundColor: Color(0xFF1F89B7),
//             iconColor: Color(0xFFFFFFFF),
//             color: Color(0xFFFFFFFF),
//             ),
            
//       ],
//     );
//   }
// }

// class DateRangeRow2 extends StatelessWidget {
//   final String startDate;
//   final String endDate;

//   const DateRangeRow2({
//     super.key,
//     required this.startDate,
//     required this.endDate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 6,
//       runSpacing: 5,
//       children: [
//         DateChip(
//           date: startDate,
//           variant: DateChipVariant.secondary,
//           backgroundColor: Color(0xFFFFFFFF),
//           borderColor: Color(0xFF797979),
//           iconColor: Color(0xFF797979),
//           color: Color(0xFF797979),
          
//         ),
//       const  SizedBox(width: 2,),
//         DateChip(
//             date: endDate,
//             variant: DateChipVariant.primary,
//             backgroundColor: Color(0xFF797979),
//             iconColor: Color(0xFFFFFFFFF),
//             color: Color(0xFFFFFFFF),
//             ),
            
//       ],
//     );
//   }
// }


// class TimelineSubTask {
//   final String title;
//   final String startDate;
//   final String endDate;

//   const TimelineSubTask({
//     required this.title,
//     required this.startDate,
//     required this.endDate,
//   });
// }

// class TimelinePhase {
//   final String title;
//   final String startDate;
//   final String endDate;
//   final List<TimelineSubTask> subTasks;

//   const TimelinePhase({
//     required this.title,
//     required this.startDate,
//     required this.endDate,
//     this.subTasks = const [],
//   });
// }

// class _TopHighlightCard extends StatelessWidget {
//   final TimelinePhase phase;

//   const _TopHighlightCard({required this.phase});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
//       decoration: const BoxDecoration(
//         color: Color(0xFFE2F6FF),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             phase.title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w400,
//               color: Color(0xFF1F89B7),
//               fontFamily: 'Poppins',
//               // letterSpacing: 0.1,
//             ),
//           ),
//           const SizedBox(height: 10),
//           DateChip(
//             date: phase.startDate,
//             variant: DateChipVariant.secondary,
//             backgroundColor: const Color(0xFFE2F6FF),
//             color: const Color(0xFF1F89B7),
//             iconColor: const Color(0xFF1F89B7),
//             borderColor: const Color(0XFF1F89B7),
//           ),
//           const SizedBox(height: 6),
//           DateChip(
//             date: phase.endDate,
//             variant: DateChipVariant.primary,
//             backgroundColor: const Color(0xFF1F89B7),
//             color: const Color(0xFFFFFFFF),
//             iconColor: const Color(0xFFFFFFFF),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  SUB-TASK ROW
// // ─────────────────────────────────────────────

// class _SubTaskRow extends StatelessWidget {
//   final TimelineSubTask task;
//   final bool showDivider;

//   const _SubTaskRow({required this.task, this.showDivider = true});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 task.title,
//                 style: const TextStyle(
//                   fontSize:16,
//                   fontWeight: FontWeight.w400,
//                   color: Color(0xFF797979),
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//               const SizedBox(height: 8),
//               DateRangeRow2(
//                 startDate: task.startDate,
//                 endDate: task.endDate,
//               ),
              
//             ],
//           ),
//         ),
//        // if (showDivider) Container(height: 1, color: const Color.fromARGB(255, 246, 63, 2)),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  CARD 2 & 3 — Timeline dot card
// //  FIX: CustomPaint dashed line — no LayoutBuilder/Expanded conflict
// // ─────────────────────────────────────────────
// class _TimelineCard extends StatelessWidget {
//   final TimelinePhase phase;
//   final bool isLast;

//   const _TimelineCard({required this.phase, this.isLast = false});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // ── Dot + line track ──
//             SizedBox(
//               width: 20,
//               child: Stack(
//                 alignment: Alignment.topCenter,
//                 children: [
//                   // Full height vertical line (solid top, dashed below dot)
//                   Positioned.fill(
//                     child: CustomPaint(
//                       painter: _TimelineLinePainter(isLast: isLast),
//                     ),
//                   ),
//                   // Dot positioned 18px from top
//                   Positioned(
//                     top: 0,
//                     child: Container(
//                       width: 13,
//                       height: 13,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF2196C4),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2.5),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Color.fromRGBO(33, 150, 196, 0.3),
//                             blurRadius: 5,
//                             spreadRadius: 1,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(width: 10),

//             // ── Card with RED background ──
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.only(bottom: 6),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF4F4F4), // Changed from white to red
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: const Color(0xFFC3C3C3), width: 1),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color.fromRGBO(0, 0, 0, 0.04),
//                       blurRadius: 6,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             phase.title,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w400,
//                               color: Color(0xFF1F89B7),
//                               fontFamily: 'Poppins',
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           DateRangeRow(
//                             startDate: phase.startDate,
//                             endDate: phase.endDate,
//                           ),
//                            const SizedBox(height: 18),
//                                 const Divider(
//                           thickness: 1, height: 1, color: Color(0xFFDEDEDE)),
//                         ],
//                       ),
//                     ),

//                     // Subtasks
//                     if (phase.subTasks.isNotEmpty) ...[
//                       // Container(height: 1, color: const Color.fromARGB(255, 14, 160, 234)),
//                       ...phase.subTasks.asMap().entries.map((e) {
//                         return _SubTaskRow(
//                           task: e.value,
//                           showDivider: e.key < phase.subTasks.length - 1,
//                         );
//                       }),
//                       const SizedBox(height: 4),
//                     ],
//                   ],
//                 ),
//               ),

//             ),
//            const SizedBox(height: 130,)
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  CUSTOM PAINTER — solid line above dot,
// //  dashed line below dot, nothing if isLast
// // ─────────────────────────────────────────────
// class _TimelineLinePainter extends CustomPainter {
//   final bool isLast;

//   const _TimelineLinePainter({required this.isLast});

//   @override
//   void paint(Canvas canvas, Size size) {
//     const dotTop = 0.0; // Dot position from top
//     const dotSize = 13.0;
//     const dotCenter = 20.0 / 2; // horizontal center = 10
//     const dotCenterY = dotTop + dotSize / 2; // vertical center of dot = 6.5

//     final solidPaint = Paint()
//       ..color = const Color(0xFF2196C4)
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     if (!isLast) {
//       // For non-last cards: line goes through dot center and continues to bottom
//       canvas.drawLine(
//         const Offset(dotCenter, dotCenterY),
//         Offset(dotCenter, size.height),
//         solidPaint,
//       );
//     } else {
//       // For last card: line comes from top and stops at dot center
//       canvas.drawLine(
//         Offset(dotCenter, 0),
//         Offset(dotCenter, dotCenterY),
//         solidPaint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(_TimelineLinePainter old) => old.isLast != isLast;
// }
// // ─────────────────────────────────────────────
// //  MAIN DRAWER — TimelineDrawer
// // ─────────────────────────────────────────────

// class TimelineDrawer extends StatelessWidget {
//   final String projectTitle;
//   final List<TimelinePhase> phases;

//   const TimelineDrawer({
//     super.key,
//     required this.projectTitle,
//     required this.phases,
//   });

//   static const List<TimelinePhase> samplePhases = [
//     TimelinePhase(
//       title: 'Project Sign-off & Kickoff',
//       startDate: '12th December 2025',
//       endDate: '25th December 2025',
//     ),
//     TimelinePhase(
//       title: 'Soil Test & Survey',
//       startDate: '05 Jan, 2026',
//       endDate: '08 Jan, 2026',
//       subTasks: [
//         TimelineSubTask(
//           title: 'Vendor Selection & Work Order',
//           startDate: '08 Jan, 2026',
//           endDate: '11 Jan, 2026',
//         ),
//         TimelineSubTask(
//           title: 'Mobilization of Drilling Rig',
//           startDate: '12 Jan, 2026',
//           endDate: '14 Jan, 2026',
//         ),
//         TimelineSubTask(
//           title: 'Mobilization of Drilling Rig',
//           startDate: '12 Jan, 2026',
//           endDate: '14 Jan, 2026',
//         ),
//       ],
//     ),
//     TimelinePhase(
//       title: 'Site Fencing & Labor Shed',
//       startDate: '15 Jan, 2026',
//       endDate: '15 Jan, 2026',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final topPhase = phases.isNotEmpty ? phases.first : null;
//     final timelinePhases =
//         phases.length > 1 ? phases.sublist(1) : <TimelinePhase>[];

//     return Drawer(
//       width: MediaQuery.of(context).size.width * 0.32,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//       backgroundColor: const Color(0xFFFFFFFF),
//       child: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Header ──
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.fromLTRB(28, 48, 12, 16),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Timeline of the',
//                           style: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xFF3F3F3F),
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                         Text(
//                           projectTitle,
//                           style: const TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xFF3F3F3F),
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Expanded(
//               child: ListView(
//                 //  padding: const EdgeInsets.fromLTRB(14, 16, 14, 28),
//                 children: [
//                   // Card 1
//                   if (topPhase != null) ...[
//                     _TopHighlightCard(phase: topPhase),
//                     const SizedBox(height: 40),
//                   ],

//                   // Card 2, 3, ...
//                   ...timelinePhases.asMap().entries.map((entry) {
//                     return _TimelineCard(
//                       phase: entry.value,
//                       isLast: entry.key == timelinePhases.length - 1,
//                     );
//                   }
//                   ),
//                    const SizedBox(height: 30,)
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';

enum DateChipVariant { primary, secondary }

class DateChip extends StatelessWidget {
  final String date;
  final DateChipVariant variant;
  final Color? backgroundColor;
  final Color? color;
  final Color? iconColor;
  final Color borderColor;

  const DateChip(
      {super.key,
      required this.date,
      this.variant = DateChipVariant.secondary,
      required this.backgroundColor,
      this.color,
      this.iconColor,
      this.borderColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == DateChipVariant.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 11,
            color: iconColor,
          ),
          const SizedBox(width: 5),
          Text(
            date,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: color,
              fontFamily: 'Poppins',
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class DateRangeRow extends StatelessWidget {
  final String startDate;
  final String endDate;

  const DateRangeRow({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 5,
      children: [
        DateChip(
          date: startDate,
          variant: DateChipVariant.secondary,
          backgroundColor: Color(0xFFFFFFFF),
          borderColor: Color(0xFF1F89B7),
          iconColor: Color(0xFF1F89B7),
          color: Color(0xFF1F89B7),
        ),
        const SizedBox(width: 2),
        DateChip(
          date: endDate,
          variant: DateChipVariant.primary,
          backgroundColor: Color(0xFF1F89B7),
          iconColor: Color(0xFFFFFFFF),
          color: Color(0xFFFFFFFF),
        ),
      ],
    );
  }
}

class DateRangeRow2 extends StatelessWidget {
  final String startDate;
  final String endDate;

  const DateRangeRow2({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 5,
      children: [
        DateChip(
          date: startDate,
          variant: DateChipVariant.secondary,
          backgroundColor: Color(0xFFFFFFFF),
          borderColor: Color(0xFF797979),
          iconColor: Color(0xFF797979),
          color: Color(0xFF797979),
        ),
        const SizedBox(width: 2),
        DateChip(
          date: endDate,
          variant: DateChipVariant.primary,
          backgroundColor: Color(0xFF797979),
          iconColor: Color(0xFFFFFFFF),
          color: Color(0xFFFFFFFF),
        ),
      ],
    );
  }
}

class TimelineSubTask {
  final String title;
  final String startDate;
  final String endDate;

  const TimelineSubTask({
    required this.title,
    required this.startDate,
    required this.endDate,
  });
}

class TimelinePhase {
  final String title;
  final String startDate;
  final String endDate;
  final List<TimelineSubTask> subTasks;

  const TimelinePhase({
    required this.title,
    required this.startDate,
    required this.endDate,
    this.subTasks = const [],
  });
}

class _TopHighlightCard extends StatelessWidget {
  final TimelinePhase phase;

  const _TopHighlightCard({required this.phase});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFE2F6FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            phase.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1F89B7),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 10),
          DateChip(
            date: phase.startDate,
            variant: DateChipVariant.secondary,
            backgroundColor: const Color(0xFFE2F6FF),
            color: const Color(0xFF1F89B7),
            iconColor: const Color(0xFF1F89B7),
            borderColor: const Color(0XFF1F89B7),
          ),
          const SizedBox(height: 6),
          DateChip(
            date: phase.endDate,
            variant: DateChipVariant.primary,
            backgroundColor: const Color(0xFF1F89B7),
            color: const Color(0xFFFFFFFF),
            iconColor: const Color(0xFFFFFFFF),
          ),
        ],
      ),
    );
  }
}

class _SubTaskRow extends StatelessWidget {
  final TimelineSubTask task;
  final bool showDivider;

  const _SubTaskRow({required this.task, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF797979),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              DateRangeRow2(
                startDate: task.startDate,
                endDate: task.endDate,
              ),
            ],
          ),
        ),
        if (showDivider)
          Container(height: 1, color: const Color(0xFFDEDEDE)),
      ],
    );
  }
}

// Custom Painter for continuous timeline line
class _TimelineLinePainter extends CustomPainter {
  final bool isLast;
  final int totalCards;
  final int cardIndex;

  const _TimelineLinePainter({
    required this.isLast,
    required this.totalCards,
    required this.cardIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const dotSize = 13.0;
    const dotCenterX = 10.0; // 20/2 = 10
    const dotCenterY = 6.5; // 13/2 = 6.5

    final linePaint = Paint()
      ..color = const Color(0xFF2196C4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw continuous line from top to bottom through circle center
    canvas.drawLine(
      Offset(dotCenterX, 0),
      Offset(dotCenterX, size.height),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(_TimelineLinePainter old) =>
      old.isLast != isLast || old.totalCards != totalCards;
}

class _TimelineCard extends StatelessWidget {
  final TimelinePhase phase;
  final bool isLast;
  final bool isFirst;

  const _TimelineCard({
    required this.phase,
    this.isLast = false,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline dot and line
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SizedBox(
              width: 40,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Continuous line
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _TimelineLinePainter(
                        isLast: isLast,
                        totalCards: 3,
                        cardIndex: 0,
                      ),
                    ),
                  ),
                  // Dot
                  Positioned(
                    top: 0,
                    left: 4,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196C4),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(33, 150, 196, 0.3),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Card content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 20, bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFC3C3C3), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.04),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phase.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1F89B7),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 8),
                        DateRangeRow(
                          startDate: phase.startDate,
                          endDate: phase.endDate,
                        ),
                        const SizedBox(height: 18),
                        const Divider(
                          thickness: 1,
                          height: 1,
                          color: Color(0xFFDEDEDE),
                        ),
                      ],
                    ),
                  ),
                  if (phase.subTasks.isNotEmpty) ...[
                    ...phase.subTasks.asMap().entries.map((e) {
                      return _SubTaskRow(
                        task: e.value,
                        showDivider: e.key < phase.subTasks.length - 1,
                      );
                    }),
                    const SizedBox(height: 4),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineDrawer extends StatelessWidget {
  final String projectTitle;
  final List<TimelinePhase> phases;

  const TimelineDrawer({
    super.key,
    required this.projectTitle,
    required this.phases,
  });

  static const List<TimelinePhase> samplePhases = [
    TimelinePhase(
      title: 'Project Sign-off & Kickoff',
      startDate: '12th December 2025',
      endDate: '25th December 2025',
    ),
    TimelinePhase(
      title: 'Soil Test & Survey',
      startDate: '05 Jan, 2026',
      endDate: '08 Jan, 2026',
      subTasks: [
        TimelineSubTask(
          title: 'Vendor Selection & Work Order',
          startDate: '08 Jan, 2026',
          endDate: '11 Jan, 2026',
        ),
        TimelineSubTask(
          title: 'Mobilization of Drilling Rig',
          startDate: '12 Jan, 2026',
          endDate: '14 Jan, 2026',
        ),
        TimelineSubTask(
          title: 'Mobilization of Drilling Rig',
          startDate: '12 Jan, 2026',
          endDate: '14 Jan, 2026',
        ),
      ],
    ),
    TimelinePhase(
      title: 'Site Fencing & Labor Shed',
      startDate: '15 Jan, 2026',
      endDate: '15 Jan, 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topPhase = phases.isNotEmpty ? phases.first : null;
    final timelinePhases =
        phases.length > 1 ? phases.sublist(1) : <TimelinePhase>[];

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.32,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: const Color(0xFFFFFFFF),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(28, 48, 12, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Timeline of the',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3F3F3F),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    projectTitle,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF3F3F3F),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            // Timeline content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 28),
                children: [
                  // First card (highlight)
                  if (topPhase != null) ...[
                    _TopHighlightCard(phase: topPhase),
                    const SizedBox(height: 24),
                  ],

                  // Timeline cards
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      children: [
                        ...timelinePhases.asMap().entries.map((entry) {
                          return _TimelineCard(
                            phase: entry.value,
                            isLast: entry.key == timelinePhases.length - 1,
                            isFirst: entry.key == 0,
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}