import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class InternetChecker {
  Future<bool> get isConnected;
}

class InternetCheckerImp implements InternetChecker {
  final InternetConnection internetConnection;

  InternetCheckerImp(this.internetConnection);
  @override
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess;
}
