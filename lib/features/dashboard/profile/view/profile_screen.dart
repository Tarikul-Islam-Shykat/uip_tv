import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uip_tv/features/auth/view/login_screen.dart';
import 'package:uip_tv/utils/gradient_image.dart';
import 'package:uip_tv/utils/size_helper.dart';
import 'package:uip_tv/utils/transitions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Sizer.deviceDefaultPadding(context)),
          child: Column(
            children: [
              SizedBox(
                height: Sizer.inBetweenMaxDistance(context),
              ),
              Row(
                children: [
                  GradientBorderAvatar(
                    imagePath: 'assets/images/user.png',
                    size: Sizer.customHeight(
                        context, 0.08), // Adjust size as needed
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rafsan Jany',
                          style: TextStyle(
                              fontSize: Sizer.normal2Text(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          '@rafsanjany07',
                          style: TextStyle(
                            fontSize: Sizer.subtitleText(context),
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.white),
                title: Text('Manage your Account',
                    style: TextStyle(
                        fontSize: Sizer.normal2Text(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
              ),

              // Switch Account
              ListTile(
                leading: const Icon(Icons.people, color: Colors.white),
                title: Text('Switch Account',
                    style: TextStyle(
                        fontSize: Sizer.normal2Text(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
              ),

              const Divider(color: Colors.grey),

              // Device Theme
              ListTile(
                leading: const Icon(Icons.brightness_6, color: Colors.white),
                title: Text('Device Theme',
                    style: TextStyle(
                        fontSize: Sizer.normal2Text(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
              ),

              // Language
              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: Text('Language: English',
                    style: TextStyle(
                        fontSize: Sizer.normal2Text(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
              ),

              // Location
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.white),
                title: Text('Location: USA',
                    style: TextStyle(
                        fontSize: Sizer.normal2Text(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
              ),

              const Divider(color: Colors.grey),

              // Settings
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: Text('Settings',
                    style: TextStyle(
                        fontSize: Sizer.normal2Text(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
              ),

              // Help & Support
              ListTile(
                leading: const Icon(Icons.headset_mic, color: Colors.white),
                title: Text('Help & Support',
                    style: TextStyle(
                        fontSize: Sizer.normal2Text(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
              ),

              // Feedback
              ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title: Text('Feedback',
                    style: TextStyle(
                        fontSize: Sizer.normal2Text(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                onTap: () {},
                contentPadding: EdgeInsets.zero,
              ),

              const Divider(color: Colors.grey),

              // Sign Out
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: Text('Sign Out',
                    style: TextStyle(
                        fontSize: Sizer.normal2Text(context),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                onTap: () async {
                  SharedPreferences loginHistory =
                      await SharedPreferences.getInstance();
                  await loginHistory.setBool('loginHistory', false);
                  transition().navigateWithpushAndRemoveUntilTransition(
                      context, const LoginScreen(),
                      transitionDirection: TransitionDirection.right);
                },
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
