import 'dart:ui';
import 'dart:math';
import 'model.dart';
import 'paper_app_bar.dart';
import 'stork_width_selector.dart';
import 'package:flutter/material.dart';
import 'package:juejinflutter/paper/color_selector.dart';
import 'package:juejinflutter/paper/conform_dialog.dart';


/**
 * 有状态的组件
 */
class Paper extends StatefulWidget {
  const Paper({Key? key}) : super(key: key);
  @override
  State<Paper> createState() => _PaperState();
}
class _PaperState extends State<Paper> {
  List<Line> _lines          = []; // 线列表
  int _activeColorIndex      = 0;  // 颜色激活索引
  int _activeStorkWidthIndex = 0;  // 线宽激活索引
  List<Line> _historyLines   = []; // 存放历史记录

  // 支持的颜色
  final List<Color> supportColors = [
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.grey,
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.indigoAccent,
    Colors.purpleAccent,
    Colors.pinkAccent
  ];

  // 支持的线粗
  final List<double> supportStorkWidths = [1, 2, 4, 6, 8, 10];

  /**
   * 撤销方法
   */
  void _back() {
    Line line = _lines.removeLast();    //移除最后一条
    _historyLines.add(line);            //添加到返回历史中
    setState(() {});                    //更新数据
  }

  /**
   * 清除方法
   */
  void _clear() {
    _lines.clear();                 //清除
    Navigator.of(context).pop();    //关闭上一个弹框
    setState(() {});                //假装更新数据的方式,更新一下ui
  }

  /**
   * 反撤销方法
   */
  void _revocation() {
    Line line = _historyLines.removeLast();   //移除一条历史数据
    _lines.add(line);                         //添加到线上
    setState(() {});                          //更新数据
  }

  /**
   * 清除所有绘画弹框
   */
  void _showClearDialog() {
    String msg = "您的当前操作会清空绘制内容，是否确定删除!";
    showDialog(
        context: context,
        builder: (ctx) => ConformDialog(title: '清空提示', conformText: '确定', msg: msg, onConform: _clear)
    );
  }

  /**
   * 开始画线
   */
  void _onPanStart(DragStartDetails details) {
    _lines.add(Line(
      points: [details.localPosition],
      strokeWidth: supportStorkWidths[_activeStorkWidthIndex],
      color: supportColors[_activeColorIndex],
    ));
  }

  /**
   * 开始画中
   */
  void _onPanUpdate(DragUpdateDetails details) {
    print(details.localPosition);
    _lines.last.points.add(details.localPosition);    //不断添加点位信息
    setState(() {});                                  //假装改变数据,更新ui
  }

  /**
   * 修改选中的线条宽度
   */
  void _onSelectStorkWidth(int index) {
    if (index != _activeStorkWidthIndex) {
      setState(() {
        _activeStorkWidthIndex = index;
      });
    }
  }

  /**
   * 修改选中的颜色
   */
  void _onSelectColor(int index) {
    if (index != _activeColorIndex) {
      setState(() {
        _activeColorIndex = index;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*画板app头开始*/
      appBar: PaperAppBar(
        onClear: _showClearDialog,
        onBack: _lines.isEmpty ? null : _back,
        onRevocation: _historyLines.isEmpty ? null : _revocation,
      ),
      /*画板app头结束*/

      /*堆叠布局开始*/
      body: Stack(
        children: [
          /*识别手势的组件开始*/
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            /*自定义绘制组件开始*/
            child: CustomPaint(
              painter: PaperPainter(lines: _lines),
              child: ConstrainedBox(constraints: const BoxConstraints.expand()),
            ),
            /*自定义绘制组件结束*/
          ),
          /*识别手势的组件结束*/

          /*堆叠布局指定位置底部开始*/
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                /*占剩余空间开始*/
                Expanded(
                  child: ColorSelector(
                    supportColors: supportColors,
                    activeIndex: _activeColorIndex,
                    onSelect: _onSelectColor,
                  ),
                ),
                /*占剩余空间结束*/

                /*线粗细选择开始*/
                StorkWidthSelector(
                  supportStorkWidths: supportStorkWidths,
                  color: supportColors[_activeColorIndex],
                  activeIndex: _activeStorkWidthIndex,
                  onSelect: _onSelectStorkWidth,
                ),
                /*线粗细选择结束*/
              ],
            ),
          ),
          /*堆叠布局指定位置底部结束*/
        ],
      ),
      /*堆叠布局结束*/

    );
  }
}

class PaperPainter extends CustomPainter {
  late Paint _paint;        //一个 Paint 对象，用于定义绘制线条的样式，包括颜色和宽度等
  final List<Line> lines;   //存储了所有要绘制的线条的信息

  /**
   * 构造方法
   */
  PaperPainter({required this.lines}) {
    _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < lines.length; i++) {
      drawLine(canvas, lines[i]);
    }
  }

  /**
   * 根据点位绘制线
   */
  void drawLine(Canvas canvas, Line line) {
    _paint.color = line.color;
    _paint.strokeWidth = line.strokeWidth;
    canvas.drawPoints(PointMode.polygon, line.points, _paint);
  }

  /**
   * shouldRepaint 方法确定是否需要重新绘制（重绘）。
   * 这里总是返回 true，表示每次调用 paint 方法时都会重新绘制，
   * 因此可以实时更新画布上的内容
   */
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
