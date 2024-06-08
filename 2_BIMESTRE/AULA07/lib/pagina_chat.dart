import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/mensagens.dart';

class PaginaChat extends StatefulWidget {
  final String nomeSala;
  const PaginaChat({super.key, required this.nomeSala});

  @override
  State<PaginaChat> createState() => _PaginaChatState();
}

class _PaginaChatState extends State<PaginaChat> {
  bool usuarioIsAdm = false;
  final emailUsuario = FirebaseAuth.instance.currentUser!.email;
  TextEditingController _controladorInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.nomeSala)
            .collection('menssagens')
            .orderBy('criadoEm', descending: false)
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

          final listaMensagens = snapshot.data!.docs;

          print(listaMensagens.first.data());

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
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: listaMensagens.length,
                    itemBuilder: (context, index) {
                      return Mensagens(
                        nomeUsuario: listaMensagens[index].data()['email'],
                        conteudoMensagem: listaMensagens[index].data()['conteudo'],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('usuarios')
                        .where('email', isEqualTo: emailUsuario)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.hasData) {
                        final dadosUsuario = snapshot.data!.docs.first.data();

                        if (dadosUsuario.isNotEmpty && dadosUsuario['isAdm']) {
                          return Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: _controladorInput,
                                )),
                                IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('chats')
                                        .doc(widget.nomeSala)
                                        .collection('menssagens')
                                        .add({
                                      'conteudo': _controladorInput.text,
                                      'email': emailUsuario,
                                      'criadoEm': Timestamp.now(),
                                    });
                                  },
                                  icon: const Icon(Icons.send),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                        // usuarioIsAdm = dadosUsuario['adm'];
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
