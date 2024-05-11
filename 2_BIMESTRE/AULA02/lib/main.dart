import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tela_login2/firebase_options.dart';

import 'pagina_login.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PaginaLogin());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unicv app',
      home: StreamBuilder(

          //TODO: CONTINUAR DAQUI
          ),
    );
  }
}
