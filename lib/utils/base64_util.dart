import 'dart:convert';

class Base64Util {
/*
  * Base64加密
  */
  static String encodeBase64(String data) {
    if (data == null) {
      return "";
    }
    var content = utf8.encode(data + "zybd");
    var digest = base64Encode(content);
    return digest;
  }

/*
  * Base64解密
  */
  static String decodeBase64(String data) {
    if (data == null) {
      return "";
    }
//    return String.fromCharCodes(base64Decode(data));
    List<int> bytes = base64Decode(data);
    // 网上找的很多都是String.fromCharCodes，这个中文会乱码
    //String txt1 = String.fromCharCodes(bytes);
    String result = utf8.decode(bytes);
    return result.substring(0, result.length - 4);
  }
}
