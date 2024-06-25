import 'package:sqflite/sqflite.dart';
import 'package:juejinflutter/muyu/models/merit_record.dart';


class MeritRecordDao {
  /**
   * DB操作类
   */
  final Database database;

  /**
   * 构造函数
   */
  MeritRecordDao(this.database);

  /**
   * 表名
   */
  static String tableName = 'merit_record';

  /**
   * 创建表的sql语句
   */
  static String tableSql = """
CREATE TABLE $tableName (
id VARCHAR(64) PRIMARY KEY,
value INTEGER, 
image TEXT,
audio TEXT,
timestamp INTEGER
)""";

  /**
   * 插入数据
   */
  Future<int> insert(MeritRecord record) {
    return database.insert(
      tableName,
      record.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /**
   * 查询数据
   */
  Future<List<MeritRecord>> query() async {
    List<Map<String, Object?>> data = await database.query(
      tableName,
    );

    return data
        .map((e) => MeritRecord(
      e['id'].toString(),
      e['timestamp'] as int,
      e['value'] as int,
      e['image'].toString(),
      e['audio'].toString(),
    ))
        .toList();
  }
}