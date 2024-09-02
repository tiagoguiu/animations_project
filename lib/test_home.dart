
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String _platformVersion = 'Unknown';
  //final _FacialLivenessDetectionFlutterPluginPlugin = FacialLivenessDetectionFlutterPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      //_FacialLivenessDetectionFlutterPluginPlugin.initEngine();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin examxxxple app'),
          ),
          body: Column(children: [
            Text('Running on: $_platformVersion\n'),
            ElevatedButton(
                onPressed: () async {
                  print('button pressed!');
                  Map<String, dynamic> config = {
                    "livingType": 23,
                    "age": 30,
                  };

                  // 1. 认证初始化
                  Map<String, dynamic> result =
                      await _FacialLivenessDetectionFlutterPluginPlugin.verifyInit(config) ?? {};
                  String code = result['code'];
                  String initMsg = result['data'];
                  print("code" + result['code']);
                  print("msg" + result['msg']);
                  print("data" + result['data']);
                  if (code == "ELD_SUCCESS") {
                    //Map<String, dynamic> initResBody = await init(initMsg);
                    Map<String, dynamic> verifyResult =
                        await _FacialLivenessDetectionFlutterPluginPlugin.startLivingDetect({}) ?? {};
                  }
                },
                child: const Text('启动刷脸'))
          ])),
    );
  }
}
*/