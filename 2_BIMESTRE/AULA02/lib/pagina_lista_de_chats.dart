import 'package:flutter/material.dart';

class PaginaListaDeChats extends StatefulWidget {
  const PaginaListaDeChats({super.key});

  @override
  State<PaginaListaDeChats> createState() => _PaginaListaDeChatsState();
}

class _PaginaListaDeChatsState extends State<PaginaListaDeChats> {
  void adicionaChat() {
    listaChats.add(
      Chat(
        nome: '5º SEMESTRE ADS',
        mensagens: {'conteudo': 'Olá, seja bem-vindo!'},
      ),
    );
    listaChats.add(
      Chat(
        nome: '5º SEMESTRE ESW',
        mensagens: {'conteudo': 'Olá Joelma! Quer um tacacá?'},
      ),
    );
  }

  final List<Chat> listaChats = [];

  @override
  Widget build(BuildContext context) {
    adicionaChat();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Unicv app',
        ),
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

class Chat {
  final String nome;
  final Map<String, String> mensagens;

  Chat({required this.nome, required this.mensagens});
}
