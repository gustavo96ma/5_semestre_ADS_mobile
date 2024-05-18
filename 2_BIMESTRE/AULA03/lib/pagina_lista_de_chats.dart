import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaginaListaDeChats extends StatefulWidget {
  const PaginaListaDeChats({super.key});

  @override
  State<PaginaListaDeChats> createState() => _PaginaListaDeChatsState();
}

class _PaginaListaDeChatsState extends State<PaginaListaDeChats> {
  final List<Chat> listaChats = [];

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
      body: ListView.builder(
        itemCount: listaChats.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.all(8),
            title: Text(listaChats[index].nome),
            subtitle: Text('Última mensagem: ${listaChats[index].mensagens['conteudo']}'),
          );
        },
      ),
    );
  }
}
