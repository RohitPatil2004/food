import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart'; // Import your login screen

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showUserInfoDialog(context, user);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeService.isDarkMode ? Colors.grey[900]! : Colors.orange[50]!,
              themeService.isDarkMode ? Colors.grey[800]! : Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Theme Settings Card
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance Settings',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SwitchListTile(
                      title: Text('Dark Mode'),
                      value: themeService.isDarkMode,
                      activeColor: Colors.deepOrange,
                      onChanged: (value) => themeService.toggleTheme(),
                    ),
                  ],
                ),
              ),
            ),
            // Reset Button
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text('Reset Preferences'),
                            content: Text('Reset all settings to default?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  themeService.resetPreferences();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Settings reset'),
                                      backgroundColor: Colors.deepOrange,
                                    ),
                                  );
                                },
                                child: Text('Reset'),
                              ),
                            ],
                          ),
                    );
                  },
                  child: Text(
                    'Reset All Settings',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // App Version Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'TASTE TRIAL v1.0.0\n©️ 2025 Food App Inc.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ), // Navigate to the login screen
            );
          },
        ),
      ),
    );
  }

  void _showUserInfoDialog(BuildContext context, User? user) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool _obscurePassword = true;

    // Fetch user name from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('ids').doc(user?.uid).get();
    String userName = userDoc['name'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.orange[50], // Set a background color
          title: Text(
            'Update User Info',
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Adjust size to fit content
              children: [
                TextField(
                  controller: nameController..text = userName, // Set the fetched name
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.deepOrange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.deepOrange,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10), // Add spacing
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: user?.email,
                    labelStyle: TextStyle(
                      color: Colors.deepOrange,
                    ), // Set label color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  style: TextStyle(color: Colors.deepOrange), // Set text color
                ),
                SizedBox(height: 10), // Add spacing
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.deepOrange,
                        width: 2,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.deepOrange,
                      ),
                      onPressed: () {
                        _obscurePassword = !_obscurePassword;
                        // Rebuild the dialog to reflect the change
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.deepOrange)),
            ),
            TextButton(
              onPressed: () async {
                if (passwordController.text.isNotEmpty) {
                  try {
                    await user?.updatePassword(passwordController.text);
                    await FirebaseFirestore.instance
                        .collection('ids')
                        .doc(user?.uid)
                        .set({
                          'name': nameController.text,
                          'email': user?.email,
                        }, SetOptions(merge: true));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User info updated')),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating user info: $e')),
                    );
                  }
                }
              },
              child: Text('Update', style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        );
      },
    );
  }
}
