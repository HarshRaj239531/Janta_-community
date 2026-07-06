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
}
