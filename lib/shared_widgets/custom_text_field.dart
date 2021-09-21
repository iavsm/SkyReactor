import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends TextFormField {
  CustomTextFormField({
    @required String label,
    TextEditingController controller,
    FocusNode node,
    ValueChanged<String> onChange,
    VoidCallback onComplete,
    VoidCallback onTap,
    FormFieldValidator<String> validator,
    String hint,
    String error,
    TextInputType keyType,
    TextInputAction inputAction = TextInputAction.done,
    TextCapitalization capitalization = TextCapitalization.none,
    bool autoFocus = false,
    IconData icon,
    bool autoCorrect,
    Widget suffixIcon,
    Function(String) onFieldSubmitted,
    bool obscure = false,
    int maxLines = 1,
    Color color,
    List<TextInputFormatter> inputFormatters,
    FormFieldSetter<String> onSaved,
    TextDirection textDirection,
    bool enabled,
    TextAlign textAlign,
    Iterable<String> autoFillHints,
  })  : assert(label != null),
        super(
          autofillHints: autoFillHints,
          autofocus: autoFocus,
          controller: controller,
          cursorColor: color ?? kColorPrimary,
          focusNode: node,
          keyboardType: keyType,
          textInputAction: inputAction,
          enabled: enabled,
          textCapitalization: capitalization,
          obscureText: obscure,
          onChanged: onChange,
          autocorrect: autoCorrect ?? true,
          onTap: onTap,
          validator: validator,
          onEditingComplete: onComplete,
          onSaved: onSaved,
          style: CustomStyle(color: color ?? kColorPrimary),
          maxLines: maxLines,
          onFieldSubmitted: onFieldSubmitted,
          decoration: CustomDecoration(
            label: label,
            hint: hint,
            error: error,
            fieldIcon: icon,
            color: color,
            suffixIcon: suffixIcon,
          ),
          inputFormatters: inputFormatters,
          textDirection: textDirection,
          textAlign: textAlign ?? TextAlign.start,
        );
}

class CustomStyle extends TextStyle {
  const CustomStyle({Color color, double fontSize})
      : super(
          color: color ?? kColorPrimary,
          fontWeight: FontWeight.w600,
          fontSize: fontSize ?? 14,
        );

  const CustomStyle.medium({Color color, double fontSize})
      : super(
          color: color ?? kColorPrimary,
          fontWeight: FontWeight.w500,
          fontSize: fontSize ?? 14,
          height: 1,
        );

  const CustomStyle.hint({Color color, double fontSize})
      : super(
          color: color ?? kColorGrey,
          fontWeight: FontWeight.normal,
          fontSize: fontSize ?? 14,
        );
}

class CustomDecoration extends InputDecoration {
  CustomDecoration({
    @required String label,
    String hint,
    String error,
    IconData fieldIcon,
    Widget suffixIcon,
    Color color,
  })  : assert(label != null),
        super(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.only(left: 8.0, right: 8, top: 5, bottom: 5),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: color ?? kColorLightGrey)),
          disabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: color ?? kColorLightGrey)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: color ?? kColorLightGrey)),
          errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder:
              const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
          hintText: hint,
          hintStyle: CustomStyle.hint(color: color?.withOpacity(0.7) ?? kColorGrey, fontSize: 12),
          labelText: label,
          labelStyle: CustomStyle.medium(color: color ?? kColorPrimary),
          prefixIcon: fieldIcon != null ? Icon(fieldIcon, color: color ?? kColorPrimary) : null,
          errorText: error,
          errorMaxLines: 1,
          alignLabelWithHint: true,
          suffixIcon: suffixIcon,
        );
}
