import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/**
 * 无状态组件 实现 PreferredSizeWidget的 接口，用于指定 AppBar 的高度。
 */
class GuessAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onCheck;
  final TextEditingController controller;

  /**
   * 构造方法
   */
  const GuessAppBar({Key? key, required this.onCheck, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent),
      titleSpacing: 0,
      leading: Icon(
        Icons.menu,
        color: Colors.black,
      ),
      actions: [
        IconButton(
            splashRadius: 20,
            /*点击动作*/
            onPressed: onCheck,
            icon: Icon(
              Icons.run_circle_outlined,
              color: Colors.blue,
            ))
      ],
      backgroundColor: Colors.white,
      elevation: 0,
      title: TextField(
        /*控制器*/
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffF3F6F9),
            constraints: BoxConstraints(maxHeight: 35),
            border: UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            hintText: "输入 0~99 数字",
            hintStyle: TextStyle(fontSize: 14)),
      ),
    );
  }

  /**
   * 这个方法实现了 PreferredSizeWidget 接口，用于指定 AppBar 的高度。
   */
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}