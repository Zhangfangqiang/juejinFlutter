import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flame_audio/flame_audio.dart';

import 'muyu_image.dart';
import 'count_panel.dart';
import 'animate_text.dart';
import 'muyu_app_bar.dart';
import 'record_history.dart';
import 'models/audio_option.dart';
import 'models/image_option.dart';
import 'models/merit_record.dart';
import 'options/select_audio.dart';
import 'options/select_image.dart';

class MuyuPage extends StatefulWidget {
  const MuyuPage({Key? key}) : super(key: key);
  @override
  State<MuyuPage> createState() => _MuyuPageState();
}

class _MuyuPageState extends State<MuyuPage> {
  int _counter = 0;
  AudioPool? pool;
  MeritRecord? _cruRecord;

  int _activeImageIndex = 0;
  int _activeAudioIndex = 0;

  /**
   * 需要计算的值使用final
   */
  final Uuid uuid            = Uuid();   //唯一id
  final Random _random       = Random(); //随机功德数
  List<MeritRecord> _records = [];       //存放敲击历史记录

  final List<AudioOption> audioOptions = const [
    AudioOption('音效1', 'muyu_1.mp3'),
    AudioOption('音效2', 'muyu_2.mp3'),
    AudioOption('音效3', 'muyu_3.mp3'),
  ];

  final List<ImageOption> imageOptions = const [
    ImageOption('基础版', 'assets/images/muyu.png', 1, 3),
    ImageOption('尊享版', 'assets/images/muyu2.png', 3, 6),
  ];

  String get activeAudio => audioOptions[_activeAudioIndex].src;
  String get activeImage => imageOptions[_activeImageIndex].src;

  int get knockValue {
    int min = imageOptions[_activeImageIndex].min;      //绑定木鱼后,敲击得分最小值
    int max = imageOptions[_activeImageIndex].max;      //绑定木鱼后,敲击得分最大值
    return min + _random.nextInt(max + 1 - min);        //最大最小之间取一个随机数
  }

  /**
   * 初始化数据
   */
  @override
  void initState() {
    super.initState();
    _initAudioPool();
  }

  /**
   * 创建音频池
   */
  void _initAudioPool() async {
    /**
     * FlameAudio.createPool  : 这是调用 FlameAudio 类的 createPool 方法，用于创建一个音频池。FlameAudio 是 Flame 游戏引擎的一部分，专门用于处理音频的工具包。
     * muyu_1.mp3             : 这是音频文件的路径，表示要加载的音频文件。
     * maxPlayers             : 1这是一个命名参数，表示这个音频池中最多可以同时播放的音频实例数。在这种情况下，最多只能同时播放一个实例。
     */
    pool = await FlameAudio.createPool('muyu_1.mp3', maxPlayers: 1);
  }

  /**
   * 跳转到历史记录页
   */
  void _toHistory() {
    Navigator.of(context).push(
      /*跳转到历史记录页, 在构建页面的时候传递历史记录列表*/
      MaterialPageRoute(
          builder: (_) => RecordHistory(records: _records.reversed.toList())),
    );
  }

  /**
   * 选音频弹框
   */
  void _onTapSwitchAudio() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return AudioOptionPanel(
          audioOptions: audioOptions,
          activeIndex: _activeAudioIndex,
          onSelect: _onSelectAudio,
        );
      },
    );
  }

  /**
   * 选中音频后的事件
   */
  void _onSelectAudio(int value) async {
    Navigator.of(context).pop();
    if (value == _activeAudioIndex) return;
    _activeAudioIndex = value;
    pool = await FlameAudio.createPool(
      activeAudio,
      maxPlayers: 1,
    );
  }

  /**
   * 选图片弹框
   */
  void _onTapSwitchImage() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ImageOptionPanel(
          imageOptions: imageOptions,
          activeIndex: _activeImageIndex,
          onSelect: _onSelectImage,
        );
      },
    );
  }

  /**
   * 选中图片后的事件
   */
  void _onSelectImage(int value) {
    Navigator.of(context).pop();    //
    if (value == _activeImageIndex) return;
    setState(() {
      _activeImageIndex = value;
    });
  }

  /**
   * 敲击木鱼的方法
   */
  void _onKnock() {
    pool?.start();        //播放音乐

    setState(() {
      _cruRecord = MeritRecord(
        uuid.v4(),
        DateTime.now().millisecondsSinceEpoch,
        knockValue,
        activeImage,
        audioOptions[_activeAudioIndex].name,
      );

      _counter += _cruRecord!.value;    //MeritRecord 构造的情况下,可能会出现其他情况, 会为空, 所以要断言一下
      _records.add(_cruRecord!);        // 添加功德记录
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*导航头部开始*/
      appBar: MuyuAppBar(
        onTapHistory: _toHistory,
      ),
      /*导航头部结束*/

      body: Column(
        children: [
          /*计数和选择木鱼音乐开始*/
          Expanded(
            child: CountPanel(
              count: _counter,
              onTapSwitchAudio: _onTapSwitchAudio,
              onTapSwitchImage: _onTapSwitchImage,
            ),
          ),
          /*计数和选择木鱼音乐结束*/

          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                /*展示中间图片的木鱼*/
                MuyuAssetsImage(
                  image: activeImage,
                  onTap: _onKnock,
                ),
                /*动画文字*/
                if (_cruRecord != null) AnimateText(record: _cruRecord!)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
