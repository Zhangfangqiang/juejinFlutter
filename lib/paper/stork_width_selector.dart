import 'package:flutter/material.dart';

class StorkWidthSelector extends StatelessWidget {
  final int activeIndex;
  final Color color;
  final List<double> supportStorkWidths;
  final ValueChanged<int> onSelect;

  /**
   * 构造方法
   */
  const StorkWidthSelector({
    Key? key,
    required this.supportStorkWidths,
    required this.activeIndex,
    required this.onSelect,
    required this.color,
  }) : super(key: key);

  /**
   * 线条item
   */
  Widget _buildByIndex(int index) {
    bool select = index == activeIndex;
    return GestureDetector(
      onTap: () => onSelect(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 70,
        height: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: select ? Border.all(color: Colors.blue) : null),
        child: Container(
          width: 50,
          color: color,
          height: supportStorkWidths[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          /*遍历线条的粗细*/
          children: List.generate(supportStorkWidths.length, _buildByIndex)),
    );
  }
}
