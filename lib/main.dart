import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
late Box notesBox; //Open the box for storing notes

@override
  void initState() {

    super.initState();
    notesBox = Hive.box('notes'); //opens up the box
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Text("Notes"),
        backgroundColor: Colors.amber,),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                  child: Padding(padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    print("Added Note");
                      }, child: Text("Add Note")
              )
            ),
          ),
        ],
      ),
    );
  }
}

class NotePage extends StatelessWidget {
  const NotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(padding: EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyHomePage(title: "Home")
                  ),
                );
              }, child: Text("Back"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}