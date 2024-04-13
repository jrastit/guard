import 'package:flutter/material.dart';
import 'package:hans/model/user.dart';
import 'package:hans/model/wallet.dart';
import 'package:hans/section/login_section.dart';
import 'package:hans/section/map_section.dart';
import 'package:hans/section/mobile_auth_section.dart';
import 'package:hans/section/session_loading_section.dart';
import 'package:hans/section/setting_section.dart';
import 'package:hans/section/wallet_loading_section.dart';
import 'package:hans/section/wallet_section.dart';
import 'package:hans/service/state_service.dart';
import 'package:tekflat_design/tekflat_design.dart';
//import 'package:flutter'

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hans & ...',
      // This is the theme of your application.
      theme: TekThemes.light,
      home: TekResponsive.appResBuilder(
          const MyHomePage(title: 'Hans & ...'),
        ));
  }
}

/* LOGIN PAGE */
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Home page of your application. It is stateful (defined below).
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? _user;
  List<WalletMeta>? _wallets;
  String? _address;
  AppState appState = isMobile ? AppState.biometric : AppState.retrieveSession;

  void setUser(User? user) {
    setState(() {
      _user = user;
    });
  }

  void setWallets(List<WalletMeta> wallets) {
    setState(() {
      _wallets = wallets;
    });
  }

  void setAppState(AppState state) {
    setState(() {
      appState = state;
    });
  }

  void setAddress(String address) {
    setState(() {
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> tabsHeader = [];
    List<Widget> tabsContent = [];

    if (appState == AppState.biometric) {
      tabsHeader.add(const Tab(
        icon: Icon(Icons.smartphone),
      ));
      tabsContent.add(MobileAuthSection(setAppState: setAppState));
    } else {
      if (appState == AppState.retrieveSession) {
        return LoadingSessionSection(
            user: _user, setUser: setUser, setAppState: setAppState);
      }
      if (appState == AppState.login) {
        tabsHeader.add(Tab(
          icon: ImageIcon(AssetImage(getAsset('HANS.png')),),
        ));
        tabsContent
            .add(LoginSection(setUser: setUser, setAppState: setAppState));
      }
      if (appState == AppState.retrieveWallet) {
        return LoadingWalletSection(
            wallets: _wallets,
            setWallets: setWallets,
            setAppState: setAppState);
      }

      if (appState == AppState.wallet) {
        tabsHeader.add(const Tab(
          icon: Icon(Icons.account_balance_wallet),
        ));
        tabsContent.add(WalletSection(
          address: _address,
          wallets: _wallets ?? [],
          setAddress: setAddress,
          setAppState: setAppState,
        ));
      }
      tabsHeader.add(const Tab(
        icon: Icon(Icons.settings),
      ));
      tabsContent.add(SettingSection(
        user: _user,
        setUser: setUser,
        wallets: _wallets,
        setWallets: setWallets,
        setAppState: setAppState,
      ));
      tabsHeader.add(const Tab(
        icon: Icon(Icons.map),
      ));
      tabsContent.add(const MapSection());
    }

    return DefaultTabController(
        initialIndex: 0,
        length: tabsHeader.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            bottom: TabBar(tabs: tabsHeader),
          ),
          body: TabBarView(children: tabsContent),
        ));

    
    // This method is rerun every time setState is called, (like _incrementCounter)
    // return DefaultTabController(
    //   initialIndex: 0,
    //   length: tabsHeader.length,
    //   child: Scaffold(
    //     //extendBodyBehindAppBar: true,
    //     appBar: AppBar(
    //       backgroundColor: const Color.fromRGBO(0, 49, 124, 0.5),
    //       centerTitle: true,
    //       title: Text(widget.title),
    //       bottom: TabBar(tabs: tabsHeader),
    //       titleTextStyle: const TextStyle(
    //         color: Color.fromRGBO(240, 240, 240, 0.9),
    //         fontSize: 30.0,
    //       ),
    //     ),
    //     body: Container(
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           image: AssetImage(getAsset("BGHANS.jpg")),
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //       child: TabBarView(children: tabsContent),
    //     ),
    //   )
    // );
  }
}
