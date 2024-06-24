import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MuyuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTapHistory;

  /**
   * 构造方法
   */
  const MuyuAppBar({Key? key, required this.onTapHistory}) : super(key: key);


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text("电子木鱼"),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.transparent),
      actions: [
        /*绑定了跳转到历史记录页面*/
        IconButton(onPressed: onTapHistory, icon: const Icon(Icons.history)),
      ],
    );
  }

}
