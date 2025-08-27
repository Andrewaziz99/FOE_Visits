import 'package:flutter/material.dart';
import '../shared/image_helper.dart';

Widget loadingDialog(BuildContext context) {
      return Center(
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0, // Removes shadow
          content: Column(
            mainAxisSize: MainAxisSize.min, // Makes the column take minimum space
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CircularProgressIndicator(
              //   valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // Customize progress indicator color
              // ),
              Image(image: AssetImage(ImageHelper.getImagePath('assets/images/loading1.gif')), width: 120, height: 120),
              SizedBox(height: 10),
              Text(
                'جاري التحميل...',
                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Cairo'),
              ),
            ],
          ),
        ),
      );
}