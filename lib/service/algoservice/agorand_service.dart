import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:algorand_dart/algorand_dart.dart';
import 'package:oktoast/oktoast.dart';
import 'package:ownify/service/algoservice/transaction_with_wallet.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:crypto/crypto.dart';
import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class AlgorandService extends TransactionWithWallet {
  final Algorand algorand;
  final AlgorandWalletConnectProvider provider;

  AlgorandService._internal({
    required WalletConnect connector,
    required this.algorand,
    required this.provider,
  }) : super(connector: connector);

  factory AlgorandService() {
    final algorand = Algorand(
        algodClient: AlgodClient(apiUrl: AlgoExplorer.TESTNET_ALGOD_API_URL),
        indexerClient:
            IndexerClient(apiUrl: AlgoExplorer.TESTNET_INDEXER_API_URL));

    final sessionStorage = WalletConnectSecureStorage();
    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      sessionStorage: sessionStorage,
      clientMeta: PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

    final provider = AlgorandWalletConnectProvider(connector);

    return AlgorandService._internal(
      connector: connector,
      algorand: algorand,
      provider: provider,
    );
  }

  @override
  Future<SessionStatus> connect({OnDisplayUriCallback? onDisplayUri}) async {
    return connector.connect(chainId: 4160, onDisplayUri: onDisplayUri);
  }

  Future<SessionStatus> create({OnDisplayUriCallback? onDisplayUri}) async {
    return connector.createSession(chainId: 4160, onDisplayUri: onDisplayUri);
  }

  @override
  Future<void> disconnect() async {
    await connector.killSession();
  }

  @override
  Future<String> signTransaction(SessionStatus session) async {
    final sender = Address.fromAlgorandAddress(address: session.accounts[0]);

    // Fetch the suggested transaction params
    final params = await algorand.getSuggestedTransactionParams();

    // Build the transaction
    final tx = await (PaymentTransactionBuilder()
          ..sender = sender
          ..noteText = 'Signed with WalletConnect'
          ..amount = Algo.toMicroAlgos(0.0001)
          ..receiver = sender
          ..suggestedParams = params)
        .build();

    // Sign the transaction
    final signedBytes = await provider.signTransaction(
      tx.toBytes(),
      params: {
        'message': 'Optional description message',
      },
    );

    // Broadcast the transaction
    final txId = await algorand.sendRawTransactions(
      signedBytes,
      waitForConfirmation: true,
    );

    // Kill the session
    connector.killSession();

    return txId;
  }







  Future<SessionStatus?> connectExternalWallet() async {
    final session = await create(
      onDisplayUri: (uri) async {
        String newUri = "algorand-wc://wc?uri=${uri.toString()}";
        print(newUri);
        if (Platform.isIOS) {
          if (!await launch(newUri)) throw 'Could not launch $uri';
        } else {
          if (!await launch(uri)) throw 'Could not launch $uri';
        }
      },
    );

    // await connect(
    //   onDisplayUri: (uri) async {
    //     String newUri = "algorand-wc://wc?uri=${uri.toString()}";
    //     print(newUri);
    //     if (Platform.isIOS) {
    //       if (!await launch(newUri)) throw 'Could not launch $uri';
    //     } else {
    //       if (!await launch(uri)) throw 'Could not launch $uri';
    //     }
    //   },
    // );
    if (session.accounts.length == 0) {
      showToast("Unable connect external wallet!");
      return null;
    } else {
     
      return session;
    }
  }
}
