import 'package:flutter/material.dart';
import 'package:price/core/constants/string_constants.dart';
import 'package:price/responsive.dart';

class ExcelDownloadButton extends StatelessWidget {
  final Function() onPressed;

  ExcelDownloadButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if(Responsive.isDesktop(context)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            child: Text(excelButtonLabel),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Text(excelButtonLabel),
        ),
      );
    }
  }
}
