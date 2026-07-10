class ApiConstants {
  ApiConstants._();

  // Base URL — Android emulator → localhost (Mapped to Docker port 80)
  static const String baseUrl = 'http://10.0.2.2/api';

  // Auth
  static const String login = '/user/login';
  static const String logout = '/user/logout';

  // Dashboard
  static const String dashboard = '/user/dashboard';

  // Materials & Stocks
  static const String materials = '/user/materials';
  static const String materialStocks = '/user/materials/stocks';

  // Profile & Vault
  static const String profile = '/user/profile';
  static const String profileUpdate = '/user/profile/update';
  static const String vault = '/user/vault';
  static const String vaultUpload = '/user/vault/upload';

  // Committees
  static const String committees = '/user/committees';
  static String committeeDetails(int id) => '/user/committees/$id';
  static String joinCommittee(int id) => '/user/committees/$id/join';
  static const String myCommittees = '/user/my-committees';
  static const String termsConditions = '/user/terms-conditions';

  // Loans
  static const String loans = '/user/loans';
  static String loanDetails(int id) => '/user/loans/$id';

  // Installments
  static const String pendingInstallments = '/user/installments/pending';
  static const String paidInstallments = '/user/installments/paid';

  // Lottery
  static const String lotteryWinners = '/user/lotteries/winners';
  static const String lotteryHistory = '/user/lotteries/history';

  // Payments
  static const String pay = '/user/payments/pay';
  static const String paymentSetting = '/user/payment-setting';

  /// Resolves database image URLs that point to localhost (common in local Laravel dev servers)
  /// so that they point to the correct emulator/device accessible host dynamically.
  static String? resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    try {
      final baseUri = Uri.parse(baseUrl);
      final host = '${baseUri.scheme}://${baseUri.host}${baseUri.hasPort ? ':${baseUri.port}' : ''}';
      if (url.startsWith('http://localhost')) {
        return url.replaceFirst('http://localhost', host);
      }
      if (url.startsWith('http://127.0.0.1')) {
        return url.replaceFirst('http://127.0.0.1', host);
      }
    } catch (_) {}
    return url;
  }
}
