import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://10.0.2.2:7034/api';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> cadastrar() async {
    final String username = _usernameController.value.text;
    final String password = _passwordController.value.text;
    final String confirmPassword = _confirmPasswordController.value.text;

    var body = json.encode({
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword
    });

    final response = await http.post(
      Uri.parse('$apiUrl/User'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      print('Cadastro realizado com sucesso!');
      mostrarMensagem('Cadastro efetuado com sucesso');
      // Redirecionar de volta para a tela de login
      Navigator.pop(context);
    } else {
      print(
          'Erro ao realizar cadastro. Código de status: ${response.statusCode}');
    }
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome de usuário não pode ser vazio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira uma senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmar Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.value.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cadastrar(); // Chamada do método para realizar o cadastro
                  }
                },
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
