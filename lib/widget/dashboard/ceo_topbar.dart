import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../common/colors.dart';

/// CEO Dashboard top bar with title and avatar dropdown
class CEOTopBar extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;

  const CEOTopBar({
    super.key,
    required this.userName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 53, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Title
          const Text(
            'CEO Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          // Center: Create Building Button
          ElevatedButton.icon(
            onPressed: () => context.push('/ceo/building/create'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Building'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ceoPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Right: Avatar with dropdown
          _buildAvatarDropdown(context),
        ],
      ),
    );
  }

  Widget _buildAvatarDropdown(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.ceoPrimary,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.ceoPrimaryLight,
          child: Text(
            userName.isNotEmpty ? userName[0].toUpperCase() : 'C',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'dashboard',
          child: Row(
            children: [
              Icon(Icons.dashboard, size: 20, color: AppColors.textSecondary),
              SizedBox(width: 12),
              Text('Dashboard'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: AppColors.error),
              SizedBox(width: 12),
              Text('Logout', style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
      ],
      onSelected: (String value) {
        if (value == 'logout') {
          _showLogoutConfirmation(context);
        }
        // 'dashboard' is already current page, so no action needed
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onLogout();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
