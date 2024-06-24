import 'models/merit_record.dart';
import 'package:flutter/material.dart';

class AnimateText extends StatefulWidget {
  final MeritRecord record;

  /**
   * 构造函数
   */
  const AnimateText({Key? key, required this.record}) : super(key: key);

  @override
  State<AnimateText> createState() => _AnimateTextState();
}

class _AnimateTextState extends State<AnimateText> with SingleTickerProviderStateMixin {
  late Animation<double>   scale;
  late Animation<double>   opacity;
  late Animation<Offset>   position;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    scale      = Tween(begin: 1.0, end: 0.9).animate(controller);                                   //控制文本缩小动画
    opacity    = Tween(begin: 1.0, end: 0.0).animate(controller);                                   //控制文本透明度动画
    position   = Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero).animate(controller);    //控制文本位移动画

    controller.forward();
  }

  /**
   * didUpdateWidget 方法用于检测传入的 record 对象是否发生变化。
   * 如果 oldWidget.record.id != widget.record.id，表示 record 对象已经更新，
   * 需要重新播放动画。这时调用 controller.forward(from: 0) 从头开始播放动画。
   */
  @override
  void didUpdateWidget(covariant AnimateText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.record.id != widget.record.id) {
      controller.forward(from: 0);
    }
  }

  /**
   * dispose 方法中释放了 AnimationController，
   * 防止内存泄漏和无效的动画回调。
   */
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: SlideTransition(
          position: position,
          child: FadeTransition(
            opacity: opacity,
            child: Text('功德+${widget.record.value}'),
          )),
    );
  }
}
