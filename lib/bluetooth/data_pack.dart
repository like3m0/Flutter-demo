import 'dart:typed_data';

import 'package:flutter/services.dart';

class DataPack {
  var dataHead = <int>[0, 0];
  var commandId = 0;
  var bufferLen = 0;
  var data = null;

  Uint8List toByteArray() {
    var dataLen = 3 + this.bufferLen;
    ByteData byteData = new ByteData(dataLen);
    byteData.setUint8(0, dataHead[0]);
    byteData.setUint8(1, dataHead[1]);
    byteData.setUint8(2, bufferLen);
    if (bufferLen > 0) byteData.setUint8(3, commandId);
    if (data != null) {
      for (var i = 0; i < data.length; i++) {
        byteData.setUint8(4 + i, data[i]);
      }
    }
    return byteData.buffer.asUint8List();
  }

  static DataPack fromIntList(List<int> originData) {
    DataPack dp = new DataPack();
    dp.dataHead[0] = originData[0];
    dp.dataHead[1] = originData[1];
    dp.bufferLen = originData[2];
    if (dp.bufferLen > 0) {
      dp.commandId = originData[3];
    }
    if (dp.bufferLen > 1) {
      dp.data = List<int>.filled(dp.bufferLen - 1, 0);
      for (int i = 0; i < dp.bufferLen - 1; i++) {
        dp.data[i] = originData[4 + i];
      }
    }
    return dp;
  }

  static DataPack initVolumnControlData() {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x03;
    p.commandId = 0x10;
    p.data = List<int>.filled(2, 0);
    return p;
  }

  static DataPack initChannelControlData() {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x03;
    p.commandId = 0x10;
    p.data = List<int>.filled(2, 0);
    return p;
  }

  static DataPack initModeControlData() {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x03;
    p.commandId = 0x10;
    p.data = List<int>.filled(2, 0);
    p.data[0] = 0x0A;
    return p;
  }

  static DataPack initBassControlData(int i) {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x02;
    p.commandId = 0x20;
    p.data = List<int>.filled(1, 0);
    p.data[0] = i;
    return p;
  }

  static DataPack initTrebleControlData(int i) {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x02;
    p.commandId = 0x21;
    p.data = List<int>.filled(1, 0);
    p.data[0] = i;
    return p;
  }

  static DataPack initFaderBalanceData(int f, int b) {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x03;
    p.commandId = 0x22;
    p.data = List<int>.filled(2, 0);
    p.data[0] = f;
    p.data[1] = b;
    return p;
  }

  static DataPack initEQData(int eq) {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x02;
    p.commandId = 0x23;
    p.data = List<int>.filled(1, 0);
    p.data[0] = eq;
    return p;
  }

  static DataPack initSaveCustomData(int custom) {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x0B;
    p.commandId = 0x24;
    p.data = List<int>.filled(10, 0);
    p.data[0] = custom;
    return p;
  }

  static DataPack initTuneCustomData() {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x0A;
    p.commandId = 0x25;
    p.data = List<int>.filled(9, 0);
    return p;
  }

  static DataPack initReadData() {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x01;
    p.commandId = 0x26;
    p.data = null;
    return p;
  }

  static DataPack initHeartBeat() {
    DataPack p = new DataPack();
    p.dataHead = dataHead_new;
    p.bufferLen = 0x00;
    p.commandId = 0x00;
    p.data = null;
    return p;
  }

  static DataPack enterSound() {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x02;
    p.commandId = 0x27;
    p.data = [0x00];
    return p;
  }

  static DataPack exitSound() {
    DataPack p = new DataPack();
    p.dataHead = dataHead_old;
    p.bufferLen = 0x02;
    p.commandId = 0x27;
    p.data = [0x01];
    return p;
  }

  @override
  String toString() {
    String s = int2HexString(dataHead[0]) + int2HexString(dataHead[1]);
    s += int2HexString(bufferLen);
    if (bufferLen > 0) s += int2HexString(commandId);
    if (bufferLen > 1)
      for (int i = 0; i < bufferLen - 1; i++) s += int2HexString(data[i]);
    print(s);
    return s;
  }

  String int2HexString(int i) {
    if (i > 16)
      return "0x" + i.toRadixString(16) + " ";
    else
      return "0x0" + i.toRadixString(16) + " ";
  }
}

const dataHead_old = [0x86, 0x72];
const dataHead_new = [0x86, 0x73];
