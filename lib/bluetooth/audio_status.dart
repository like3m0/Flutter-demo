import 'dart:async';
import 'dart:core';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xiangyue/bluetooth/bluetooth_channel.dart';

class AudioStatus extends ChangeNotifier {
  bool connected = false;
  bool isListening = false;
  var Bass = 5;
  var Treble = 5;
  var Fader = 11;
  var Balance = 11;
  var EQIndex = -1;
  var freqCustom1 = [12, 12, 12, 12, 12, 12, 12, 12, 12];
  var freqCustom2 = [12, 12, 12, 12, 12, 12, 12, 12, 12];

  static const String carAddress = "F8:6B:14:7A:22:E4";  // 修改为你的实际地址

  void setConnectStauts(bool status) {
    print("set connect status to: [$status]");
    this.connected = status;
    notifyListeners();
  }

  void setFaderAndBalance(int iFader, int iBalance) {
    this.Fader = iFader;
    this.Balance = iBalance;
    notifyListeners();
  }

  void setBass(int iBass) {
    this.Bass = iBass;
    notifyListeners();
  }

  void setTreble(int iTreble) {
    this.Treble = iTreble;
    notifyListeners();
  }

  void setEQ(int index) {
    this.EQIndex = index;
    notifyListeners();
  }

  void setCustomFreq(int index, List<int> freqs) {
    for (int i = 0; i < 9; i++) {
      if (index == 0) {
        this.freqCustom1[i] = freqs[i];
      } else {
        this.freqCustom2[i] = freqs[i];
      }
    }
    notifyListeners();
  }

  void readDataFromDA(List<int> data) {
    // 调用蓝牙，获取状态数据
    print("read from data");
    Bass = data[1];
    Treble = data[2];
    Fader = data[3];
    Balance = data[4];
    EQIndex = data[5];
    freqCustom1 = data.sublist(6, 15);
    freqCustom2 = data.sublist(15);
    notifyListeners();
  }

  Future<bool> _requestBluetoothPermissions() async {
    if (Platform.isAndroid) {
      final statuses = await [
        Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
        // Permission.location, // 有些机型要这个才能正常蓝牙
      ].request();

      bool allGranted = true;
      statuses.forEach((key, status) {
        print("[BT][PERM] $key = $status");
        if (!status.isGranted) {
          allGranted = false;
        }
      });
      return allGranted;
    }
    return true;
  }
  Future<void> debugPerms() async {
    print("[BT][PERM] bluetooth = ${await Permission.bluetooth.status}");
    print("[BT][PERM] connect  = ${await Permission.bluetoothConnect.status}");
    print("[BT][PERM] scan     = ${await Permission.bluetoothScan.status}");
    print("[BT][PERM] adv      = ${await Permission.bluetoothAdvertise.status}");
    print("[BT][PERM] location = ${await Permission.location.status}");
  }
  void listen() async {
    if (isListening) {
      print("[AudioStatus] is listening, return");
      return;
    }

    print("[AudioStatus] now begin to listen..........");
    isListening = true;

    // 1. 申请权限
    bool permsOk = await _requestBluetoothPermissions();
    await debugPerms();
    if (!permsOk) {
      print("[BT][ERROR] Bluetooth permissions not granted, abort listen.");
      setConnectStauts(false);
      isListening = false;
      return;
    }

    try {
      // 2. 确保蓝牙开着
      final enabled = await FlutterBluetoothSerial.instance.isEnabled;
      if (enabled != true) {
        print("[BT] Bluetooth not enabled, requesting enable...");
        await FlutterBluetoothSerial.instance.requestEnable();
      }

      // 3. （可选）让手机可被发现一段时间，方便车机连过来
      //    有些车机会“挑”当前可发现的设备
      print("[BT] request discoverable for 120s ...");
      // await FlutterBluetoothSerial.instance.requestDiscoverable(180);

      print("[AudioStatus] about to call BluetoothConnection.listen(...)");

      // 4. 给 listen 加一个 30 秒超时，避免一直卡死
      BluetoothConnection conn = await BluetoothConnection
          .listen("00001101-0000-1000-8000-00805F9B34FB");

      print("[BT] listen returned, isConnected=${conn.isConnected}");

      if (conn.isConnected) {
        print("[BT] client connected, create RFCommChannel");
        setConnectStauts(true);
        RFCommChannel.initChannel(conn, this);
      } else {
        print("[BT][WARN] listen returned but connection is not connected");
        setConnectStauts(false);
      }
    } on TimeoutException catch (e) {
      print("[BT][ERROR] listen timeout, no device connected within 30s: $e");
      setConnectStauts(false);
    } catch (e, s) {
      print("[BT][ERROR] listen failed with exception: $e");
      print(s);
      setConnectStauts(false);
    } finally {
      isListening = false;
    }
  }

}
