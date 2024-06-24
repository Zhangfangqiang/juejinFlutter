import 'dart:math';
import 'guess_app_bar.dart';
import 'result_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class GuessPage extends StatefulWidget {
  const GuessPage({super.key, required this.title});

  final String title;

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  int _type = 0; //0不知道是大是小, 1 大 2小
  int _value = 0;
  bool _guessing = false;
  Random _random = Random();
  TextEditingController _guessCtrl = TextEditingController();

  /**
   * 初始化状态
   */
  @override
  void initState() {
    super.initState();
    /*初始化动画控制器*/
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  /**
   * 释放资源，
   * 包括文本控制器和动画控制器。
   */
  @override
  void dispose() {
    _guessCtrl.dispose();
    controller.dispose();
    super.dispose();
  }

  /**
   * 生成随机数的方法
   */
  void _generateRandomValue() {
    setState(() {
      _guessing = true;
      _value = _random.nextInt(100);
    });
  }

  /**
   * 点击猜
   */
  void _onCheck() {
    int? guessValue = int.tryParse(_guessCtrl.text);
    /*如果没有生成随机数,或没有填写数字*/
    if (!_guessing || guessValue == null) {
      return;
    }

    controller.forward(from: 0);

    /*如果猜对了*/
    if (guessValue == _value) {
      setState(() {
        _type = 0;
        _guessing = false;
      });

      /*如果猜错了*/
    } else {
      setState(() {
        _type = guessValue > _value ? 1 : 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*涉及子操作父的数据*/
      appBar: GuessAppBar(
        controller: _guessCtrl,
        onCheck: _onCheck,
      ),
      body: Stack(
        children: [
          if (_type != 0)
            Column(
              children: [
                if (_type == 1)
                  ResultNotice(
                    color: Colors.redAccent,
                    info: '大了',
                    controller: controller,
                  ),
                Spacer(),
                if (_type == 2)
                  ResultNotice(
                    color: Colors.blueAccent,
                    info: '小了',
                    controller: controller,
                  ),
              ],
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!_guessing)
                  const Text(
                    '点击生成随机数值',
                  ),
                Text(
                  _guessing ? '**' : '$_value',
                  style: const TextStyle(
                      fontSize: 68, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _guessing ? null : _generateRandomValue,
        backgroundColor: _guessing ? Colors.grey : Colors.blue,
        tooltip: 'Increment',
        child: const Icon(Icons.generating_tokens_outlined),
      ),
    );
  }
}
