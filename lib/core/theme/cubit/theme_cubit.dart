import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const String _themeKey = 'user_theme_preference';

  /// تحميل الثيم المفضل من الذاكرة المحلية عند بدء التطبيق
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // نستخدم الـ index الخاص بالـ Enum لتخزين القيمة (0, 1, 2)
    final themeIndex = prefs.getInt(_themeKey);

    if (themeIndex != null) {
      emit(ThemeMode.values[themeIndex]);
    } else {
      emit(ThemeMode.system); // الافتراضي هو اتباع نظام التشغيل
    }
  }

  /// تغيير الثيم وحفظه
  Future<void> setTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themeMode.index);
    emit(themeMode);
  }

  /// وظيفة سريعة للتبديل بين الـ Dark والـ Light فقط (اختياري)
  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }
}