import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiangyue/bluetooth/audio_status.dart';
import 'package:xiangyue/bluetooth/bluetooth_channel.dart';
import 'package:xiangyue/pages/test_interface.dart';
import 'package:xiangyue/utils/toast_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:app_settings/app_settings.dart';
import 'package:provider/provider.dart';

class BlueTestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BlueTestState();
  }
}

class _BlueTestState extends State<BlueTestPage> {
  String text = "";
  List<BluetoothDevice> deviceList = [];

  @override
  void initState() {
    super.initState();
    _refreshDeviceList();
  }

  void dispose() {
    super.dispose();
  }

  void _refreshDeviceList() async {
    this.deviceList = await FlutterBluetoothSerial.instance.getBondedDevices();
    this.setState(() {});
  }

  Widget _buildBody() {
    return Stack(
      children: [
        DivCustom(
          margin: [20, 10, 0, 0],
          child: ListView.builder(
            // scrollDirection: Axis.horizontal,//设置为水平布局
            itemBuilder: (BuildContext context, int index) {
              BluetoothDevice device = this.deviceList[index];
              var s = "name:${device.name},type:${device.type},";
              s += "address:${device.address},connect:${device.isConnected}";
              return Row(
                children: [
                  DivCustom(
                      width: 200,
                      height: 100,
                      margin: [0, 20, 0, 20],
                      child: Text(s)),
                  MaterialButton(
                    onPressed: () async {
                      try {
                        BluetoothConnection conn =
                            await BluetoothConnection.listen(
                                "00001101-0000-1000-8000-00805F9B34FB");
                        // await BluetoothConnection.toAddress(device.address);
                        if (conn != null) {
                          ToastUtil.toast("连接${device.name}成功");
                          this._refreshDeviceList();
                          // AudioStatus as = Provider.of<AudioStatus>(context);
                          AudioStatus as = new AudioStatus();
                          RFCommChannel.initChannel(conn, as);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TestInterface(conn)));
                        } else {
                          ToastUtil.toast("连接${device.name}失败");
                        }
                      } catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("异常："),
                                content: Text(e.toString()),
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
                        // ToastUtil.toast("连接${device.name}失败");
                      }
                    },
                    child: new Text("连接"),
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ],
              );
            },
            itemCount: this.deviceList.length,
          ),
        ),
        Positioned(
            left: 10,
            right: 10,
            bottom: 70,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: () {
                    print("tap button 1");
                    AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                  },
                  child: new Text("设置蓝牙"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                MaterialButton(
                  onPressed: () {
                    print("tap button 2");
                    _refreshDeviceList();
                  },
                  child: new Text("设备列表"),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                // MaterialButton(
                //   color: Colors.blue,
                //   textColor: Colors.white,
                //   child: new Text('连接'),
                //   onPressed: () {
                //     print("尝试连接设备。。。");
                //     BluetoothConnection conn = null;
                //     this.deviceList.forEach((device) async {
                //       conn =
                //           await BluetoothConnection.toAddress(device.address);
                //       if (conn == null) {
                //         print("连接${device.name}失败");
                //       } else {
                //         print("连接${device.name}成功");
                //       }
                //     });
                //   },
                // )
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: DivCustom(child: _buildBody()),
    );
  }
}
