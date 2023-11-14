import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:anekapanduan/utils/colors.dart';

class NeewsTextField extends StatelessWidget {
  final String label;
  final TextEditingController? textEditingController;
  final String? icon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool? obscureText;

  const NeewsTextField(
      {super.key,
      required this.label,
      this.textEditingController,
      this.icon,
      this.keyboardType,
      this.onChanged,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText ?? false,
      onChanged: onChanged ?? (value) {},
      controller: textEditingController ?? TextEditingController(),
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
          prefixIcon: icon != null
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    icon!,
                    colorFilter:
                        const ColorFilter.mode(greyColor, BlendMode.srcIn),
                  ),
                )
              : const SizedBox(),
          label: Text(
            label,
            style: const TextStyle(color: greyColor),
          ),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: greyLight))),
    );
  }
}
