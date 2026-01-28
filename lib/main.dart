import 'package:flutter/material.dart';
import 'package:supanotes_flutter/inscription.dart';
import 'connexion.dart';
import 'mynotespages.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';





Future<void> main() async {
  await Supabase.initialize(
    url: 'https://bmcexxoexapamffifsqs.supabase.co',
    anonKey: 'sb_publishable_xy9yES1qX2UQ-S-2Msww7w_d3ggCmnu',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SupaNotes Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme(
        primary: Colors.yellow, 
        onPrimary: Colors.white,
        secondary: Colors.amberAccent,
        onSecondary: Colors.white,
        error: Colors.deepOrange,
        onError: Colors.deepOrange,
        surface: Colors.white,
        onSurface: Colors.black87,
        brightness: Brightness.light,
        ),
          appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,  
          foregroundColor: Colors.yellow,   
          elevation: 2,
          ),
      ),

      

      routes: <String, WidgetBuilder>{
      '/route1': (BuildContext context) => ConnexionPage(),
      '/route2': (BuildContext context) => InscriptionPage(),
      },

       // home: const Mynotespages(title: 'SupaNotes Flutter Home Page'),
       home: const ConnexionPage(),
    );
  }
}