import 'package:flutter/material.dart';

import '../../../Settings/presentation/pages/Settings_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoBackup = true;
  bool _printAfterSale = false;
  String _selectedLanguage = 'العربية';
  String _selectedCurrency = 'ريال سعودي';
  double _taxRate = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'الإعدادات',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF607D8B), Color(0xFF455A64)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWideScreen ? constraints.maxWidth * 0.15 : 16,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // حساب المستخدم
                const UserProfileSection(),
                const SizedBox(height: 20),

                // الإعدادات العامة
                SettingsSection(
                  title: 'الإعدادات العامة',
                  children: [
                    SettingsSwitchTile(
                      icon: Icons.notifications_rounded,
                      iconColor: const Color(0xFFFF9800),
                      title: 'الإشعارات',
                      subtitle: 'تفعيل إشعارات النظام',
                      value: _notificationsEnabled,
                      onChanged: (val) =>
                          setState(() => _notificationsEnabled = val),
                    ),
                    SettingsSwitchTile(
                      icon: Icons.dark_mode_rounded,
                      iconColor: const Color(0xFF9C27B0),
                      title: 'الوضع الليلي',
                      subtitle: 'تفعيل المظهر الداكن',
                      value: _darkModeEnabled,
                      onChanged: (val) =>
                          setState(() => _darkModeEnabled = val),
                    ),
                    SettingsDropdownTile(
                      icon: Icons.language_rounded,
                      iconColor: const Color(0xFF2196F3),
                      title: 'اللغة',
                      subtitle: _selectedLanguage,
                      value: _selectedLanguage,
                      items: const ['العربية', 'English', 'Français'],
                      onChanged: (val) =>
                          setState(() => _selectedLanguage = val!),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // إعدادات الأعمال
                SettingsSection(
                  title: 'إعدادات الأعمال',
                  children: [
                    SettingsDropdownTile(
                      icon: Icons.attach_money_rounded,
                      iconColor: const Color(0xFF4CAF50),
                      title: 'العملة',
                      subtitle: _selectedCurrency,
                      value: _selectedCurrency,
                      items: const [
                        'ريال سعودي',
                        'دولار أمريكي',
                        'يورو',
                        'جنيه مصري',
                      ],
                      onChanged: (val) =>
                          setState(() => _selectedCurrency = val!),
                    ),
                    SettingsSliderTile(
                      icon: Icons.percent_rounded,
                      iconColor: const Color(0xFFF44336),
                      title: 'نسبة الضريبة',
                      subtitle: '${_taxRate.toStringAsFixed(0)}%',
                      value: _taxRate,
                      min: 0,
                      max: 30,
                      onChanged: (val) => setState(() => _taxRate = val),
                    ),
                    SettingsSwitchTile(
                      icon: Icons.print_rounded,
                      iconColor: const Color(0xFF00BCD4),
                      title: 'طباعة تلقائية',
                      subtitle: 'طباعة الفاتورة بعد كل عملية بيع',
                      value: _printAfterSale,
                      onChanged: (val) => setState(() => _printAfterSale = val),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // النسخ الاحتياطي والأمان
                SettingsSection(
                  title: 'النسخ الاحتياطي والأمان',
                  children: [
                    SettingsSwitchTile(
                      icon: Icons.backup_rounded,
                      iconColor: const Color(0xFF9C27B0),
                      title: 'نسخ احتياطي تلقائي',
                      subtitle: 'نسخ البيانات تلقائياً يومياً',
                      value: _autoBackup,
                      onChanged: (val) => setState(() => _autoBackup = val),
                    ),
                    SettingsTile(
                      icon: Icons.cloud_upload_rounded,
                      iconColor: const Color(0xFF2196F3),
                      title: 'نسخ احتياطي يدوي',
                      subtitle: 'إنشاء نسخة احتياطية الآن',
                      onTap: () => _showBackupDialog(context),
                    ),
                    SettingsTile(
                      icon: Icons.lock_reset_rounded,
                      iconColor: const Color(0xFFFF9800),
                      title: 'تغيير كلمة المرور',
                      subtitle: 'تحديث كلمة مرور الحساب',
                      onTap: () => _showPasswordDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // معلومات التطبيق
                SettingsSection(
                  title: 'معلومات التطبيق',
                  children: [
                    SettingsTile(
                      icon: Icons.info_rounded,
                      iconColor: const Color(0xFF607D8B),
                      title: 'عن التطبيق',
                      subtitle: 'الإصدار 1.0.0',
                      onTap: () => _showAboutDialog(context),
                    ),
                    SettingsTile(
                      icon: Icons.help_rounded,
                      iconColor: const Color(0xFF4CAF50),
                      title: 'المساعدة والدعم',
                      subtitle: 'احصل على المساعدة',
                      onTap: () => _showSupportDialog(context),
                    ),
                    SettingsTile(
                      icon: Icons.logout_rounded,
                      iconColor: const Color(0xFFF44336),
                      title: 'تسجيل الخروج',
                      subtitle: 'الخروج من الحساب الحالي',
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.cloud_upload_rounded, color: Color(0xFF2196F3)),
            SizedBox(width: 10),
            Text('نسخ احتياطي'),
          ],
        ),
        content: const Text('هل تريد إنشاء نسخة احتياطية من البيانات الآن؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('جاري إنشاء النسخة الاحتياطية...'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('تأكيد', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset_rounded, color: Color(0xFFFF9800)),
            SizedBox(width: 10),
            Text('تغيير كلمة المرور'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'كلمة المرور الحالية',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'كلمة المرور الجديدة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث كلمة المرور بنجاح')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('حفظ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_rounded, color: Color(0xFF607D8B)),
            SizedBox(width: 10),
            Text('عن التطبيق'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نظام إدارة المخزون والمبيعات',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('الإصدار: 1.0.0'),
            Text('تاريخ الإصدار: 2025'),
            SizedBox(height: 10),
            Text('تطبيق شامل لإدارة الأعمال التجارية'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF607D8B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('إغلاق', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.help_rounded, color: Color(0xFF4CAF50)),
            SizedBox(width: 10),
            Text('المساعدة والدعم'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'للحصول على المساعدة:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, size: 20),
                SizedBox(width: 10),
                Text('support@example.com'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 20),
                SizedBox(width: 10),
                Text('+966 50 123 4567'),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('إغلاق', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFF44336)),
            SizedBox(width: 10),
            Text('تسجيل الخروج'),
          ],
        ),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // العودة للصفحة الرئيسية
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('خروج', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
