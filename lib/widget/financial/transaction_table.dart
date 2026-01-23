import 'package:flutter/material.dart';
import 'package:real_estate_flutter/utils/responsive_utils.dart';


class TransactionTable extends StatelessWidget {
 
  final List<Map<String, String>> transactions;

  const TransactionTable({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  _buildHeaderCell(context,'Date', 2),
                  _buildHeaderCell(context,'Description', 3),
                  _buildHeaderCell(context,'Money added', 2, align: TextAlign.center),
                  _buildHeaderCell(context,'Money Spent', 2, align: TextAlign.center),
                  _buildHeaderCell(context,'Balance', 2, align: TextAlign.right),
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
                          _buildCell(context,t['date']!, 2),
                          
                          // Description
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t['description']!,
                                  style: _textStyle(context, 18, 12, 20, const Color(0xFF3F3F3F)),
                                ),
                                SizedBox(
                                    height: IntakeLayoutTokens.xSmallSpacing(context)),
                                Text(
                                  t['subtitle']!,
                                  style: _textStyle(context, 16, 10, 18, const Color(0xFF8C8C8C)),
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
                                      style: _textStyle(context, 18, 12, 20, const Color(0xFF56B368)),
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
                                      style: _textStyle(context, 18, 12, 20, const Color(0xFFF24A4A)),
                                    ),
                            ),
                          ),

                          // Balance
                          Expanded(
                            flex: 2,
                            child: Text(
                              t['balance']!,
                              textAlign: TextAlign.right,
                              style: _textStyle(context, 18, 12, 20, const Color(0xFF3F3F3F)),
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

  // Helper widgets to reduce code repetition
  Widget _buildHeaderCell(BuildContext context, String text, int flex, {TextAlign align = TextAlign.start}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: ResponsiveUtils.scaleFont( context , 18, min: 14, max: 20),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          color: const Color(0xFF3F3F3F),
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: ResponsiveUtils.scaleFont(context, 18, min: 12, max: 20),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          color: const Color(0xFF3F3F3F),
        ),
      ),
    );
  }

  TextStyle _textStyle(BuildContext context, double input, double min, double max, Color color) {
    return TextStyle(
      fontSize: ResponsiveUtils.scaleFont(context, input, min: min, max: max),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      color: color,
    );
  }
}

class _EmptyAmountPlaceholder extends StatelessWidget {
  const _EmptyAmountPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '-',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Poppins',
        color: Colors.grey,
      ),
    );
  }
}