import 'package:flutter/material.dart';
import 'package:roquiz/model/constants.dart';

class SettingCheckboxAndButtonWidget extends StatefulWidget {
  final String label;
  final String description;
  final bool defaultValue;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onClick;

  const SettingCheckboxAndButtonWidget({
    required this.label,
    required this.description,
    this.defaultValue = false,
    required this.onChanged,
    required this.onClick,
    super.key,
  });

  @override
  SettingCheckboxAndButtonWidgetState createState() =>
      SettingCheckboxAndButtonWidgetState();
}

class SettingCheckboxAndButtonWidgetState
    extends State<SettingCheckboxAndButtonWidget> {
  bool _isChecked = false;

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(_isChecked);
    }
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
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onClick,
                icon: Icon(Icons.sync_rounded),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
