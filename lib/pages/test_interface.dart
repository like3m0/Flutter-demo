import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:xiangyue/bluetooth/audio_status.dart';
import 'package:xiangyue/bluetooth/bluetooth_channel.dart';
import 'package:xiangyue/bluetooth/data_pack.dart';
import 'package:xiangyue/utils/toast_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:xiangyue/widgets/number_step.dart';
import 'package:provider/provider.dart';

class TestInterface extends StatelessWidget {
  final BluetoothConnection _conn;
  TestInterface(BluetoothConnection conn) : _conn = conn {}

  int bass = 0;
  int treble = 0;
  int fader = 0;
  int balance = 0;
  int eq = 0;

  void initState() {
    // print("initState");
    // AudioStatus au = new AudioStatus();
    // RFCommChannel.initChannel(_conn, au);
    // this._conn.input.listen((data) {
    //   var s = "receive data:\n";
    //   DataPack dp = DataPack.fromIntList(data.toList());
    //   ToastUtil.toast(s + dp.toString());
    // });
  }

  void showData(BuildContext context, String data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("发送数据："),
            content: Text(data),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("关闭"),
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          );
        });
  }

  void showRandomData(BuildContext context, String data) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("随机产生9个频率值："),
            content: Text(data),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("关闭"),
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    this.initState();
    return DivCustom(
        margin: [50, 10, 10, 10],
        child: Scaffold(
            body: Column(
          children: [
            Row(
              children: [
                SizedBox(height: 20),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initReadData();
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("读取信息"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initHeartBeat();
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("心跳一次"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.enterSound();
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("进入Sound页面"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.exitSound();
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("离开Sound页面"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x14;
                    dp.data[1] = 0x00;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("音量上键按下"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x14;
                    dp.data[1] = 0x01;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("长按"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x14;
                    dp.data[1] = 0x02;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("松开"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x15;
                    dp.data[1] = 0x00;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("音量下键按下"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x15;
                    dp.data[1] = 0x01;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("长按"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initVolumnControlData();
                    dp.data[0] = 0x15;
                    dp.data[1] = 0x02;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("松开"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initChannelControlData();
                    dp.data[0] = 0x12;
                    dp.data[1] = 0x00;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("Channel上键按下"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initChannelControlData();
                    dp.data[0] = 0x12;
                    dp.data[1] = 0x01;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("长按"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initChannelControlData();
                    dp.data[0] = 0x12;
                    dp.data[1] = 0x02;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("松开"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initChannelControlData();
                    dp.data[0] = 0x13;
                    dp.data[1] = 0x00;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("Channel下键按下"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initChannelControlData();
                    dp.data[0] = 0x13;
                    dp.data[1] = 0x01;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("长按"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initChannelControlData();
                    dp.data[0] = 0x13;
                    dp.data[1] = 0x02;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("松开"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initModeControlData();
                    dp.data[0] = 0x0A;
                    dp.data[1] = 0x00;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("Mode键按下"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initModeControlData();
                    dp.data[0] = 0x0A;
                    dp.data[1] = 0x02;
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("松开"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initBassControlData(this.bass);
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("设置Bass"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                NumberControllerWidget(
                  updateValueChanged: (value) {
                    this.bass = value;
                  },
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initTrebleControlData(this.treble);
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("设置Treble"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                NumberControllerWidget(
                  updateValueChanged: (value) {
                    this.treble = value;
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text("Fader:"),
                NumberControllerWidget(
                  updateValueChanged: (value) {
                    this.fader = value;
                  },
                ),
                SizedBox(width: 10),
                Text("Balance:"),
                NumberControllerWidget(
                  updateValueChanged: (value) {
                    this.balance = value;
                  },
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp =
                        DataPack.initFaderBalanceData(this.fader, this.balance);
                    showData(context, dp.toString());
                    //_conn.output.add(dp.toByteArray());
                    RFCommChannel.requestChannel(dp);
                  },
                  child: new Text("设置Fader和Balance"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    print("ddsd");
                    DataPack dp = DataPack.initEQData(this.eq);
                    showData(context, dp.toString());
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("设置预置EQ"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                NumberControllerWidget(
                  updateValueChanged: (value) {
                    this.eq = value;
                  },
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initTuneCustomData();
                    List<int> freqs = List.filled(9, 0);
                    String s = "随机产生9个频率值：\n";
                    for (int i = 0; i < 9; i++) {
                      freqs[i] = Random().nextInt(25);
                      dp.data[i] = freqs[i];
                      s += freqs[i].toString() + ",";
                    }
                    s += "\n";
                    s += "发送数据包：\n";
                    s += dp.toString();
                    showData(context, s);
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("设置Custom频率"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initSaveCustomData(0);
                    List<int> freqs = List.filled(9, 0);
                    String s = "随机产生9个频率值：\n";
                    for (int i = 0; i < 9; i++) {
                      freqs[i] = Random().nextInt(25);
                      dp.data[i + 1] = freqs[i];
                      s += freqs[i].toString() + ",";
                    }
                    s += "\n";
                    s += "发送数据包：\n";
                    s += dp.toString();
                    showData(context, s);
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("保存Custom1频率"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(width: 10),
                MaterialButton(
                  onPressed: () {
                    DataPack dp = DataPack.initSaveCustomData(1);
                    List<int> freqs = List.filled(9, 0);
                    String s = "随机产生9个频率值：\n";
                    for (int i = 0; i < 9; i++) {
                      freqs[i] = Random().nextInt(25);
                      dp.data[i + 1] = freqs[i];
                      s += freqs[i].toString() + ",";
                    }
                    s += "\n";
                    s += "发送数据包：\n";
                    s += dp.toString();
                    showData(context, s);
                    _conn.output.add(dp.toByteArray());
                  },
                  child: new Text("保存Custom2频率"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            ),
          ],
        )));
  }
}
