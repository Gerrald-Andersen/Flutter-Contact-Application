import 'package:flutter/material.dart';

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  late Future waitForFiveSecondsFuture;

  @override
  void initState() {
    super.initState();
    waitForFiveSecondsFuture = Future.delayed(
      const Duration(
        seconds: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Future Page",
        ),
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder(
          future: waitForFiveSecondsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Text("Selesai dan ada data");
              } else {
                return Text("Selesai dan tidak ada data");
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
