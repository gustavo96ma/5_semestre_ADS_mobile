import 'package:flutter/material.dart';

import 'pagina_lista_de_chats.dart';

void main() {
  runApp(const TelaLogin());
}

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _chaveForm = GlobalKey<FormState>();
  String _emailInserido = '';
  String _senhaInserida = '';
  String _nomeUsuarioInserido = '';
  bool _modoLogin = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  width: 200,
                  margin: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.message,
                    size: 200,
                    color: Colors.white,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _chaveForm,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Endereço de Email'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (valorEmail) {
                              if (valorEmail == null ||
                                  valorEmail.trim().isEmpty ||
                                  !valorEmail.contains('@')) {
                                return 'Por favor, insira um endereço de email válido.';
                              }
                              return null;
                            },
                            onSaved: (valor) {
                              _emailInserido = valor!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Senha'),
                            obscureText: true,
                            validator: (valorSenha) {
                              if (valorSenha == null || valorSenha.trim().length < 6) {
                                return 'A senha deve ter pelo menos 6 caracteres.';
                              }
                              return null;
                            },
                            onSaved: (valor) {
                              _senhaInserida = valor!;
                            },
                          ),
                          if (!_modoLogin)
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Nome do Usuário'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null || value.trim().length < 4) {
                                  return 'Por favor, insira pelo menos 4 caracteres';
                                }
                                return null;
                              },
                              onSaved: (valor) {
                                _nomeUsuarioInserido = valor!;
                              },
                            ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (!_chaveForm.currentState!.validate()) {
                                    return;
                                  }

                                  _chaveForm.currentState!.save();

                                  try {
                                    if (_modoLogin) {
                                      print('''Usuário com email: $_emailInserido 
                                    e senha: $_senhaInserida autenticado''');

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PaginaListaDeChats(),
                                        ),
                                      );
                                    } else {
                                      print('''Usuário com email: $_emailInserido,
                                       senha: $_senhaInserida e 
                                       usuário: $_nomeUsuarioInserido Criado com sucesso!''');
                                    }
                                  } catch (_) {
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Falha na autenticação'),
                                      ),
                                    );
                                  }
                                },
                                child: Text(_modoLogin ? 'Entrar' : 'Salvar'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _modoLogin = !_modoLogin;
                                  });
                                },
                                child: Text(_modoLogin ? 'Cadastrar' : 'Já tenho uma Conta'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
        );
      }),
    );
  }
}
