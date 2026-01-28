import 'package:flutter/material.dart';
import 'inscription.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';
import 'mynotespages.dart'; 

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
  final username = usernameController.text.trim();
  final password = passwordController.text.trim();

  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Remplis tous les champs !")),
    );
    return;
  }

try {
    final response = await Supabase.instance.client
        .from('user')
        .select()
        .eq('username', username)
        .eq('password', password)
        .maybeSingle();

    if (response != null) {
     
      final int userId = response['id_user']; 

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connexion réussie")),
      );

     
      goToNotesPage(userId);
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Identifiants incorrects")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erreur de connexion")),
    );
  }
}


  void goToInscription() {
     
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const InscriptionPage(), 
        ),
      );
    }

void goToNotesPage(int id_user) {
  Navigator.pushReplacement( 
    context,
    MaterialPageRoute(
      builder: (context) => Mynotespages(
        title: 'SupaNotes Flutter Home Page', 
        id_user: id_user
      ), 
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),

      body: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Nom d'utilisateur",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: login,
              child: const Text("Se connecter"),
            ),

            const SizedBox(height: 15), 

        
            ElevatedButton(
              onPressed: goToInscription,
              child: const Text("S'inscrire"),
             
            ),
          ],
        ),
      ),
    );
  }
}