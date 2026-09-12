import 'package:flutter/material.dart';

/// Tristate "select all" checkbox shown in the app bar of multi-selection
/// screens. [value] follows [SelectionController.allSelected] semantics
/// (`true` = all, `false` = none, `null` = some); [onChanged] is fired on tap
/// and is expected to toggle between all and none. A `null` [onChanged]
/// disables the checkbox.
class SelectAllCheckbox extends StatelessWidget {
  const SelectAllCheckbox({super.key, required this.value, this.onChanged});

  final bool? value;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: Checkbox(
        side: WidgetStateBorderSide.resolveWith((states) {
          return BorderSide(
            color: states.contains(WidgetState.selected)
                ? Colors.blue
                : Colors.white,
          );
        }),
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? Colors.blue
              : Colors.transparent;
        }),
        checkColor: Colors.white,
        tristate: true,
        value: value,
        onChanged: onChanged == null ? null : (_) => onChanged!(),
      ),
    );
  }
}
