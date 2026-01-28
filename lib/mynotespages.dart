

import 'package:flutter/material.dart';
import 'package:supanotes_flutter/notes2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class Mynotespages extends StatefulWidget {
  const Mynotespages({super.key, required this.title, required this.id_user});

  final String title;
  final int id_user;

  @override
  State<Mynotespages> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Mynotespages> {
  List<Note> notesData = [];



  final supabase = Supabase.instance.client;

  void recupNotes() async {
    final data = await supabase
    .from('notes')
    .select('id, date, contenu, id_type, type(id_type, libelle, couleur)')
    .eq('id_user', widget.id_user)
    .order('id', ascending: true);

    notesData = data.map((item) => Note.fromMap(item)).toList();

    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    recupNotes();
  }

  void insertNote(date, contenu, id_type) async {
    await supabase.from('notes').insert({
      'date': date,
      'contenu': contenu,
      'id_type': id_type,
      'id_user': widget.id_user,
    });

    recupNotes();

    setState(() {});
  }

void openAddNote() {
  String contenu = '';
  String typeNote = '1'; 

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Ajouter une note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                contenu = value;
              },
              decoration: InputDecoration(hintText: 'Écrire votre note ici'),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              
              items: const [
                DropdownMenuItem(value: '1', child: Text('Basique')),
                DropdownMenuItem(value: '2', child: Text('Important')),
                DropdownMenuItem(value: '3', child: Text('To-do')),
              ],
              onChanged: (value) {
                typeNote = value!;
              },
              decoration: InputDecoration(
                labelText: 'Type de note',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Annuler'),
          ),

          TextButton(
            onPressed: () {
              insertNote(
                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                contenu,
                int.parse(typeNote), 
              );

              Navigator.of(context).pop();
            },
            child: Text('Ajouter'),
          ),
        ],
      );
    },
  );
}

void openEditNote(Note note) {
  String contenu = note.contenu;
  String typeNote = note.id_type.toString();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Modifier la note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: contenu),
              onChanged: (value) {
                contenu = value;
              },
              decoration: InputDecoration(hintText: 'Modifier votre note ici'),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
             
              items: const [
                DropdownMenuItem(value: '1', child: Text('Basique')),
                DropdownMenuItem(value: '2', child: Text('Important')),
                DropdownMenuItem(value: '3', child: Text('To-do')),
              ],
              onChanged: (value) {
                typeNote = value!;
              },
              decoration: InputDecoration(
                labelText: 'Type de note',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await supabase
                  .from('notes')
                  .update({'contenu': contenu, 'id_type': int.parse(typeNote)})
                  .eq('id', note.id);

              setState(() {
                note.contenu = contenu;
                note.id_type = int.parse(typeNote);
              });

              recupNotes();

              Navigator.of(context).pop();  
            },
            child: Text('Modifier'),
          ),
        ],
      );
    },
  );
}

  void deleteNote(Note note) async {
    await supabase.from('notes').delete().eq('id', note.id);

    setState(() {
      notesData.remove(note);
    });
  }

    Color colorFromName(String name) {
    switch (name.toLowerCase()) {
      case 'white':
        return const Color.fromARGB(255, 212, 212, 212);
      case 'orange':
        return Colors.orange;
      case 'green':
        return const Color.fromARGB(255, 86, 228, 90);
      default:
        return const Color.fromARGB(255, 255, 255, 255);
    }
  }

  Card cardBuilder(Note note) {
    return Card(
      margin: EdgeInsets.all(10),
      color: colorFromName(note.couleur ?? 'white'),

      elevation: 3,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(note.contenu),
          ),

          Row(
            children: [
              Text("   ${note.date}", style: TextStyle(color: Colors.blue)),

              Spacer(),

              Text("   ${note.libelle}", style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),

              Spacer(),

              IconButton(
                icon: Icon(Icons.edit_document, color: Colors.green),
                onPressed: () {
                  openEditNote(note);
                },
              ),

              IconButton(
                icon: Icon(Icons.delete_forever, color: Colors.red),
                onPressed: () {
                  deleteNote(note);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/images/supanotes.png'),
        ),
        title: Text('Flutter SupaNotes'),

        actions: [
          IconButton(
            icon: const Icon(Icons.note_add),
            tooltip: 'Ajouter une note',
            onPressed: () {
              openAddNote();
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [for (Note note in notesData) cardBuilder(note)],
        ),
      ),
    );
  }
}
