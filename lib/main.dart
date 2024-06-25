import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/providers/drawer_provider.dart';
import 'package:price/providers/menu_provider.dart';
import 'package:price/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MenuProvider()),
      ChangeNotifierProvider(
        create: (context) => DrawerProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '원자재 가격 모니터링',
        theme: ThemeData.dark().copyWith(
            appBarTheme: AppBarTheme(backgroundColor: bgColor, elevation: 0),
            scaffoldBackgroundColor: bgColor,
            primaryColor: primaryColor,
            dialogBackgroundColor: secondaryColor,
            textTheme:
                GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
                    .apply(bodyColor: Colors.white),
            canvasColor: secondaryColor),
        home: HomeScreen(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ]);
  }
}
