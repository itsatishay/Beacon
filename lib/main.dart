import 'package:async_redux/async_redux.dart';
import 'package:beacon/async_redux/app_state.dart';
import 'package:beacon/hardcoded/hardcoded_strings.dart';
import 'package:beacon/views/screens/enterName/enter_name_viewmodel_connector.dart';
import 'package:beacon/views/screens/homepage/homepage_viewmodel_connector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/components/custom_scroller_controller.dart';

/// store variable to store the redux data
late Store<AppState> store;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  final AppState state = await AppState.initialState();
  store = Store<AppState>(initialState: state);
  // set the app orientations to only portrait style
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(StoreProvider<AppState>
    (store: store, child: EasyLocalization(
      supportedLocales: const <Locale>[Locale('en'), Locale('hi')],
      path: "assets/translations",
      child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      scrollBehavior: CustomScrollController(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: HardcodedStrings.appName,
      home: const NextPage(),
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    nextPage(context);
    return const Scaffold();
  }
  /// decide which page to go
  Future<void> nextPage(BuildContext context) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userName = sharedPreferences.getString(HardcodedStrings.userNameLocalSaved) ?? "";
    if(userName.isEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const EnterNameConnector()));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomepageConnector()));
    }
  }
}

