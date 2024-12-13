import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pizza.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter JSON Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Menghilangkan debug banner
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Pizza> myPizzas = []; // List untuk menyimpan objek Pizza
  int appCounter = 0; // Counter untuk tracking jumlah membuka aplikasi

  @override
  void initState() {
    super.initState();
    readJsonFile().then((value) {
      setState(() {
        myPizzas = value;
      });
    });
    readAndWritePreference(); // Memanggil SharedPreferences saat initState
  }

  Future<List<Pizza>> readJsonFile() async {
    String myString = await DefaultAssetBundle.of(context)
        .loadString('assets/pizzalist.json');
    List pizzaMapList = jsonDecode(myString); // Decode JSON menjadi Map
    List<Pizza> pizzas = [];
    for (var pizza in pizzaMapList) {
      pizzas.add(Pizza.fromJson(pizza)); // Konversi Map menjadi objek Pizza
    }

    // Konversi daftar pizza ke JSON dan cetak ke konsol
    String json = convertToJSON(pizzas);
    print(json);

    return pizzas;
  }

  Future readAndWritePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appCounter = prefs.getInt('appCounter') ?? 0;
    appCounter++;
    await prefs.setInt('appCounter', appCounter);
    setState(() {
      appCounter = appCounter;
    });
  }

  Future deletePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      appCounter = 0;
    });
  }

  String convertToJSON(List<Pizza> pizzas) {
    return jsonEncode(pizzas.map((pizza) => pizza.toJson()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JSON',
          style: TextStyle(
            color: Colors.white, // Warna teks
          ),
        ),
        backgroundColor: Colors.blue, // Warna seluruh latar belakang AppBar
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                  'You have opened the app $appCounter times.'),
              ElevatedButton(
                onPressed: () {
                  deletePreference();
                },
                child: Text('Reset counter'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: myPizzas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(myPizzas[index].pizzaName),
                      subtitle: Text(
                        '${myPizzas[index].description} - €${myPizzas[index].price.toStringAsFixed(2)}',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}