import 'package:algorand_dart/algorand_dart.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ownify/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:oktoast/oktoast.dart';
import 'package:ownify/service/algoservice/agorand_service.dart';
import 'package:ownify/test.dart';

import 'package:walletconnect_secure_storage/walletconnect_secure_storage.dart';
void main() async {
  //mobileLanguage.value = await Utils.getLanguange();
  await dotenv.load(fileName: ".env");
  // StatusNotifier().walletConnectType.add(walletConnectType);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp();

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: SpinKitCircle(
            color: Colors.black,
            size: 80.0,
          ),
        ),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This mak(more dense) than on mobile platforms.
            //visualDensity: Ves the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together isualDensity.adaptivePlatformDensity,
          ),
          supportedLocales: [
            Locale('en', ''), // English, no country code
            Locale('es', ''), // Spanish, no country code
          ],
          initialRoute: '/',
          //onGenerateRoute: RouteGenerator.generateRoute,
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            AppRouter.main.namespace(): (context) =>  TestTxScreen()
          },
        ),
      ),
    );
  }
}
