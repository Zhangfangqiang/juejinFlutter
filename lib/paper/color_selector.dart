import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final int activeIndex;
  final List<Color> supportColors;
  final ValueChanged<int> onSelect;

  /**
   * 构造方法
   * 支持的颜色组, 选中的颜色索引,选中颜色的方法
   */
  const ColorSelector({Key? key, required this.supportColors, required this.activeIndex, required this.onSelect}) : super(key: key);

  Widget _buildByIndex(int index) {
    bool select = index == activeIndex;
    return GestureDetector(
      onTap: () => onSelect(index),
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: select ? Border.all(color: Colors.blue) : null
        ),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: supportColors[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Wrap(
          /*循环遍历颜色*/
          children: List.generate(supportColors.length, _buildByIndex)),
    );
  }

}
