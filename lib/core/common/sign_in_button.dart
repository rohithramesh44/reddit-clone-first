import 'package:flutter/material.dart';
import 'package:reddit_clone/core/constants/constant.dart';
import 'package:reddit_clone/theme/pallete.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Image.asset(
          Constant.googlePath,
          width: 34,
        ),
        label: const Text(
          'Continue With Google',
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
