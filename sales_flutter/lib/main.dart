import 'package:flutter/material.dart';
import 'package:sales_flutter/ComissionFormScreen.dart';
import 'package:sales_flutter/LoginPage.dart';
import 'package:sales_flutter/ProductFormScreen.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MaterialApp(
    title: 'Meu App',
    theme: ThemeData(primarySwatch: Colors.blue),
    initialRoute: '/',
    routes: {
      '/': (context) => ComissionFormScreen(),
    },
  ));
}
