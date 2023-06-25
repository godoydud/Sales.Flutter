import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Listagem de Produtos'),
              onPressed: () {
                Navigator.pushNamed(context, '/products');
              },
            ),
            ElevatedButton(
              child: Text('Listagem de Comissões'),
              onPressed: () {
                Navigator.pushNamed(context, '/comissions');
              },
            ),
          ],
        ),
      ),
    );
  }
}

