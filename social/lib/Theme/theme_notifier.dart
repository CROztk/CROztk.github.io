import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier() {
    _currentLanguage = _languageEn;
  }
  ThemeMode _themeMode = ThemeMode.dark;
  final Map<String, String> _languageEn = {
    "language": "en",
    "title": "s o C I a l",
    "home": "H O M E",
    "profile": "P R O F I L E",
    "users": "U S E R S",
    "email": "Email",
    "password": "Password",
    "confirm password": "Confirm Password",
    "login": "Login",
    "logout": "L O G O U T",
    "don't have an account?": "Don't have an account?",
    "let's register!": " Let's register!",
    "create account": "Create Account",
    "already have an account?": "Already have an account?",
    "let's login!": " Let's login!",
    "passwords do not match": "Passwords do not match",
    "invalid email": "Invalid email",
    "username already exists": "Username already exists",
    "error": "Error",
    "email or password cannot be empty": "Email or password cannot be empty",
    "ok": "Ok",
    "invalid email or password": "Invalid email or password",
    "profile updated successfully!": "Profile updated successfully!",
    "something went wrong": "Something went wrong",
    "following": "Following",
    "followers": "Followers",
    "edit profile": "Edit Profile",
    "edit username": "Edit Username",
    "edit bio": "Edit Bio",
    "cancel": "Cancel",
    "save profile": "Save Profile",
    "no data": "No data",
    "text posts": "Text Posts",
    "image posts": "Image Posts",
    "username": "Username",
    "error loading users": "Error loading users",
    "no users found": "No users found",
    "what's on your mind?": "What's on your mind?",
    "no posts found": "No posts found",
    "follow": "Follow",
    "following already": "Following",
  };

  final Map<String, String> _languageTr = {
    "language": "tr",
    "title": "s o C I a l",
    "home": "A N A  S A Y F A",
    "profile": "P R O F İ L",
    "users": "K U L L A N I C I L A R",
    "email": "Email",
    "password": "Şifre",
    "confirm password": "Şifreyi Onayla",
    "login": "Giriş Yap",
    "logout": "Ç I K I Ş",
    "don't have an account?": "Hesabın yok mu?",
    "let's register!": " Hemen kayıt ol!",
    "create account": "Hesap Oluştur",
    "already have an account?": "Zaten bir hesabın var mı?",
    "let's login!": " Hemen giriş yap!",
    "passwords do not match": "Şifreler uyuşmuyor!",
    "invalid email": "Geçersiz email!",
    "username already exists": "Kullanıcı adı kullanılıyor!",
    "error": "Hata",
    "email or password cannot be empty": "Email ya da şifre boş olamaz",
    "ok": "Tamam",
    "invalid email or password": "Geçersiz email veya şifre",
    "profile updated successfully!": "Profil başarıyla güncellendi!",
    "something went wrong": "Bir şeyler ters gitti",
    "following": "Takip Edilen",
    "followers": "Takipçiler",
    "edit profile": "Profili Düzenle",
    "edit username": "Kullanıcı Adını Düzenle",
    "edit bio": "Biyografiyi Düzenle",
    "cancel": "İptal",
    "save profile": "Profili Kaydet",
    "no data": "Veri yok",
    "text posts": "Yazı Gönderileri",
    "image posts": "Foto Gönderileri",
    "username": "Kullanıcı Adı",
    "error loading users": "Kullanıcılar yüklenirken hata oluştu",
    "no users found": "Kullanıcı bulunamadı",
    "what's on your mind?": "Aklında ne var?",
    "no posts found": "Gönderi bulunamadı",
    "follow": "Takip Et",
    "following already": "Takip Ediliyor",
  };

  late Map<String, String> _currentLanguage;
  Map<String, String> get currentLanguage => _currentLanguage;

  void setLanguage(String language) {
    if (language == "en") {
      _currentLanguage = _languageEn;
    } else {
      _currentLanguage = _languageTr;
    }
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  void toggleThemeMode() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
