import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:xiangyue/bluetooth/audio_status.dart';
import 'package:xiangyue/bluetooth/data_pack.dart';
import 'package:xiangyue/main.dart';
import 'package:xiangyue/utils/pop_dialog.dart';
import 'package:xiangyue/utils/toast_util.dart';

class RFCommChannel {
  AudioStatus applicationStatus;
  BluetoothConnection connection;
  List<DataPack> packToSend = <DataPack>[];
  DataPack? packToInsert;
  DataPack? packPending;
  DataPack? received ;

  int retryCount = 0;

  static RFCommChannel? _instance;
  Completer<DataPack>? _completer;
  bool isSending = false;
  bool isRetrying = false;
  Timer? _timer;
  Timer? _heartBeat_timer;
  DateTime? lastHBTime;

  //构造函数
  RFCommChannel(BluetoothConnection conn, AudioStatus status)
      : connection = conn,
        applicationStatus = status;

  static RFCommChannel? getInstance() {
    return _instance;
  }

  static void resetChannel() {
    if (_instance != null) {
      if (_instance?.connection != null) {
        _instance?.connection.close();
      }
      if (_instance?._timer != null) {
        _instance?._timer?.cancel();
        _instance?._timer;
      }
      if (_instance?._heartBeat_timer != null) {
        _instance?._heartBeat_timer?.cancel();
        _instance?._heartBeat_timer = null;
      }
      _instance = null;
    }
  }

  static void initChannel(BluetoothConnection conn, AudioStatus status) {
    resetChannel();
    print(conn.output);
    _instance = new RFCommChannel(conn, status);
    _instance?.applicationStatus.setConnectStauts(true);
    print("register listen stream here!!!!!!!!!");
    _instance?.connection.input?.listen((data) {
      var s = "receive data:\n";
      DataPack dp = DataPack.fromIntList(data.toList());
      _instance?.receivePack(dp);
      print(s + dp.toString());
    }, onDone: () {
      //notify UI connection is corrupt here
      print("connection is corrupt, need reinit!");
      if (_instance != null) {
        _instance?.applicationStatus.setConnectStauts(false);
      }
      resetChannel();
    }, onError: (obj, stackTrace) {
      print("receive error:" + stackTrace.toString());
      _instance?.isSending = false;
    });
    // 开始循环发送数据
    _instance?._timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      ///自增
      _instance?.checkAndSendDataAsync();
      // _instance.checkAndSendRetryVersion();
    });

    Timer(Duration(milliseconds: 200), () {
      _instance?.lastHBTime = DateTime.now();
      _instance?._heartBeat_timer =
          Timer.periodic(Duration(seconds: 1), (timer) {
        DataPack dp = DataPack.initHeartBeat();
        _instance?.addPack(dp);

        //判断是否没有接受到心跳已达3秒
        DateTime dt = DateTime.now();
        var delta = dt.millisecondsSinceEpoch -
            (_instance?.lastHBTime?.millisecondsSinceEpoch ?? 0);
        print("heart beat delta time in milliseconds:" + delta.toString());
        if (delta > 30000) {
          BuildContext? ctx = navigatorKey.currentState?.overlay?.context;
          showNotifyDialog(ctx!, '''Display Audio is not responding. 
Please check connection
with Display Audio.''');
          _instance?.applicationStatus.setConnectStauts(false);
          RFCommChannel.resetChannel();
        }
      });
      print("begin heart beat counting at:" + _instance!.lastHBTime!.toString());
    });
  }

  void receivePack(DataPack dp) {
    print("@@@@@@@@@@@recv pack:" + dp.toString());
    print("@@@@@@@@@@@recv time:" + DateTime.now().toString());
    received = dp;
    // change audiostatus data here
    if (dp.commandId == 0x26) {
      this.applicationStatus.readDataFromDA(dp.data);
    } else if (dp.bufferLen == 0) {
      //receive heart beat response
      DateTime dt = DateTime.now();
      _instance?.lastHBTime = dt;
      print("receive heart beat response at:" + dt.toString());
    }
    // else if (dp.commandId == 0x20 && dp.data[0] == 0) {
    //   this.applicationStatus.setBass(dp.data[1]);
    // } else if (dp.commandId == 0x21 && dp.data[0] == 0) {
    //   this.applicationStatus.setTreble(dp.data[1]);
    // } else if (dp.commandId == 0x22 && dp.data[0] == 0) {
    //   this.applicationStatus.setFaderAndBalance(dp.data[1], dp.data[2]);
    // }
    // if (_completer != null) {
    //   if (_completer.isCompleted == false) {
    //     _completer.complete(dp);
    //   }
    // }
    //收到任何返回包，重置发送、重试标记
    // isSending = false;
  }

  Future<DataPack> sendPack(DataPack dp) {
    // 如果上一笔还没结束，可以按需取消/报错
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.completeError(StateError('Previous request was superseded'));
    }

    final completer = Completer<DataPack>();
    _completer = completer;

    print("**********send pack: $dp");
    connection.output.add(dp.toByteArray());

    // 500ms 未返回就视为超时
    Timer(const Duration(milliseconds: 500), () {
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException('No response within 500 ms'),
        );
      }
    });

    return completer.future; // ✅ 一定是非空
  }

  void addPack(DataPack dp) {
    this.packToSend.add(dp);
  }

  void checkAndSendData() {
    if (isSending) {
      return;
    }
    if (packToSend.length > 0) {
      this.sendPack(this.packToSend[0]);
      this.packPending = this.packToSend[0];
      this.packToSend.removeAt(0);
      return;
    }
  }

  void checkAndSendDataAsync() {
    if (packToSend.length > 0) {
      print("&&&&&&&&&&&send packet:" + this.packToSend[0].toString());
      print("&&&&&&&&&&&send time:" + DateTime.now().toString());
      this.connection.output.add(this.packToSend[0].toByteArray());
      this.packPending = this.packToSend[0];
      this.packToSend.removeAt(0);
    }
  }

  void checkAndSendRetryVersion() async {
    if (isSending) {
      return;
    }
    if (packToSend.length > 0) {
      print("&&&&&&&&&&&send packet:" + this.packToSend[0].toString());
      DataPack dp = this.packToSend[0];
      this.packPending = this.packToSend[0];
      this.packToSend.removeAt(0);
      isSending = true;
      DataPack ret = await this.sendPack(dp);
      if (ret != null) {
        //成功取得发送结果，视为成功，设置retryCount
        print("success! got response!");
        this.retryCount = 0;
      } else {
        //超时返回，视为失败，重试3次
        print("failed! timeout");
        this.retryCount++;
        if (this.retryCount > 3) {
          //重试已达3次，不再重试
          this.retryCount = 0;
        } else {
          //将结果放回队列
          print("retry ${this.retryCount} times!");
          this.packToSend.insert(0, dp);
        }
        isSending = false;
      }
    }
  }

  static bool isToast = false;
  static bool requestChannel(DataPack dp) {
    print("want to send dpppp:" + dp.toString());
    if (getInstance() == null) {
      if (!isToast) {
        isToast = true;
        Timer(Duration(milliseconds: 100), () {
          BuildContext? ctx = navigatorKey.currentState?.overlay?.context;
          if (ctx != null) {
            showNotifyDialog(ctx, '''No device connected.
Please establish connection
with Display Audio.''');
          } else {
            Timer(Duration(seconds: 3), () {
              isToast = false;
            });
          }
        });
        return false;
      }
      return false;
    }
    getInstance()?.addPack(dp);
    return true;
  }

  static void requestChannelSilent(DataPack dp) {
    print("want to send dpppp:" + dp.toString());
    if (getInstance() == null) {
      return;
    }
    getInstance()?.addPack(dp);
  }
}
