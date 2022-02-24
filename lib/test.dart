import 'package:flutter/material.dart';
import 'package:ownify/service/algoservice/agorand_service.dart';

class TestTxScreen extends StatefulWidget {
  TestTxScreen({Key? key}) : super(key: key);

  @override
  State<TestTxScreen> createState() => _TestTxScreenState();
}

class _TestTxScreenState extends State<TestTxScreen> {
  void testTx() async {
    final session = await AlgorandService().connectExternalWallet();
    print(AlgorandService().connector.session);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => testTx(),
            child: Container(
              padding: EdgeInsets.all(32),
              color: Colors.red,
              child: Center(
                child: Text(
                  "Test transaction",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
