import '../models/image_option.dart';
import 'package:flutter/material.dart';

class ImageOptionPanel extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onSelect;
  final List<ImageOption> imageOptions;

  /**
   * 构造方法
   */
  const ImageOptionPanel({
    Key? key,
    required this.onSelect,
    required this.activeIndex,
    required this.imageOptions,
  }) : super(key: key);

  Widget _buildByIndex(int index) {
    bool active = index == activeIndex;
    return GestureDetector(
      onTap: () => onSelect(index),
      child: ImageOptionItem(
        option: imageOptions[index],
        active: active,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle labelStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    const EdgeInsets padding   = EdgeInsets.symmetric(horizontal: 8.0, vertical: 16);


    return Material(
      child: SizedBox(
        height: 300,
        child: Column(
          children: [
            Container(
                height: 46,
                alignment: Alignment.center,
                child: const Text(
                  "选择木鱼",
                  style: labelStyle,
                )),
            Expanded(
                child: Padding(
              padding: padding,
              child: Row(
                children: List.generate(imageOptions.length, (index) => Expanded(child: _buildByIndex(index))),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

/**
 * 图片选择的item
 */
class ImageOptionItem extends StatelessWidget {
  final bool active;
  final ImageOption option;

  const ImageOptionItem({
    Key? key,
    required this.option,
    required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Border activeBorder = Border.fromBorderSide(BorderSide(color: Colors.blue));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: !active ? null : activeBorder,
      ),
      child: Column(
        children: [
          Text(option.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(option.src),
            ),
          ),
          Text('每次功德 +${option.min}~${option.max}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
