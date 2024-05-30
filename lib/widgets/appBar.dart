import 'package:cbse_wale_android/logout/logoutFxn.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final bool value;
  const CustomAppBar({super.key, required this.text, this.value = true});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: value,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: Color(0xFFF57C00),
      centerTitle: true,
    );
  }
}
