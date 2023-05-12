import 'package:flutter/material.dart';

class IntroScreenThree extends StatelessWidget {
  const IntroScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: const [
          Spacer(),
          Text("Title 3"),
          SizedBox(
            height: 20,
          ),
          Text(
              "Here You can put some text to hightlight your app motive and feature to user these screen only come when user visit your app first time"),
          SizedBox(
            height: 20,
          ),
          Text("Here You also put some images for better deatiling"),
          Spacer()
        ],
      ),
    );
  }
}
