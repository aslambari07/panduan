import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/spacer.dart';

class SettingsTile extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback onPressed;
  final Color? colorTheme;
  final bool showDivider;
  final Widget? suffixWidget;
  const SettingsTile({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.colorTheme,
    required this.showDivider,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  SvgPicture.asset(icon,
                      width: 28,
                      height: 28,
                      colorFilter: ColorFilter.mode(
                          colorTheme ?? Theme.of(context).iconTheme.color!,
                          BlendMode.srcIn)),
                  getHorizontalSpace(15),
                  Text(
                    text,
                    style: colorTheme != null
                        ? Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: colorTheme)
                        : Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  suffixWidget ??
                      SvgPicture.asset(
                        arrowIcon,
                        width: 14,
                        height: 14,
                      ),
                ],
              ),
              getVerticalSpace(15),
              showDivider == true
                  ? Divider(
                      height: 0.5,
                      color: Colors.grey[400],
                      thickness: 0.5,
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
