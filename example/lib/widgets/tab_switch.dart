import 'package:flutter/material.dart';

class TabSwitch<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final tabs = values
        ?.map((e) => GestureDetector(
              onTap: () => onChanged?.call(e),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                color: e == value ? Colors.blue : Colors.grey[300],
                child: Text('$e'.split('.').last),
              ),
            ))
        .toList();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: tabs ?? [],
    );
  }
}
