import 'dart:async';
import 'package:flutter/material.dart';
import '../../main.dart'; // For global accessors ($appUtils, $styles, $strings, $sharedPrefsManager)
import '../../services/auth_service.dart';
import '../../utils/app_constants.dart';
import '../../utils/responsive.dart' as $appUtils; // For AuthService().logout()

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? _userEmail;
  String? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    await $sharedPrefsManager.init(); // Ensure prefs are loaded
    setState(() {
      _userEmail = $sharedPrefsManager.getProfile(); // Assuming profile stores email or name
      _userProfile = $sharedPrefsManager.getProfile(); // Assuming profile is the user's name/email
    });
  }

  // Logout Confirmation Dialog (moved from MainPage for self-containment)
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout", style: TextStyle(fontWeight: FontWeight.bold, fontSize: $appUtils.sizing(18.0, context))),
          content: Text("Are you sure you want to log out?", style: TextStyle(fontSize: $appUtils.sizing(14.0, context))),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
              child: Text($strings.cancel, style: TextStyle(color: $styles.colors.blue, fontSize: $appUtils.sizing(14.0, context))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
                AuthService().logout(); // Perform logout
              },
              child: Text($strings.logOut, style: TextStyle(color: $styles.colors.red, fontSize: $appUtils.sizing(14.0, context))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Use SingleChildScrollView for better responsiveness
      child: Padding(
        padding: EdgeInsets.all($appUtils.sizing(defaultPadding * 2, context)), // Increased padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            $appUtils.gap(context, height: 40), // Top spacing
            CircleAvatar(
              radius: $appUtils.sizing(60.0, context), // Larger avatar
              backgroundColor: $styles.colors.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: $appUtils.sizing(70.0, context),
                color: $styles.colors.primary,
              ),
            ),
            $appUtils.gap(context, height: 25),
            Text(
              _userProfile ?? "User Profile",
              style: TextStyle(
                fontSize: $appUtils.sizing(28.0, context),
                fontWeight: FontWeight.bold,
                color: $styles.colors.title,
              ),
              textAlign: TextAlign.center,
            ),
            $appUtils.gap(context, height: 8),
            Text(
              _userEmail ?? "user@example.com",
              style: TextStyle(
                fontSize: $appUtils.sizing(18.0, context),
                color: $styles.colors.greyStrong,
              ),
              textAlign: TextAlign.center,
            ),
            $appUtils.gap(context, height: 50), // More spacing before button
            SizedBox(
              width: double.infinity, // Full width button
              child: ElevatedButton.icon(
                onPressed: () {
                  _showLogoutConfirmationDialog(context);
                },
                icon: Icon(Icons.logout, color: $styles.colors.white),
                label: Text(
                  $strings.logOut,
                  style: TextStyle(
                    fontSize: $appUtils.sizing(16.0, context),
                    fontWeight: FontWeight.bold,
                    color: $styles.colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: $styles.colors.red,
                  padding: EdgeInsets.all($appUtils.sizing(15.0, context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular($appUtils.sizing(10.0, context)),
                  ),
                ),
              ),
            ),
            $appUtils.gap(context, height: 40), // Bottom spacing
          ],
        ),
      ),
    );
  }
}
