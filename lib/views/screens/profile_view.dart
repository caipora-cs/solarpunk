import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 47,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Center(
        child: InkWell(
          onTap: () {

          },
          child: Text(
                 'Sign Out',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}