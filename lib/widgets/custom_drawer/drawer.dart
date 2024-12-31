import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_gen_ai/core/routes/router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header Section
          const UserAccountsDrawerHeader(
            accountName: Text("Welcome!"),
            accountEmail: Text("Your offline AI assistant"),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person, size: 50),
              backgroundColor: Colors.white,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.cyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Drawer Items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              // Navigate to Home
            },
          ),
          ListTile(
            leading: const Icon(Icons.smart_toy),
            title: const Text("AI Models"),
            onTap: () {
              Get.toNamed(Routes.modelsScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Inference Settings"),
            onTap: () {
              // Navigate to Settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text("Performance Metrics"),
            onTap: () {
              // Navigate to Performance Metrics
            },
          ),
          ListTile(
            leading: const Icon(Icons.wifi_off),
            title: const Text("Offline Mode"),
            onTap: () {
              // Navigate to Offline Settings
            },
          ),
          const Divider(), // Aesthetic divider
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Help & Support"),
            onTap: () {
              // Navigate to Help
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              // Navigate to Settings
            },
          ),
          const Spacer(), // Push the footer to the bottom
          // Footer Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text("Version 1.0.0", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    // Show credits or developers
                  },
                  child: const Text("Credits", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
