import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSearchBar extends StatefulWidget {
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

  final double openWidth;
  final TextEditingController textController;

  final IconData? searchIcon;
  final Color? searchIconColor;
  final Color? searchIconColorOpen;

  final IconData? closeIcon;
  final Color? closeIconColor;
  final String helpText;
  final int animationDuration;

  final bool rtl;
  final bool autoFocus;
  final bool closeSearchOnSuffixTap;
  final Color? fillColor;
  final Color? fillColorOpen;
  final Color? textFieldTextColor;
  final Color? textFieldIconColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool boxShadow;
  final Function(String) onSearch;
  final Function()? onClear;
  final Function()? onClose;
  final Function()? onOpen;

  const CustomSearchBar({
    super.key,
    this.openWidth = 300,
    required this.textController,
    this.searchIcon = Icons.search,

    /// choose your custom color for the search when it is expanded
    this.searchIconColor = Colors.white,
    this.searchIconColorOpen = Colors.black,

    this.closeIcon = Icons.close,
    this.closeIconColor = Colors.black,

    /// The textController cannot be null
    this.helpText = "Search...",

    /// choose your custom color
    this.fillColor = Colors.transparent,
    this.fillColorOpen = Colors.white,

    /// choose your custom color for the text when it is expanded
    this.textFieldTextColor = Colors.black,

    /// choose your custom color for the search when it is expanded
    this.textFieldIconColor = Colors.black,

    /// The onSuffixTap cannot be null
    this.animationDuration = 375,

    /// make the search bar to open from right to left
    this.rtl = false,

    /// make the keyboard to show automatically when the searchbar is expanded
    this.autoFocus = false,

    /// close the search on suffix tap
    this.closeSearchOnSuffixTap = false,

    /// enable/disable the box shadow decoration
    this.boxShadow = false,

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
  });

  @override
  CustomSearchBarState createState() => CustomSearchBarState();
}

///toggle - 0 => false or closed
///toggle 1 => true or open
bool isOpen = false;

/// * use this variable to check current text from OnChange
String textFieldValue = '';

class CustomSearchBarState extends State<CustomSearchBar>
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
      duration: Duration(milliseconds: widget.animationDuration),
    );
  }

  unfocusKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _openBar({bool forceFocus = false}) {
    setState(() {
      isOpen = true;

      if (widget.onOpen != null) {
        widget.onOpen!();
      }

      ///if the autoFocus is true, the keyboard will pop open, automatically
      if (widget.autoFocus || forceFocus) {
        FocusScope.of(context).requestFocus(focusNode);
      }

      // expand
      _con.forward();
    });
  }

  /// Opens the search bar programmatically (e.g. from a Ctrl+F shortcut) and
  /// focuses the text field. If it is already open, it just re-focuses it.
  void openSearch() {
    if (isOpen) {
      focusNode.requestFocus();
      return;
    }
    _openBar(forceFocus: true);
  }

  /// Closes (collapses) the search bar programmatically, e.g. from an Esc
  /// shortcut. Keeps the current text/results (same as tapping outside).
  /// No-op if already closed; returns whether it did anything.
  bool closeSearch() {
    if (!isOpen) {
      return false;
    }
    if (widget.onClose != null) {
      widget.onClose!();
    }
    unfocusKeyboard();
    setState(() {
      isOpen = false;
    });
    _con.reverse();
    return true;
  }

  @override
  void dispose() {
    _con.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: use custom theme

    return Container(
      height: 100.0,

      ///if the rtl is true, search bar will be from right to left
      alignment: widget.rtl
          ? Alignment.centerRight
          : const Alignment(-1.0, 0.0),

      ///Using Animated container to expand and shrink the widget
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.animationDuration),
        height: 48.0,
        width: !isOpen ? 48.0 : widget.openWidth,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          /// can add custom  color or the color will be white
          color: isOpen ? widget.fillColorOpen : widget.fillColor,
          // TODO: color: !isOpen ? widget.color : (searchBarTheme.backgroundColor),
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
            alignment: Alignment.center,
            children: [
              ///Using Animated Positioned widget to expand and shrink the widget
              AnimatedPositioned(
                duration: Duration(milliseconds: widget.animationDuration),
                right: 6.0,
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: isOpen ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      /// can add custom color or the color will be white
                      color: widget.fillColor,
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
                        child: Icon(
                          widget.closeIcon,
                          size: 20.0,
                          color: widget.closeIconColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: widget.animationDuration),
                left: !isOpen ? 20.0 : 40.0,
                curve: Curves.easeOut,
                top: 11.0,

                ///Using Animated opacity to change the opacity of th textField while expanding
                child: AnimatedOpacity(
                  opacity: isOpen ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.topCenter,
                    width: widget.openWidth / 1.7,
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
                        if (value.isEmpty) {
                          return;
                        }

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
                      style: TextStyle(color: widget.textFieldTextColor),
                      cursorColor: widget.textFieldTextColor,
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
                        focusedBorder: OutlineInputBorder(
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
                left: 6.0,
                child: IconButton(
                  splashRadius: 19.0,

                  ///if toggle is 1, which means it's open. so show the back icon, which will close it.
                  ///if the toggle is 0, which means it's closed, so tapping on it will expand the widget.
                  ///prefixIcon is of type Icon
                  icon: Icon(Icons.search),
                  style: ButtonStyle(
                    iconColor: WidgetStatePropertyAll(
                      isOpen
                          ? widget.searchIconColorOpen
                          : widget.searchIconColor,
                    ),
                    overlayColor: WidgetStatePropertyAll(Color(0x19ffffff)),
                    backgroundColor: WidgetStatePropertyAll(Color(0x00ffffff)),
                  ),

                  onPressed: () {
                    if (!isOpen) {
                      _openBar();
                    } else {
                      if (widget.textController.text.isEmpty) {
                        return;
                      }

                      setState(() {
                        isOpen = false;

                        widget.onSearch(widget.textController.text);
                        if (widget.onClose != null) {
                          widget.onClose!();
                        }

                        ///if the autoFocus is true, the keyboard will close, automatically
                        if (widget.autoFocus) unfocusKeyboard();

                        // shrink
                        _con.reverse();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
