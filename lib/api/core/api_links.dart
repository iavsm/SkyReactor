//ignore_for_file: prefer_const_declarations
class ApiLinks {
  bool isStaging = true;

  String get stagingBase => 'http://staging.leoprime.com/api/';
  String get productionBase => 'https://cc.leoprime.com/api/';
  String get mainBase => isStaging ? stagingBase : productionBase;
  String get apiVersion => 'v3';

  String get base => mainBase + apiVersion;
  String get user => '$base/user';

  /// Login
  String get login => '$base/login';
  String get forgotPassword => '$base/resetpassword';
  String get newPassword => '$base/setnewpassword';

  /// Register
  String get register => '$base/register';
  String get registerVerify => '$base/registerverify';

  String get countries => '$base/country';
  String get states => '$base/state';

  /// User
  String get profile => '$user/profile/dashboard';

  /// Wallet
  String get transaction => '$user/wallet/transaction';
  String get withdrawalTransactions => '$transaction/withdraw';
  String get depositTransactions => '$transaction/deposit';
  String get withdrawWallet => '$user/transfers/withdraw/wallet';
  String get depositWallet => '$user/transfers/deposit/wallet';
  String get withdrawDashboard => '$withdrawWallet/dashboard';
  String get depositDashboard => '$depositWallet/dashboard';
  String get depositBuildForm => '$depositWallet/buidform';
  String get withdrawalBuildForm => '$depositWallet/buidform';
  String get depositLocalTransfer => '$depositWallet/quick';

  /// Public
  String get public => '$base/public';
  String get strategy => '$public/strategy';
  String get strategyList => '$strategy/list';

  String get strategyDetails => '$strategy/view';

  String get statistics => '$strategy/statistics';

  String get growth => '$statistics/growth';
  String get profit => '$statistics/profit';
  String get balance => '$statistics/balance';

  String get activity => '$strategy/activity';
}
