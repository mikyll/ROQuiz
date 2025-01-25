import 'package:flutter/material.dart';
import 'package:roquiz/model/constants.dart';

class SettingCheckboxWidget extends StatefulWidget {
  final String label;
  final String description;
  final bool defaultValue;
  final ValueChanged<bool> onChanged;

  const SettingCheckboxWidget({
    required this.label,
    required this.description,
    this.defaultValue = false,
    required this.onChanged,
    super.key,
  });

  @override
  SettingCheckboxWidgetState createState() => SettingCheckboxWidgetState();
}

class SettingCheckboxWidgetState extends State<SettingCheckboxWidget> {
  bool _isChecked = false;

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });

    widget.onChanged(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: bottomPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // TODO: add tooltip
              Flexible(
                fit: FlexFit.tight,
                child: InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onDoubleTap: () {
                    _isChecked = widget.defaultValue;
                  },
                  child: Text(
                    widget.label,
                    maxLines: 3,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                width: 120.0,
                child: Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      semanticLabel: widget.label,
                      value: _isChecked,
                      onChanged: _toggleCheckbox,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
