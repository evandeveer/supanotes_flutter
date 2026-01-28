import 'package:flutter/material.dart';
import 'connexion.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


void register() async {
  final username = usernameController.text.trim();
  final password = passwordController.text.trim();

  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Remplis tous les champs !")),
    );
    return;
  }

  try {
    await Supabase.instance.client.from('user').insert({
      'username': username,
      'password': password,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Inscription enregistrée")),
    );

    Navigator.pop(context); 
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erreur lors de l'inscription")),
    );
  }
}

  void goToConnexion() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),

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
              onPressed: register,
              child: const Text("S'inscrire"),
            ),

            const SizedBox(height: 15),

            
            ElevatedButton(
              onPressed: goToConnexion,
              child: const Text("Déjà un compte ? Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}