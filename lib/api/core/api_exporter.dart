import 'package:copy_trading/api/auth_api.dart';
import 'package:copy_trading/api/public_api.dart';
import 'package:copy_trading/api/user_api.dart';
import 'package:copy_trading/api/wallet_api.dart';

import 'api_core.dart';

class ApiExporter with ApiCore, PublicApi, AuthApi, WalletApi, UserApi {}
