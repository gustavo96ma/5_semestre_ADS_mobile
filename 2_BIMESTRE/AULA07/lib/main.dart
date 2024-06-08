import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tela_login2/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tela_login2/pagina_lista_de_chats.dart';

import 'pagina_login.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MeuApp());
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  // TODO: lembrar de descomentar quando for versao final
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unicv app',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return const PaginaListaDeChats();
          }
          return const PaginaLogin();
        },
      ),
    );
  }
}
