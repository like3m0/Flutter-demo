import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';

/// 对象生成方法
typedef ObjGenerateFun<T> = T Function(Map<String, dynamic>);

/// 数据处理器
abstract class Processor<T> {
  Processor(this.isList, {this.objGenerateFun});

  bool isList;
  ObjGenerateFun<T> objGenerateFun;

  success(Response response) => response; // 成功数据处理

  failed(DioError err) => err; // 失败数据处理
}

/// 定义 普通数据格式
class BaseResp<T> {
  int status;
  int code;
  String msg;
  T data;

  BaseResp(this.status, this.code, this.msg, this.data);

  String toString() {
    return "{\"status\":\"${status}\",\"code\":${code},\"msg\":\"${msg}\",\"data\":\"${data}\"}";
  }
}

/// 定义 List数据格式
class BaseRespList<T> {
  int status;
  int code;
  String msg;
  List<T> data;

  BaseRespList(this.status, this.code, this.msg, this.data);

  @override
  String toString() {
    return "{\"status\":\"${status}\",\"code\":${code},\"msg\":\"${msg}\",\"data\":\"${data}\"}";
  }
}

/// 实现默认处理器
class BaseProcessor<T> extends Processor<T> {
  BaseProcessor(bool isList, {ObjGenerateFun<T> fun})
      : super(isList, objGenerateFun: fun);

  @override
  ObjGenerateFun<T> get objGenerateFun => super.objGenerateFun;

  // 转换json
  Map<String, dynamic> decodeData(Response response) {
    if (response == null ||
        response.data == null ||
        response.data.toString().isEmpty) {
      return new Map();
    }
    return json.decode(response.data.toString());
  }

  @override
  success(Response response) {
    int _status = response.statusCode;
    int _code = 0;
    String _msg = "";
    // List数据处理 [{...},{...}]
    if (isList) {
      List<T> _data = new List<T>();
      if (response.data is List) {
        _code = 200;
        _msg = '成功';
        if (T.toString() == 'dynamic') {
          _data = response.data;
        } else {
          if (response.data != null) {
            _data = (response.data as List)
                .map<T>((v) => objGenerateFun(v))
                .toList();
          }
        }
      }
      return BaseRespList(_status, _code, _msg, _data);
    } else {
      // 普通数据处理 {...}
      T _data = objGenerateFun({});
      if (response.data is Map) {
        _code = -1;
        _msg = '';
        if (T.toString() == 'dynamic') {
          _data = response.data;
        } else {
          _data = objGenerateFun(response.data);
        }
      }
      return BaseResp(_status, _code, _msg, _data);
    }
  }

  @override
  failed(DioError err) {
    return err;
  }
}
