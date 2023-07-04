import 'package:flutter/material.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  String? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter QR Code"),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              onChanged: (val) => setState(() => data = val),
              decoration: const InputDecoration(
                labelText: 'Type your data',
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}