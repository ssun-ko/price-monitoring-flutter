import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';

class ChartArea extends StatelessWidget {
  const ChartArea({
    Key? key,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(

      )
    );
  }
}