import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/PlatformType.dart';
import 'package:roquiz/model/Themes.dart';

class SearchBarWidget extends StatefulWidget {
  ///  width - double ,isRequired : Yes
  ///  textController - TextEditingController  ,isRequired : Yes
  ///  onSuffixTap - Function, isRequired : Yes
  ///  onSubmitted - Function, isRequired : Yes
  ///  rtl - Boolean, isRequired : No
  ///  autoFocus - Boolean, isRequired : No
  ///  style - TextStyle, isRequired : No
  ///  closeSearchOnSuffixTap - bool , isRequired : No
  ///  suffixIcon - Icon ,isRequired :  No
  ///  prefixIcon - Icon  ,isRequired : No
  ///  animationDurationInMilli -  int ,isRequired : No
  ///  helpText - String ,isRequired :  No
  ///  inputFormatters - TextInputFormatter, Required - No
  ///  boxShadow - bool ,isRequired : No
  ///  textFieldColor - Color ,isRequired : No
  ///  searchIconColor - Color ,isRequired : No
  ///  textFieldIconColor - Color ,isRequired : No

  final double width;
  final TextEditingController textController;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final String helpText;
  final int animationDurationInMilli;
  final bool rtl;
  final bool autoFocus;
  final TextStyle? style;
  final bool closeSearchOnSuffixTap;
  final Color? color;
  final Color? searchIconColor;
  final Color? textFieldBackgroundLightColor;
  final Color? textFieldBackgroundDarkColor;
  final Color? textFieldTextLightColor;
  final Color? textFieldTextDarkColor;
  final Color? textFieldIconColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool boxShadow;
  final Function(String) onSearch;
  final Function()? onClear;
  final Function()? onClose;
  final Function()? onOpen;

  const SearchBarWidget({
    Key? key,

    /// The width cannot be null
    required this.width,

    /// The textController cannot be null
    required this.textController,
    this.suffixIcon,
    this.prefixIcon,
    this.helpText = "Search...",

    /// choose your custom color
    this.color = Colors.white,

    /// choose your custom color for the search when it is expanded
    this.textFieldBackgroundLightColor = Colors.white,
    this.textFieldBackgroundDarkColor = Colors.black,

    /// choose your custom color for the text when it is expanded
    this.textFieldTextLightColor = Colors.black,
    this.textFieldTextDarkColor = Colors.white,

    /// choose your custom color for the search when it is expanded
    this.searchIconColor = Colors.black,

    /// choose your custom color for the search when it is expanded
    this.textFieldIconColor = Colors.black,

    /// The onSuffixTap cannot be null
    this.animationDurationInMilli = 375,

    /// make the search bar to open from right to left
    this.rtl = false,

    /// make the keyboard to show automatically when the searchbar is expanded
    this.autoFocus = false,

    /// TextStyle of the contents inside the searchbar
    this.style,

    /// close the search on suffix tap
    this.closeSearchOnSuffixTap = false,

    /// enable/disable the box shadow decoration
    this.boxShadow = true,

    /// can add list of inputformatters to control the input
    this.inputFormatters,

    /// Is called when the user clicks on the search icon and opens the search bar
    this.onOpen,

    /// Is called when the user submit the search string
    required this.onSearch,

    /// Is called when the user clears the search string
    this.onClear,

    /// Is called when the user closes the search bar (either with the close button or by clearing when the search bar is already empty)
    this.onClose,
  }) : super(key: key);

  @override
  SearchBarWidgetState createState() => SearchBarWidgetState();
}

///toggle - 0 => false or closed
///toggle 1 => true or open
bool isOpen = false;

/// * use this variable to check current text from OnChange
String textFieldValue = '';

class SearchBarWidgetState extends State<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  ///initializing the AnimationController
  late AnimationController _con;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    ///Initializing the animationController which is responsible for the expanding and shrinking of the search bar
    _con = AnimationController(
      vsync: this,

      /// animationDurationInMilli is optional, the default value is 375
      duration: Duration(milliseconds: widget.animationDurationInMilli),
    );
  }

  unfocusKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    _con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      height: 100.0,

      ///if the rtl is true, search bar will be from right to left
      alignment:
          widget.rtl ? Alignment.centerRight : const Alignment(-1.0, 0.0),

      ///Using Animated container to expand and shrink the widget
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.animationDurationInMilli),
        height: 48.0,
        width: !isOpen ? 48.0 : widget.width,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          /// can add custom  color or the color will be white
          color: !isOpen
              ? widget.color
              : (themeProvider.isDarkMode
                  ? widget.textFieldBackgroundDarkColor
                  : widget.textFieldBackgroundLightColor),
          borderRadius: BorderRadius.circular(30.0),

          /// show boxShadow unless false was passed
          boxShadow: !widget.boxShadow
              ? null
              : [
                  const BoxShadow(
                    color: Colors.black26,
                    spreadRadius: -10.0,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
        ),
        child: TapRegion(
          onTapOutside: (_) {
            if (isOpen) {
              if (widget.onClose != null) {
                widget.onClose!();
              }
              unfocusKeyboard();
              setState(() {
                isOpen = false;
              });
              _con.reverse();
            }
          },
          child: Stack(
            children: [
              ///Using Animated Positioned widget to expand and shrink the widget
              AnimatedPositioned(
                duration:
                    Duration(milliseconds: widget.animationDurationInMilli),
                top: 6.0,
                right: 7.0,
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: !isOpen ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      /// can add custom color or the color will be white
                      color: widget.color,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: AnimatedBuilder(
                      builder: (context, widget) {
                        ///Using Transform.rotate to rotate the suffix icon when it gets expanded
                        return Transform.rotate(
                          angle: _con.value * 2.0 * pi,
                          child: widget,
                        );
                      },
                      animation: _con,
                      child: GestureDetector(
                        onTap: () {
                          try {
                            ///trying to execute the onSuffixTap function
                            if (widget.onClear != null) {
                              widget.onClear!();
                            }

                            // * if field empty then the user trying to close bar
                            if (textFieldValue == '') {
                              unfocusKeyboard();
                              setState(() {
                                isOpen = false;

                                if (widget.onClose != null) {
                                  widget.onClose!();
                                }
                              });

                              ///reverse == close
                              _con.reverse();
                            }

                            // * why not clear textfield here?
                            widget.textController.clear();
                            textFieldValue = '';

                            ///closeSearchOnSuffixTap will execute if it's true
                            if (widget.closeSearchOnSuffixTap) {
                              unfocusKeyboard();
                              setState(() {
                                isOpen = false;
                              });
                            }
                          } catch (e) {
                            ///print the error if the try block fails
                            print(e);
                          }
                        },

                        ///suffixIcon is of type Icon
                        child: widget.suffixIcon ??
                            Icon(
                              Icons.close,
                              size: 20.0,
                              color: widget.textFieldIconColor,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration:
                    Duration(milliseconds: widget.animationDurationInMilli),
                left: !isOpen ? 20.0 : 40.0,
                curve: Curves.easeOut,
                top: 11.0,

                ///Using Animated opacity to change the opacity of th textField while expanding
                child: AnimatedOpacity(
                  opacity: !isOpen ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.topCenter,
                    width: widget.width / 1.7,
                    child: TextField(
                      ///Text Controller. you can manipulate the text inside this textField by calling this controller.
                      controller: widget.textController,
                      inputFormatters: widget.inputFormatters,
                      focusNode: focusNode,
                      cursorRadius: const Radius.circular(10.0),
                      cursorWidth: 2.0,
                      onChanged: (value) {
                        textFieldValue = value;
                      },
                      onSubmitted: (value) {
                        widget.onSearch(value);
                        if (widget.onClose != null) {
                          widget.onClose!();
                        }
                        unfocusKeyboard();
                        setState(() {
                          isOpen = false;
                        });
                      },
                      onEditingComplete: () {
                        /// on editing complete the keyboard will be closed and the search bar will be closed
                        unfocusKeyboard();
                        setState(() {
                          isOpen = false;
                        });
                      },

                      ///style is of type TextStyle, the default is just a color black
                      style: widget.style ??
                          TextStyle(
                              color: themeProvider.isDarkMode
                                  ? widget.textFieldTextDarkColor
                                  : widget.textFieldTextLightColor),
                      cursorColor: themeProvider.isDarkMode
                          ? widget.textFieldTextDarkColor
                          : widget.textFieldTextLightColor,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5.0),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: widget.helpText,
                        labelStyle: const TextStyle(
                          color: Color(0xff5B5B5B),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              ///Using material widget here to get the ripple effect on the prefix icon
              Positioned(
                // Workaround
                top: getPlatformType() == PlatformType.MOBILE ? 0.0 : 4.0,
                left: getPlatformType() == PlatformType.MOBILE ? 0.0 : 4.0,
                child: Material(
                  /// can add custom color or the color will be white
                  /// toggle button color based on toggle state
                  color: !isOpen
                      ? widget.color
                      : (themeProvider.isDarkMode
                          ? widget.textFieldBackgroundDarkColor
                          : widget.textFieldBackgroundLightColor),
                  borderRadius: BorderRadius.circular(30.0),
                  child: IconButton(
                    splashRadius: 19.0,
                    hoverColor: Colors.transparent,

                    ///if toggle is 1, which means it's open. so show the back icon, which will close it.
                    ///if the toggle is 0, which means it's closed, so tapping on it will expand the widget.
                    ///prefixIcon is of type Icon
                    icon: Icon(
                      Icons.search,
                      color: isOpen ? Colors.grey : widget.searchIconColor,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          if (!isOpen) {
                            isOpen = true;

                            if (widget.onOpen != null) {
                              widget.onOpen!();
                            }

                            ///if the autoFocus is true, the keyboard will pop open, automatically
                            if (widget.autoFocus) {
                              FocusScope.of(context).requestFocus(focusNode);
                            }

                            // expand
                            _con.forward();
                          } else {
                            isOpen = false;

                            widget.onSearch(widget.textController.text);
                            if (widget.onClose != null) {
                              widget.onClose!();
                            }

                            ///if the autoFocus is true, the keyboard will close, automatically
                            if (widget.autoFocus) unfocusKeyboard();

                            // shrink
                            _con.reverse();
                          }
                        },
                      );
                    },
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
