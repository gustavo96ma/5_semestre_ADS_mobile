import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'pagina_chat.dart';

class PaginaListaDeChats extends StatefulWidget {
  const PaginaListaDeChats({super.key});

  @override
  State<PaginaListaDeChats> createState() => _PaginaListaDeChatsState();
}

class _PaginaListaDeChatsState extends State<PaginaListaDeChats> {
  
  void configuraNotificacoes(listaChats, usuarioAutenticado)async {
    final firebaseMessageria = FirebaseMessaging.instance;
    await firebaseMessageria.requestPermission();

    for (var documento in listaChats){
      for (var email in documento['usuarios']){
        if (email == usuarioAutenticado.email){
          firebaseMessageria.subscribeToTopic(documento.id);
        }
      }
    }

  }

  // mudar regras de uso do firestore no firebase console
  @override
  Widget build(BuildContext context) {
    final usuarioAutenticado = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('usuarios', arrayContains: usuarioAutenticado!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Nenhum chat foi encontrado!'),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar os chats!'),
            );
          }

          final listaChats = snapshot.data!.docs;

          configuraNotificacoes(listaChats, usuarioAutenticado);

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
                  title: Text(listaChats[index].id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaginaChat(nomeSala: listaChats[index].id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        });
  }
}
