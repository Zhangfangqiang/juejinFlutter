import 'app_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:juejinflutter/paper/paper.dart';
import 'package:juejinflutter/muyu/muyu_page.dart';
import 'package:juejinflutter/guess/guess_page.dart';
import 'package:juejinflutter/counter/counter_page.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({Key? key}) : super(key: key);
  @override
  State<AppNavigation> createState() => _AppNavigationState();
}
class _AppNavigationState extends State<AppNavigation> {
  int _index                 = 0;                   //页面的索引值
  final PageController _ctrl = PageController();    //用于控制 PageView 的页面切换

  /**
   * 页面菜单按钮
   */
  final List<MenuData> menus = const [
    MenuData(label: '计数器', icon: Icons.cable),
    MenuData(label: '猜数字', icon: Icons.question_mark),
    MenuData(label: '电子木鱼', icon: Icons.my_library_music_outlined),
    MenuData(label: '白板绘制', icon: Icons.palette_outlined),
  ];

  /**
   * 页面跳转修改页面索引
   */
  void _onChangePage(int index) {
    _ctrl.jumpToPage(index);
    setState(() {
      _index = index;
    });
  }

  Widget _buildContent() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),      //禁止用户手滑切换
      controller: _ctrl,                                  //用户页面控制器
      children: const [
         MyHomePage(title:"计数器"),
         GuessPage(title:"猜数字"),
         MuyuPage(),
         Paper(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildContent(),
        ),

        AppBottomBar(
          currentIndex: _index,
          onItemTap: _onChangePage,
          menus: menus,
        )
      ],
    );
  }
}

