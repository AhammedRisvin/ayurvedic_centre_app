mixin Urls {
  static const String baseUrl = 'https://api-v1.findzzy.com';

  // Auth
  static const String login = '/user/send-otp';
  static const String verifyOtp = '/user/verify-otp';
  static const String register = '/user/register';

  //Home
  static const String home = '/user/get-home';
}
