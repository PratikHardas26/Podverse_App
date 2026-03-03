import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podverse_app/Databases/shared_pref.dart';
import 'package:podverse_app/View/SignIn_Page.dart';
import 'package:podverse_app/View/notification_screen.dart';

class PodverseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  PodverseAppBar({super.key, required this.currentPage});

  SharedPref sp = SharedPref();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildLeftSection(), _buildRightSection(context)],
        ),
      ),
    );
  }

  Widget _buildLeftSection() {
    switch (currentPage) {
      case "home":
        return Image.asset(
          "assets/images/podverse-New-logo-1 bg.png",
          height: 35,
          width: 85,
          fit: BoxFit.contain,
        );

      case "library":
        return Text(
          "Library",
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        );

      case "profile":
        return Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        );

      case "search":
        return Text(
          "Search",
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        );

      case "uplode":
        return Text(
          "Uplode",
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        );

      case "admin":
        return Text(
          "Admin",
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        );

      case "notification":
        return Text(
          "Notification",
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRightSection(BuildContext context) {
    switch (currentPage) {
      case "profile":
        return IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () async {
            await sp.clearSharedPref();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SigninPage()),
              (route) => false,
            );
          },
        );

      case "search":
        return const SizedBox();

      case "uplode":
        return const SizedBox();

      case "library":
        return const SizedBox();

      case "admin":
        return IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () async {
            await sp.clearSharedPref();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SigninPage()),
              (route) => false,
            );
          },
        );

      case "notification":
        return const SizedBox();

      default:
        return IconButton(
          onPressed: () async {
            await sp.clearSharedPref();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return NotificationsScreen();
                },
              ),
            );
          },
          icon: Icon(Icons.notifications_none, color: Colors.white),
        );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(45);
}
