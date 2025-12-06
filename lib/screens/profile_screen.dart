import 'package:flutter/material.dart';
import '../services/static_data_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late Map<String, dynamic> userProfile;
  late Map<String, bool> notificationPreferences;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    userProfile = StaticDataService.getUserProfile();
    notificationPreferences = Map<String, bool>.from(userProfile['notificationPreferences']);
    
    _nameController = TextEditingController(text: userProfile['name']);
    _emailController = TextEditingController(text: userProfile['email']);
    _phoneController = TextEditingController(text: userProfile['phone']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.primary),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 24),
            _buildProfileForm(),
            SizedBox(height: 24),
            _buildNotificationPreferences(),
            SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userProfile['profileImage']),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            userProfile['name'],
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${userProfile['specialty']} • ${userProfile['clinic']}',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        filled: true,
        fillColor: _isEditing ? Colors.white : AppColors.surface,
      ),
    );
  }

  Widget _buildNotificationPreferences() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification Preferences',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          ...notificationPreferences.entries.map((entry) {
            return _buildNotificationToggle(
              _formatPreferenceName(entry.key),
              entry.value,
              (value) {
                setState(() {
                  notificationPreferences[entry.key] = value;
                });
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: _isEditing ? onChanged : null,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (_isEditing) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _cancelEditing,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.textSecondary),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Save Changes'),
            ),
          ),
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _showLogoutDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _nameController.text = userProfile['name'];
      _emailController.text = userProfile['email'];
      _phoneController.text = userProfile['phone'];
      notificationPreferences = Map<String, bool>.from(userProfile['notificationPreferences']);
    });
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        userProfile['name'] = _nameController.text;
        userProfile['email'] = _emailController.text;
        userProfile['phone'] = _phoneController.text;
        userProfile['notificationPreferences'] = notificationPreferences;
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _formatPreferenceName(String key) {
    switch (key) {
      case 'emailNotifications':
        return 'Email Notifications';
      case 'pushNotifications':
        return 'Push Notifications';
      case 'performanceAlerts':
        return 'Performance Alerts';
      case 'taskUpdates':
        return 'Task Updates';
      case 'weeklyReports':
        return 'Weekly Reports';
      default:
        return key;
    }
  }
}