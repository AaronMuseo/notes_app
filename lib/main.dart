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


  void addnote() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("New Note"),
            content: TextField(controller: controller,
                decoration: InputDecoration(hintText: 'What\'s on your mind?')),
            actions: [
              TextButton(onPressed: () {
                if (controller.text.isNotEmpty) {
                  notesBox.add(
                      controller.text); // Saves note to the Hive box 'notes'
                  setState(() {}); // refresh UI
                }
                Navigator.pop(context);
              },
                  child: Text("Save"))
            ],
          ),
    );
  }

  void deletenote(int index) {
    notesBox.deleteAt(index);
    setState(() {});
  }

  void editnote(int index) {
    String currentNote = notesBox.getAt(index);
    TextEditingController controller = TextEditingController(text: currentNote);

    showDialog(context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Edit Note'),
            content: TextField(controller: controller),
            actions: [
              ElevatedButton(onPressed: () {
                if (controller.text.isNotEmpty) {
                  notesBox.putAt(index, controller.text);
                  setState(() {});
                }
                Navigator.pop(context);
              }, child: Text('Save')
              )
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes'), backgroundColor: Colors.amber,),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.5,
        ),
        itemCount: notesBox.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: () => editnote(index),
            child: Card(
              color: Colors.yellow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    notesBox.getAt(index),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  IconButton(onPressed: () => deletenote(index),
                      icon: const Icon(Icons.delete, color: Colors.black)
                  ),
                  IconButton(onPressed: (){

                    //Make note favourite

                  }, icon: Icon(Icons.favorite_outline)),


                  ],
                )
              ]
              )
            )
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.amberAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: (){

              //Add functonality to favourite button

            }, icon: Icon(Icons.favorite)),
            IconButton(onPressed: (){
              setState(() {

              });
              //Add functionality to dark mode button

            }, icon: Icon(Icons.dark_mode)),
            Spacer(),
            ElevatedButton(onPressed: addnote,
                child: Icon(Icons.add))
          ],
        )

      ),

    );
  }
}













