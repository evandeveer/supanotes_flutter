import 'package:flutter/material.dart';
import 'package:supanotes_flutter/notes2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class Mynotespages extends StatefulWidget {
  const Mynotespages({super.key, required this.title});

  final String title;

  @override
  State<Mynotespages> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Mynotespages> {
  List<Note> notesData = [];

  final supabase = Supabase.instance.client;

  void recupNotes() async {
    final data = await supabase
    .from('notes')
    .select('id, date, contenu, id_type, type(id_type, libelle)')
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
      'id_type': 1,
    });

    recupNotes();

    setState(() {});
  }

  void openAddNote() {
    String contenu = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une note'),
          content: TextField(
            onChanged: (value) {
              contenu = value;
            },
            decoration: InputDecoration(hintText: 'Ecire votre note ici'),
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
                  1,
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
    String contenu = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('modifier la note'),
          content: TextField(
            controller: TextEditingController(text: note.contenu),
            onChanged: (value) {
              contenu = value;
            },
            decoration: InputDecoration(hintText: 'modifer votre note ici'),
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
                    .update({'contenu': contenu})
                    .eq('id', note.id);

                setState(() {
                  note.contenu = contenu;
                });

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

  Card cardBuilder(Note note) {
    return Card(
      margin: EdgeInsets.all(10),

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

              Text("   ${note.libelle}", style: TextStyle(color: Colors.blue)),

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
