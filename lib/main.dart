import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Path Provider',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Path Provider'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String documentsPath = '';
  String tempPath = '';
  late File myFile;
  String fileText = '';

  Future getPaths() async{
    final docDir = await getApplicationDocumentsDirectory();
    final tempDir = await getTemporaryDirectory();
    setState(() {
      documentsPath = docDir.path;
      tempPath = tempDir.path;
    });
  }
  Future<bool> writeFile() async{
    try{
      await myFile.writeAsString('Margherita, Capricciosa, Napoli');
      return true;
    }catch(e){
      return false;
    }
  }
  Future<bool> readFile() async{
    try{
      String fileContent = await myFile.readAsString();
      setState(() {
        fileText =fileContent;
      });
      return true;
    }catch(e){
      return false;
    }
  }

  @override
  void initState(){
    super.initState();
    getPaths().then((_){
      myFile = File('$documentsPath/pizzas.txt');
      writeFile();
    });
  }


 @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Path Provider')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Doc path: $documentsPath'),
          Text('Temp path $tempPath'),
          ElevatedButton(
            onPressed: () => readFile(), 
            child: const Text('Read File')
          ),
          Text(fileText),
        ],
      ),
    );
  }
}

Future<String> readFromSecureStorage() async {
String secret = await storage.read(key: myKey) ?? '';
return secret;
}