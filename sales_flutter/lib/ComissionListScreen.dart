import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sales_flutter/EditComissionScreen.dart';

const String apiUrl = 'https://10.0.2.2:7034/api';

class ComissionListScreen extends StatefulWidget {
  @override
  _ComissionListScreenState createState() => _ComissionListScreenState();
}

class _ComissionListScreenState extends State<ComissionListScreen> {
  List<dynamic> comissionList = [];

  @override
  void initState() {
    super.initState();
    fetchComissionList();
  }

  Future<void> fetchComissionList() async {
    final response = await http.get(Uri.parse('$apiUrl/Comission'));

    if (response.statusCode == 200) {
      setState(() {
        comissionList = jsonDecode(response.body);
      });
      print(comissionList);
    } else {
      print(
          'Erro ao buscar as comissões. Código de status: ${response.statusCode}');
    }
  }

  void editComission(int index) {
    final comission = comissionList[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditComissionScreen(comission: comission),
      ),
    ).then((result) {
      if (result != null) {
        // Atualizar a lista de comissões com os dados editados
        setState(() {
          comissionList[index] = result;
        });
      }
    });
  }

  void deleteComission(int index) async {
    final comission = comissionList[index];
    final response = await http.delete(
      Uri.parse('$apiUrl/Comission/${comission['id']}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        comissionList.removeAt(index);
      });
      print('Comissão excluída com sucesso!');
    } else {
      print(
          'Erro ao excluir a comissão. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Comissões'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/comissionsform');
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemCount: comissionList.length,
        itemBuilder: (BuildContext context, int index) {
          final comission = comissionList[index];
          final String name = comission['name'];
          final int percentage = comission['percentage'];

          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
                title: Text(comission['name']),
                onTap: () => editComission(index),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Nome: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(
                            text: '$name',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Porcentagem: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(
                            text: '$percentage',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteComission(index),
                )),
          );
        },
      ),
    );
  }
}
