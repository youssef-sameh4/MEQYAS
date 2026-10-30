
import 'package:flutter/material.dart';
import 'package:meqyas/Widgets/Appcolor.dart';
import 'package:meqyas/feature/pages/AlertsPage.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  static const Color _blue = Color(0xFF3978D0);
  static const Color _textColor = Color(0xFF173D70);
  static const Color _muted = Color(0xFFB9CDE8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/photo_2026-10-17_13-24-57.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
   children: [


                    const Text(
                      'Profile & Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AlertsPage(),
                          ),
                        );
                      },
                      child: headerIcon(Icons.notifications_none),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
                  child: Column(
                    children: [
                      _profileCard(),

                      const SizedBox(height: 10),
                      SizedBox(height: 15,),
                      _settingsItem(
                        icon: Icons.person_outline,
                        title: 'Account',
                        onTap: () => _showMessage(context, 'Account'),
                      ),
                      SizedBox(height: 15,),
                      _settingsItem(
                        icon: Icons.notifications_none,
                        title: 'Notification',
                        onTap: () =>
                            _showMessage(context, 'Notification'),
                      ),

                      SizedBox(height: 15,),
                      _settingsItem(
                        icon: Icons.grid_view,
                        title: 'Units & Preferences',
                        onTap: () =>
                            _showMessage(context, 'Units & Preferences'),
                      ),
                      SizedBox(height: 15,),
                      _settingsItem(
                        icon: Icons.language,
                        title: 'Language',
                        trailing: 'English (US)',
                        onTap: () => _showLanguageDialog(context),
                      ),
                      SizedBox(height: 15,),
                      _settingsItem(
                        icon: Icons.lock_outline,
                        title: 'Security',
                        onTap: () => _showMessage(context, 'Security'),
                      ),
                      SizedBox(height: 15,),
                      _settingsItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () =>
                            _showMessage(context, 'Help & Support'),
                      ),
                      SizedBox(height: 15,),
                      _settingsItem(
                        icon: Icons.info_outline,
                        title: 'About',
                        onTap: () => _showMessage(context, 'About'),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () => _showLogoutDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFE5E9),
                            foregroundColor: const Color(0xFFE53950),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: const Text(
                            'Log out',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 60,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(

        gradient: const LinearGradient(
          colors: [
            Color(0xFF4D8CE5),
            Color(0xFF2A5DA5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.28),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 7),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Operator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'operator@meqyas.com',
                  style: TextStyle(
                    color: Color(0xFFD6E6FF),
                    fontSize:14 ,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _settingsItem({
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: _blue,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: _textColor,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (trailing != null)
                  Text(
                    trailing,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                    ),
                  ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title selected'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          backgroundColor: const Color(0xFF102D50),
          title: const Text(
            'Choose Language',
            style: TextStyle(color: Colors.white),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'English (US)',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'العربية',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF102D50),
          title: const Text(
            'Log out',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // Add your logout logic here.
              },
              child: const Text(
                'Log out',
                style: TextStyle(color: Color(0xFFFF6575)),
              ),
            ),
          ],
        );
      },
    );
  }
}
Widget headerIcon(IconData icon) {
  return Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: Appcolor.cardBlue.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(
      icon,
      color: Colors.white,
      size: 21,
    ),
  );
}