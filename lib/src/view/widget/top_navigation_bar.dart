import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wicom/core/app_color.dart';

class TopNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TopNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildNavItem(
            context: context,
            index: 0,
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Home',
            color: AppColor.primaryColor,
          ),
          _buildNavItem(
            context: context,
            index: 1,
            icon: Icons.people_outline,
            selectedIcon: Icons.people,
            label: 'Clients',
            color: Colors.blue,
          ),
          _buildNavItem(
            context: context,
            index: 2,
            icon: Icons.support_agent_outlined,
            selectedIcon: Icons.support_agent,
            label: 'Support',
            color: Colors.orange,
          ),
          _buildNavItem(
            context: context,
            index: 3,
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: 'Profile',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required Color color,
  }) {
    final isSelected = currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? color : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey[600],
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
