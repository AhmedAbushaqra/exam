import 'package:exams/presentation/color_manager.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget{
  const AppButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.color,
    this.radius,
    this.margin,
    this.height,
    this.width,
  }) : super(key: key);

  final Widget? child;
  final Function? onPressed;
  final Color? color;
  final double? radius;
  final double? margin;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.all(margin ?? 0),
      child: ElevatedButton(
        onPressed: (){onPressed!();},
        child: child,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: color==Colors.white? ColorManager.primaryGreen:color ?? Colors.white.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(radius ?? 10),
          ),
        ),
      ),
    );
  }
}