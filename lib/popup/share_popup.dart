import 'package:flutter/material.dart';
import 'package:hans/service/state_service.dart';

openPopUpShareLoc(context, publishLocation) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          scrollable: false,
          title: const Text('Share'),
          content: SingleChildScrollView(
            child: Column(
              //shrinkWrap: true,
              children: [
                Container(
                    width: 300,
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ExactAssetImage(getAsset("HANS.png")),
                          fit: BoxFit.cover),
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Copy Link'),
            ),
            TextButton(
              onPressed: () {
                publishLocation();
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

openPopUpSharePic(context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          scrollable: false,
          title: const Text('Share'),
          content: SingleChildScrollView(
            child: Column(
              //shrinkWrap: true,
              children: [
                Container(
                    width: 300,
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: ExactAssetImage(getAsset("HANS.png")),
                          fit: BoxFit.cover),
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Copy Link'),
            ),
            TextButton(
              onPressed: () {
                // Send them to your email maybe?
                //var email = emailController.text;
                //var message = messageController.text;
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }