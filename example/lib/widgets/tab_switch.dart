import 'package:flutter/material.dart';

class TabSwitch<T> extends StatefulWidget {
  final List<T>? values;
  final T? value;
  final ValueChanged<T>? onChanged;

  const TabSwitch({
    Key? key,
    this.values,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  _TabSwitchState<T> createState() => _TabSwitchState<T>();
}

class _TabSwitchState<T> extends State<TabSwitch<T>> {
  @override
  Widget build(BuildContext context) {
    final tabs = widget.values
        ?.map((e) => GestureDetector(
              onTap: () => widget.onChanged?.call(e),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                color: e == widget.value ? Colors.blue : Colors.grey[300],
                child: Text('$e'.split('.').last),
              ),
            ))
        .toList();
    return Row(children: tabs ?? []);
  }
}
