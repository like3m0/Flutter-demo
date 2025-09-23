import 'package:flutter/material.dart';

class NumberControllerWidget extends StatefulWidget {
  /// 高度
  final double height;

  /// 输入框宽度（整体宽度自适应）
  final double width;

  /// 加减按钮宽度
  final double iconWidth;

  /// 默认显示的数量（字符串形式，内部会 tryParse）
  final String numText;

  /// 点击加号回调（当前数量）
  final ValueChanged<int>? addValueChanged;

  /// 点击减号回调（当前数量）
  final ValueChanged<int>? removeValueChanged;

  /// 每次数量变化后的统一回调（当前数量）
  final ValueChanged<int>? updateValueChanged;

  const NumberControllerWidget({
    super.key,
    this.height = 30,
    this.width = 40,
    this.iconWidth = 40,
    this.numText = '0',
    this.addValueChanged,
    this.removeValueChanged,
    this.updateValueChanged,
  });

  @override
  State<NumberControllerWidget> createState() => _NumberControllerWidgetState();
}

class _NumberControllerWidgetState extends State<NumberControllerWidget> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.numText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  int _currentValue() => int.tryParse(_textController.text) ?? 0;

  void _setValue(int v) {
    if (v < 0) v = 0; // 不允许负数
    _textController.text = '$v';
    widget.updateValueChanged?.call(v);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(width: 1, color: Colors.black12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // 减号
              _customIconButton(icon: Icons.remove, isAdd: false),
              // 输入框
              Container(
                width: widget.width,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 1, color: Colors.black12),
                    right: BorderSide(width: 1, color: Colors.black12),
                  ),
                ),
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                  enableInteractiveSelection: false,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(left: 0, top: 2, bottom: 2, right: 0),
                    border: OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                  onChanged: (s) {
                    final v = int.tryParse(s) ?? 0;
                    _setValue(v);
                  },
                ),
              ),
              // 加号
              _customIconButton(icon: Icons.add, isAdd: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _customIconButton({required IconData icon, required bool isAdd}) {
    return SizedBox(
      width: widget.iconWidth,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 18),
        onPressed: () {
          var num = _currentValue();
          if (!isAdd && num == 0) return;

          if (isAdd) {
            num++;
            widget.addValueChanged?.call(num);
          } else {
            num--;
            if (num < 0) num = 0;
            widget.removeValueChanged?.call(num);
          }

          _setValue(num);
        },
      ),
    );
  }
}
