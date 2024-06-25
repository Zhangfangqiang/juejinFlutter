import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'tables/merit_record_dao.dart';
import 'package:path/path.dart' as path;

class DbStorage {
  /**
   * 私有化构造函数
   */
  DbStorage._();

  /**
   * 存储DbStorage的 实例的变量
   */
  static DbStorage? _storage;

  /**
   * 单例调用方式
   */
  static DbStorage get instance {
    _storage = _storage ?? DbStorage._();
    return _storage!;
  }

  /**
   * db操作类
   */
  late Database _db;

  /**
   * 表
   */
  late MeritRecordDao _meritRecordDao;
  MeritRecordDao get meritRecordDao => _meritRecordDao;

  /**
   * 链接数据库
   */
  Future<void> open() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = path.join(databasesPath, 'first_station.db');
    _db = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    _meritRecordDao = MeritRecordDao(_db);
  }

  /**
   * 创建表
   */
  void _onCreate(Database db, int version) async {
    await db.execute(MeritRecordDao.tableSql);
  }
}