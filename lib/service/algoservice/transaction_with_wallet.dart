import 'package:algorand_dart/algorand_dart.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

abstract class TransactionWithWallet {
  TransactionWithWallet({required this.connector});

  final WalletConnect connector;
  Future<SessionStatus> connect({OnDisplayUriCallback? onDisplayUri});

  Future<void> disconnect();
}
