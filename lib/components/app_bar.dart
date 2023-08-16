import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
       title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
              IconButton(
              onPressed: scanQR,
              icon: const Icon(
                Icons.qr_code_scanner,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
    );
  }

  void scanQR() {
    //Scan QR code, if good, navigate to /profile-page
  }
}
