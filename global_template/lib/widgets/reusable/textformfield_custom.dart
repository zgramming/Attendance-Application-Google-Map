import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:global_template/global_template.dart';

class TextFormFieldCustom extends StatelessWidget {
  const TextFormFieldCustom({
    this.controller,
    this.prefixIcon = const Icon(Icons.supervised_user_circle),
    this.suffixIcon,
    this.initialValue,
    this.minLines,
    this.maxLines,
    this.focusNode,
    this.borderColor,
    this.borderFocusColor,
    this.inputFormatter,
    this.onFieldSubmitted,
    this.onChanged,
    this.radius = 8,
    this.hintText,
    this.labelText,
    this.hintStyle,
    this.autoFocus = false,
    this.centerText = false,
    this.isDone = false,
    this.isPassword = false,
    this.disableOutlineBorder = true,
    this.isEnabled = true,
    this.isValidatorEnable = true,
    this.backgroundColor = Colors.white,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    @required this.onSaved,
  });
  final Widget prefixIcon;
  final Widget suffixIcon;

  final String hintText;
  final String labelText;
  final String initialValue;

  final bool isPassword;
  final bool isEnabled;
  final bool isDone;
  final bool centerText;
  final bool isValidatorEnable;
  final bool disableOutlineBorder;
  final bool autoFocus;

  final int minLines;
  final int maxLines;

  final double radius;

  final Color backgroundColor;
  final Color borderColor;
  final Color borderFocusColor;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  final FocusNode focusNode;

  final List<TextInputFormatter> inputFormatter;

  final TextEditingController controller;

  final TextStyle hintStyle;

  final Function(String) onFieldSubmitted;
  final Function(String) onChanged;
  final Function(String) onSaved;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          autofocus: autoFocus,
          controller: controller,
          textAlign: centerText ? TextAlign.center : TextAlign.left,
          obscureText:
              (isPassword && context.select((GlobalProvider provider) => provider.obsecurePassword))
                  ? true
                  : false,
          enabled: isEnabled,
          initialValue: initialValue,
          minLines: minLines,
          maxLines: isPassword ? 1 : maxLines,
          decoration: InputDecoration(
            fillColor: backgroundColor,
            filled: true,
            hintStyle: hintStyle,
            prefixIcon: isPassword ? const Icon(Icons.lock) : prefixIcon,
            hintText: hintText,
            labelText: labelText,
            border: disableOutlineBorder
                ? null
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                  ),
            enabledBorder: disableOutlineBorder
                ? null
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                    borderSide: BorderSide(
                      color: borderColor ?? Colors.grey[400],
                    ),
                  ),
            focusedBorder: disableOutlineBorder
                ? null
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: borderFocusColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
            contentPadding: const EdgeInsets.all(8.0),
          ),
          textInputAction: isDone ? TextInputAction.done : textInputAction,
          keyboardType: keyboardType,
          inputFormatters: inputFormatter,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          validator: isValidatorEnable
              ? (value) {
                  if (value.isEmpty || value == null) {
                    return '$labelText tidak boleh kosong ';
                  }
                  return null;
                }
              : null,
          onSaved: onSaved,
        ),
        if (isPassword) ...[
          IconButton(
            icon: Selector<GlobalProvider, bool>(
              selector: (_, provider) => provider.obsecurePassword,
              builder: (_, obsecurePassword, __) => Icon(
                obsecurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
            ),
            onPressed: () {
              final globalProvider = context.read<GlobalProvider>();
              return globalProvider.setObsecurePassword(globalProvider.obsecurePassword);
            },
          )
        ] else ...[
          suffixIcon ?? const SizedBox()
        ]
      ],
    );
  }
}
