import 'package:flutter/material.dart';

/**
 * 无状态组件
 */
class ResultNotice extends StatelessWidget {
  final Color color;                    //颜色
  final String info;                    //字符串
  final AnimationController controller; //动画控制器

  /**
   * 构造方法
   */
  const ResultNotice({
    Key? key,
    required this.color,
    required this.info,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        color: color,
        /*使用AnimatedBuilder 给Text加点动画*/
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, child) => Text(
            info,
            style: TextStyle(
              color     : Colors.white,
              fontSize  : 54 * (controller.value),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}