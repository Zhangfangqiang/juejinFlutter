import 'package:intl/intl.dart';
import 'models/merit_record.dart';
import 'package:flutter/material.dart';

DateFormat format = DateFormat('yyyy年MM月dd日 HH:mm:ss');

class RecordHistory extends StatelessWidget {
  final List<MeritRecord> records;      //敲击历史记录

  /**
   * 构造方法
   */
  const RecordHistory({Key? key, required this.records}) : super(key: key);

  /**
   * AppBar 小组件
   */
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: const Text(
        '功德记录',
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  /**
   * 列表item 组件
   */
  Widget _buildItem(BuildContext context, MeritRecord item) {
    String      date  = format.format(DateTime.fromMillisecondsSinceEpoch(item.timestamp));

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        backgroundImage: AssetImage(item.image),
      ),
      title: Text('功德 +${item.value}'),
      subtitle: Text(item.audio),
      trailing: Text(
        date, style: const TextStyle(fontSize: 12, color: Colors.grey),),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:_buildAppBar(),
      body: Column(
        children: List.generate(
            records.length, (index) => _buildItem(context, records[index])
        ),
      ),
    );
  }
}
