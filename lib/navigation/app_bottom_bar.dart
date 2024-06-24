import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/**
 * 定义数据类型
 */
class MenuData {
  final String label;       // 标签
  final IconData icon;      // 图标数据
  const MenuData({required this.label, required this.icon});
}


class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  final List<MenuData> menus;
  final ValueChanged<int>? onItemTap;

  /**
   * 构造方法
   */
  const AppBottomBar({Key? key, this.onItemTap, this.currentIndex = 0, required this.menus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      onTap: onItemTap,                                     //点击切换button的方法
      currentIndex: currentIndex,                           //选中的index
      elevation: 3,
      type: BottomNavigationBarType.fixed,
      iconSize: 22,
      selectedItemColor: Theme.of(context).primaryColor,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      items: menus.map(_buildItemByMenuMeta).toList(),      //菜单列表
    );
  }

  BottomNavigationBarItem _buildItemByMenuMeta(MenuData menu) {
    return BottomNavigationBarItem(label: menu.label, icon: Icon(menu.icon));
  }
}
