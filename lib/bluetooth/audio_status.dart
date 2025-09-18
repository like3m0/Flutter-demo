import 'dart:core';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
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
    //调用蓝牙，获取状态数据
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

  void listen() async {
    if (this.isListening) {
      print("is listening, return");
      return;
    }
    print("now begin to listen..........");
    this.isListening = true;
    try {
      BluetoothConnection conn = await BluetoothConnection.listen(
          "00001101-0000-1000-8000-00805F9B34FB");
      if (conn != null) {
        print("listen successful! create channel");
        RFCommChannel.initChannel(conn, this);
      }
      this.isListening = false;
    } catch (e) {
      print("listen failed with exception");
      print(e.toString());
      this.isListening = false;
    }
  }
}
