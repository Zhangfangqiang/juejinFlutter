import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String kGuessSpKey = 'guess-config';
const String kMuYUSpKey  = 'muyu-config';

class SpStorage {
  /**
   * 私有化构造函数
   */
  SpStorage._();

  /**
   * 类的静态实例, 存SpStorage的实力
   */
  static SpStorage? _storage;

  /**
   * 获取单例实例的静态方法
   */
  static SpStorage get instance {
    _storage = _storage ?? SpStorage._();
    return _storage!;
  }

  /**
   * 存储SharedPreferences的实例,轻量级存储类
   */
  SharedPreferences? _sp;

  /**
   * 确保 SharedPreferences 初始化一次
   */
  Future<void> initSpWhenNull() async {
    if (_sp != null) return;
    _sp = _sp ?? await SharedPreferences.getInstance();
  }

  /**
   * 猜数字 存储数据
   */
  Future<bool> saveGuessConfig({bool? guessing, int? value,}) async {
    await initSpWhenNull();
    String content = json.encode({'guessing': guessing, 'value': value});
    return _sp!.setString(kGuessSpKey, content);
  }

  /**
   * 猜数字 读取数据
   */
  Future<Map<String,dynamic>> readGuessConfig() async {
    await initSpWhenNull();
    String content = _sp!.getString(kGuessSpKey)??"{}";
    return json.decode(content);
  }

  /**
   * 木鱼数据 存储
   */
  Future<bool> saveMuYUConfig({required int counter, required int activeImageIndex, required int activeAudioIndex}) async {
    await initSpWhenNull();
    String content = json.encode({
      'counter': counter,
      'activeImageIndex': activeImageIndex,
      'activeAudioIndex': activeAudioIndex,
    });
    return _sp!.setString(kMuYUSpKey, content);
  }

  /**
   * 木鱼数据 读取
   */
  Future<Map<String, dynamic>> readMuYUConfig() async {
    await initSpWhenNull();
    String content = _sp!.getString(kMuYUSpKey) ?? "{}";
    return json.decode(content);
  }
}