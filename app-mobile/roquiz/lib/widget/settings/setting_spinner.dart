import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roquiz/model/constants.dart';

class SettingSpinnerWidget extends StatefulWidget {
  final String label;
  final String description;
  final bool defaultValue;
  final ValueChanged<bool> onChanged;

  const SettingSpinnerWidget({
    required this.label,
    required this.description,
    this.defaultValue = false,
    required this.onChanged,
    super.key,
  });

  @override
  SettingSpinnerWidgetState createState() => SettingSpinnerWidgetState();
}

class SettingSpinnerWidgetState extends State<SettingSpinnerWidget> {
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
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.remove),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),

              // IconButtonLongPressWidget(
              //       onUpdate: _canDecreaseQuestionNumber(1)
              //           ? () {
              //               _updateQuestionNumber(_questionNumber - 1);
              //             }
              //           : null,
              //       lightPalette: MyThemes.lightIconButtonPalette,
              //       darkPalette: MyThemes.darkIconButtonPalette,
              //       width: 40.0,
              //       height: 40.0,
              //       icon: Icons.remove,
              //       iconSize: 35,
              //     ),
              // POOL SIZE COUNTER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  alignment: Alignment.center,
                  width: 40.0,
                  child: TextField(
                    key: UniqueKey(),
                    // enabled: !_maxQuestionPerTopic,
                    // controller: _questionNumberController,
                    // onEditingComplete: () {
                    //   _updateQuestionNumber(
                    //       int.tryParse(_questionNumberController.text) ??
                    //           _questionNumber);
                    // },
                    // onSubmitted: (value) {
                    //   _updateQuestionNumber(
                    //       int.tryParse(value) ?? _questionNumber);
                    // },
                    // onTapOutside: (_) {
                    //   _updateQuestionNumber(
                    //       int.tryParse(_questionNumberController.text) ??
                    //           _questionNumber);
                    // },
                    maxLength: 3,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: const TextInputType.numberWithOptions(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterStyle: TextStyle(
                          height: double.minPositive,
                        ),
                        counterText: ""),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              // INCREASE POOL SIZE (QUESTION NUMBER)
              // IconButtonLongPressWidget(
              //   onUpdate: _canIncreaseQuestionNumber(1)
              //       ? () {
              //           _updateQuestionNumber(_questionNumber + 1);
              //         }
              //       : null,
              //   lightPalette: MyThemes.lightIconButtonPalette,
              //   darkPalette: MyThemes.darkIconButtonPalette,
              //   width: 40.0,
              //   height: 40.0,
              //   icon: Icons.add,
              //   iconSize: 35,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
