import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  final Color iconColor;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor = const Color(0xFF176B45),
    this.titleColor = Colors.black87,
    this.iconColor = Colors.black87,
    this.showBackButton = true,
    this.actions,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: iconColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      primary: true,
      toolbarHeight: 60,
      automaticallyImplyLeading: false,

      leading: showBackButton
          ? IconButton(
              onPressed: onBackPressed ??
                  () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
            )
          : null,

      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      actions: actions,
    );
  }
}