import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaginaChat extends StatefulWidget {
  const PaginaChat({super.key});

  @override
  State<PaginaChat> createState() => _PaginaChatState();
}

class _PaginaChatState extends State<PaginaChat> {
  bool usuarioIsAdm = false;

  @override
  Future<void> initState() {
    super.initState();
    usuarioIsAdm = _isAdministrador().then((value) => usuarioIsAdm = value);
  }

  Future<bool> _isAdministrador() async {
    final emailUsuario = FirebaseAuth.instance.currentUser!.email;

    QuerySnapshot usuarios = await FirebaseFirestore.instance.collection('usuarios').get();

    for (var usuario in usuarios.docs) {
      if (usuario.data() != null) {
        final dadosUsuario = usuario.data() as Map<String, dynamic>;

        if (dadosUsuario['email'] == emailUsuario) {
          return dadosUsuario['isAdm'];
        }
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Unicv app',
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(children: [
        // Mensagens(),
        if (usuarioIsAdm) const TextField(),
      ]),
    );
  }
}
