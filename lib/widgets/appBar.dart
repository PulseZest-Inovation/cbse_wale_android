import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final VoidCallback? onPressed;
  const CustomAppBar({super.key, required this.text, this.onPressed});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Row(
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
      actions: [
        IconButton(onPressed: onPressed, icon: Icon(Icons.account_circle))
      ],
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: Color(0xFFF57C00),
      centerTitle: true,
    );
  }
}
