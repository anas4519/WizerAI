import 'package:career_counsellor/auth/auth_gate.dart';
import 'package:career_counsellor/bloc/degree_exploration/degree_exploration_bloc.dart';
import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/onboarding_screen/onboarding_page.dart';
import 'package:career_counsellor/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('user_box');
  await Hive.openBox('ai_cache');
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));

    Future<bool> isFirstLaunch() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isFirstLaunch') ?? true;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<DegreeExplorationBloc>(
          create: (context) => DegreeExplorationBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[200],
          primaryColor: Colors.pink,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.montserratTextTheme(),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey[200],
          ),
          appBarTheme: AppBarTheme(backgroundColor: Colors.grey[200]),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.pink,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
          textTheme: GoogleFonts.montserratTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme),
          useMaterial3: true,
          // appBarTheme: const AppBarTheme(
          //   backgroundColor: Colors.black
          // )
        ),
        themeMode: ThemeMode.system,
        home: FutureBuilder<bool>(
          future: isFirstLaunch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            } else {
              return snapshot.data! ? const OnboardingPage() : const AuthGate();
            }
          },
        ),
        // home: LoginPage(),
      ),
    );
  }
}
