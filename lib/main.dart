import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/routes/routes.dart';
import 'core/util/app_color.dart';
import 'core/util/provider.dart';
import 'core/util/responsive.dart';
import 'core/util/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              Responsive().init(constraints, orientation);
              return MaterialApp(
                title: 'ClanOfPets',
                theme: ThemeData(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  appBarTheme: const AppBarTheme(surfaceTintColor: AppColor.white),
                  colorScheme: ColorScheme.fromSeed(seedColor: AppColor.appPrimary),
                ),
                debugShowCheckedModeBanner: false,
                initialRoute: AppRoutes.initial,
                routes: AppRoutes.routes,
              );
            },
          );
        },
      ),
    );
  }
}
