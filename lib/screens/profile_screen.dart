import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../services/data_service.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final dataService = context.read<DataService>();
    final user = dataService.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _emailNotifications = user.emailNotifications;
      _pushNotifications = user.pushNotifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: _saveProfile,
              child: Text(
                'Save',
                style: TextStyle(color: AppConstants.primaryColor),
              ),
            )
          else
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          final user = dataService.currentUser;
          
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 64,
                    color: AppConstants.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Profile not available',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: AppConstants.defaultPadding,
            child: AnimationLimiter(
              child: Form(
                key: _formKey,
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: Duration(milliseconds: 600),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      Card(
                        child: Padding(
                          padding: AppConstants.defaultPadding,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(user.profileImage),
                                  ),
                                  if (_isEditing)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppConstants.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                                          constraints: BoxConstraints(
                                            minWidth: 32,
                                            minHeight: 32,
                                          ),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Photo upload feature coming soon!'),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (!_isEditing) ...
                                [
                                  SizedBox(height: 16),
                                  Text(
                                    user.name,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: AppConstants.defaultPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Personal Information',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _nameController,
                                enabled: _isEditing,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                enabled: _isEditing,
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$').hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _phoneController,
                                enabled: _isEditing,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  prefixIcon: Icon(Icons.phone_outlined),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: AppConstants.defaultPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notification Preferences',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 16),
                              SwitchListTile(
                                title: Text('Email Notifications'),
                                subtitle: Text('Receive updates via email'),
                                value: _emailNotifications,
                                onChanged: _isEditing
                                    ? (value) => setState(() => _emailNotifications = value)
                                    : null,
                                activeColor: AppConstants.primaryColor,
                                contentPadding: EdgeInsets.zero,
                              ),
                              SwitchListTile(
                                title: Text('Push Notifications'),
                                subtitle: Text('Receive updates on your device'),
                                value: _pushNotifications,
                                onChanged: _isEditing
                                    ? (value) => setState(() => _pushNotifications = value)
                                    : null,
                                activeColor: AppConstants.primaryColor,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.help_outline, color: AppConstants.primaryColor),
                              title: Text('Help & Support'),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Help & Support coming soon!'),
                                  ),
                                );
                              },
                            ),
                            Divider(height: 1),
                            ListTile(
                              leading: Icon(Icons.privacy_tip_outlined, color: AppConstants.primaryColor),
                              title: Text('Privacy Policy'),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Privacy Policy coming soon!'),
                                  ),
                                );
                              },
                            ),
                            Divider(height: 1),
                            ListTile(
                              leading: Icon(Icons.info_outline, color: AppConstants.primaryColor),
                              title: Text('About'),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () => _showAboutDialog(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      if (!_isEditing)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _showLogoutDialog,
                            icon: Icon(Icons.logout),
                            label: Text('Logout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.error,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveProfile,
                                child: dataService.isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text('Save Changes'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  setState(() => _isEditing = false);
                                  _resetForm();
                                },
                                child: Text('Cancel'),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 24),
                      Text(
                        AppConstants.copyrightText,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _resetForm() {
    final dataService = context.read<DataService>();
    final user = dataService.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _emailNotifications = user.emailNotifications;
      _pushNotifications = user.pushNotifications;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dataService = context.read<DataService>();
    final currentUser = dataService.currentUser;
    
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        emailNotifications: _emailNotifications,
        pushNotifications: _pushNotifications,
      );

      await dataService.updateUserProfile(updatedUser);
      
      setState(() => _isEditing = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppConstants.success,
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: AppConstants.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.error,
              foregroundColor: Colors.white,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppConstants.appName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0'),
            SizedBox(height: 8),
            Text(AppConstants.tagline),
            SizedBox(height: 16),
            Text(
              'A dedicated mobile reporting app designed specifically for doctors in India who use digital marketing services.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}