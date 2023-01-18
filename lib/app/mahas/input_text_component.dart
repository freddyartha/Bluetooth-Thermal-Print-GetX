import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'helper.dart';
import 'input_box_component.dart';
import 'my_config.dart';

enum InputTextType { text, email, password, number, paragraf, money }

class InputTextController extends ChangeNotifier {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _con = TextEditingController();
  late Function(VoidCallback fn) setState;

  bool _required = false;
  InputTextType _type = InputTextType.text;
  double? _moneyValue;
  bool _showPassword = false;

  VoidCallback? onEditingComplete;
  ValueChanged<String>? onChanged;
  GestureTapCallback? onTap;
  ValueChanged<String>? onFieldSubmitted;
  FormFieldSetter<String>? onSaved;

  String? _validator(String? v, {FormFieldValidator<String>? otherValidator}) {
    if (_required && (v?.isEmpty ?? false)) {
      return 'The field is required';
    }
    if (_type == InputTextType.email) {
      final pattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$";
      final regex = RegExp(pattern);
      if ((v?.isEmpty ?? false) || !regex.hasMatch(v!)) {
        return 'Enter a valid email address';
      } else {
        return null;
      }
    }
    if (otherValidator != null) {
      return otherValidator(v);
    }
    return null;
  }

  void _onFocusChange(bool? stateFocus) {
    if (stateFocus ?? false) {
      _con.text = _moneyValue == 0 ? "" : "${_moneyValue ?? ""}";
    } else {
      _moneyValue = double.tryParse(_con.text);
      _con.text = Helper.currencyFormat(_moneyValue ?? 0);
    }
  }

  void _init(Function(VoidCallback fn) setStateX) {
    setState = setStateX;
  }

  bool get isValid {
    bool? valid = _key.currentState?.validate();
    if (valid == null) {
      return true;
    }
    return valid;
  }

  dynamic get value {
    if (_type == InputTextType.number) {
      return num.tryParse(_con.text);
    } else if (_type == InputTextType.money) {
      return _moneyValue;
    } else {
      return _con.text;
    }
  }

  set value(dynamic value) {
    if (_type == InputTextType.money) {
      _con.text = value == null ? "" : Helper.currencyFormat(value ?? 0);
      _moneyValue = value;
    } else {
      _con.text = value == null ? "" : "$value";
    }
  }

  @override
  void dispose() {
    _con.dispose();
    super.dispose();
  }
}

class InputTextComponent extends StatefulWidget {
  final InputTextController controller;
  final bool required;
  final String? label;
  final bool editable;
  final InputTextType type;
  final String? placeHolder;
  final double? marginBottom;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final String? prefixText;
  final Radius? borderRadius;
  final bool? visibility;

  const InputTextComponent({
    Key? key,
    required this.controller,
    this.required = false,
    this.label,
    this.editable = true,
    this.type = InputTextType.text,
    this.placeHolder,
    this.marginBottom,
    this.inputFormatters,
    this.validator,
    this.prefixText,
    this.borderRadius,
    this.visibility = true,
  }) : super(key: key);

  @override
  State<InputTextComponent> createState() => _InputTextComponentState();
}

class _InputTextComponentState extends State<InputTextComponent> {
  @override
  void initState() {
    widget.controller._init(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller._required = widget.required;
    widget.controller._type = widget.type;

    final decoration = InputDecoration(
      filled: true,
      fillColor: MyConfig.fontColor.withOpacity(widget.editable ? .01 : .05),
      hintText: widget.placeHolder,
      isDense: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MyConfig.fontColor.withOpacity(.1)),
        borderRadius:
            BorderRadius.all(widget.borderRadius ?? Radius.circular(4.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MyConfig.fontColor.withOpacity(.1)),
        borderRadius:
            BorderRadius.all(widget.borderRadius ?? Radius.circular(4.0)),
      ),
      prefixText: widget.prefixText,
      prefixStyle: TextStyle(
        color: MyConfig.fontColor.withOpacity(0.6),
      ),
      suffixIconConstraints: BoxConstraints(
        minHeight: 30,
        minWidth: 30,
      ),
      suffixIcon: widget.type == InputTextType.password
          ? InkWell(
              splashColor: Colors.transparent,
              onTap: () => setState(() {
                widget.controller._showPassword =
                    !widget.controller._showPassword;
              }),
              child: Icon(
                widget.controller._showPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: MyConfig.fontColor.withOpacity(0.6),
                size: 14,
              ),
            )
          : null,
    );

    var textFormField = TextFormField(
      maxLines: widget.type == InputTextType.paragraf ? 4 : 1,
      onChanged: widget.controller.onChanged,
      onSaved: widget.controller.onSaved,
      onTap: widget.controller.onTap,
      onFieldSubmitted: widget.controller.onFieldSubmitted,
      style: TextStyle(
        color: MyConfig.fontColor,
        fontSize: MyConfigTextSize.normal,
      ),
      inputFormatters: (widget.type == InputTextType.number ||
              widget.type == InputTextType.money)
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,10}')),
              ...(widget.inputFormatters ?? []),
            ]
          : null,
      controller: widget.controller._con,
      validator: (v) =>
          widget.controller._validator(v, otherValidator: widget.validator),
      autocorrect: false,
      enableSuggestions: false,
      readOnly: !widget.editable,
      obscureText: widget.type == InputTextType.password
          ? !widget.controller._showPassword
          : false,
      onEditingComplete: widget.controller.onEditingComplete,
      keyboardType: (widget.type == InputTextType.number ||
              widget.type == InputTextType.money)
          ? TextInputType.number
          : null,
      decoration: decoration,
    );

    return Visibility(
      visible: widget.visibility!,
      child: InputBoxComponent(
        label: widget.label,
        marginBottom: widget.marginBottom,
        childText: widget.controller._con.text,
        isRequired: widget.required,
        children: Form(
          key: widget.controller._key,
          child: widget.type == InputTextType.money
              ? Focus(
                  child: textFormField,
                  onFocusChange: widget.controller._onFocusChange,
                )
              : textFormField,
        ),
      ),
    );
  }
}


// enum InputTextType { text, email, password, number, paragraf, money }

// class InputTextController extends ChangeNotifier {
//   final GlobalKey<FormState> _key = GlobalKey<FormState>();
//   final TextEditingController _con = TextEditingController();
//   late Function(VoidCallback fn) setState;

//   bool _required = false;
//   InputTextType _type = InputTextType.text;
//   double? _moneyValue;
//   bool _showPassword = false;

//   VoidCallback? onEditingComplete;
//   ValueChanged<String>? onChanged;
//   GestureTapCallback? onTap;
//   ValueChanged<String>? onFieldSubmitted;
//   FormFieldSetter<String>? onSaved;

//   String? _validator(String? v, {FormFieldValidator<String>? otherValidator}) {
//     if (_required && (v?.isEmpty ?? false)) {
//       return 'The field is required';
//     }
//     if (_type == InputTextType.email) {
//       final pattern =
//           r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//           r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//           r"{0,253}[a-zA-Z0-9])?)*$";
//       final regex = RegExp(pattern);
//       if ((v?.isEmpty ?? false) || !regex.hasMatch(v!)) {
//         return 'Enter a valid email address';
//       } else {
//         return null;
//       }
//     }
//     if (otherValidator != null) {
//       return otherValidator(v);
//     }
//     return null;
//   }

//   void _onFocusChange(bool? stateFocus) {
//     if (stateFocus ?? false) {
//       _con.text = _moneyValue == 0 ? "" : "${_moneyValue ?? ""}";
//     } else {
//       _moneyValue = double.tryParse(_con.text);
//       _con.text = Helper.currencyFormat(_moneyValue ?? 0);
//     }
//   }

//   void _init(Function(VoidCallback fn) setStateX) {
//     setState = setStateX;
//   }

//   bool get isValid {
//     bool? valid = _key.currentState?.validate();
//     if (valid == null) {
//       return true;
//     }
//     return valid;
//   }

//   dynamic get value {
//     if (_type == InputTextType.number) {
//       return num.tryParse(_con.text);
//     } else if (_type == InputTextType.money) {
//       return _moneyValue;
//     } else {
//       return _con.text;
//     }
//   }

//   set value(dynamic value) {
//     if (_type == InputTextType.money) {
//       _con.text = value == null ? "" : Helper.currencyFormat(value ?? 0);
//       _moneyValue = value;
//     } else {
//       _con.text = value == null ? "" : "$value";
//     }
//   }

//   @override
//   void dispose() {
//     _con.dispose();
//     super.dispose();
//   }
// }

// class InputTextComponent extends StatefulWidget {
//   final InputTextController controller;
//   final bool required;
//   final String? label;
//   final bool editable;
//   final InputTextType type;
//   final String? placeHolder;
//   final double? marginBottom;
//   final List<TextInputFormatter>? inputFormatters;
//   final FormFieldValidator<String>? validator;
//   final String? prefixText;
//   final Radius? borderRadius;
//   final bool? visibility;

//   const InputTextComponent({
//     Key? key,
//     required this.controller,
//     this.required = false,
//     this.label,
//     this.editable = true,
//     this.type = InputTextType.text,
//     this.placeHolder,
//     this.marginBottom,
//     this.inputFormatters,
//     this.validator,
//     this.prefixText,
//     this.borderRadius,
//     this.visibility = true,
//   }) : super(key: key);

//   @override
//   State<InputTextComponent> createState() => _InputTextComponentState();
// }

// class _InputTextComponentState extends State<InputTextComponent> {
//   @override
//   void initState() {
//     widget.controller._init(setState);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     widget.controller._required = widget.required;
//     widget.controller._type = widget.type;

//     final decoration = InputDecoration(
//       filled: true,
//       fillColor: MyConfig.fontColor.withOpacity(widget.editable ? .01 : .05),
//       hintText: widget.placeHolder,
//       isDense: true,
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: MyConfig.fontColor.withOpacity(.1)),
//         borderRadius:
//             BorderRadius.all(widget.borderRadius ?? Radius.circular(4.0)),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: MyConfig.fontColor.withOpacity(.1)),
//         borderRadius:
//             BorderRadius.all(widget.borderRadius ?? Radius.circular(4.0)),
//       ),
//       prefixText: widget.prefixText,
//       prefixStyle: TextStyle(
//         color: MyConfig.fontColor.withOpacity(0.6),
//       ),
//       suffixIconConstraints: BoxConstraints(
//         minHeight: 30,
//         minWidth: 30,
//       ),
//       suffixIcon: widget.type == InputTextType.password
//           ? InkWell(
//               splashColor: Colors.transparent,
//               onTap: () => setState(() {
//                 widget.controller._showPassword =
//                     !widget.controller._showPassword;
//               }),
//               child: Icon(
//                 widget.controller._showPassword
//                     ? Icons.visibility_off
//                     : Icons.visibility,
//                 color: MyConfig.fontColor.withOpacity(0.6),
//                 size: 14,
//               ),
//             )
//           : null,
//     );

//     var textFormField = TextFormField(
//       maxLines: widget.type == InputTextType.paragraf ? 4 : 1,
//       onChanged: widget.controller.onChanged,
//       onSaved: widget.controller.onSaved,
//       onTap: widget.controller.onTap,
//       onFieldSubmitted: widget.controller.onFieldSubmitted,
//       style: TextStyle(
//         color: MyConfig.fontColor,
//         fontSize: MyConfigTextSize.normal,
//       ),
//       inputFormatters: (widget.type == InputTextType.number ||
//               widget.type == InputTextType.money)
//           ? [
//               FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,10}')),
//               ...(widget.inputFormatters ?? []),
//             ]
//           : null,
//       controller: widget.controller._con,
//       validator: (v) =>
//           widget.controller._validator(v, otherValidator: widget.validator),
//       autocorrect: false,
//       enableSuggestions: false,
//       readOnly: !widget.editable,
//       obscureText: widget.type == InputTextType.password
//           ? !widget.controller._showPassword
//           : false,
//       onEditingComplete: widget.controller.onEditingComplete,
//       keyboardType: (widget.type == InputTextType.number ||
//               widget.type == InputTextType.money)
//           ? TextInputType.number
//           : null,
//       decoration: decoration,
//     );

//     return Visibility(
//       visible: widget.visibility!,
//       child: InputBoxComponent(
//         label: widget.label,
//         marginBottom: widget.marginBottom,
//         childText: widget.controller._con.text,
//         isRequired: widget.required,
//         children: Form(
//           key: widget.controller._key,
//           child: widget.type == InputTextType.money
//               ? Focus(
//                   child: textFormField,
//                   onFocusChange: widget.controller._onFocusChange,
//                 )
//               : textFormField,
//         ),
//       ),
//     );
//   }
// }
