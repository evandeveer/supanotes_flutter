import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class Note {
  int id;
  String date;
  String contenu;
  int id_type;
  String? libelle;
  String? couleur; 

  Note({
    required this.id,
    required this.date,
    required this.contenu,
    required this.id_type,
    this.libelle,
    required this.couleur, 
  });

  Note copyWith({
    int? id,
    String? date,
    String? contenu,
    int? id_type,
    String? libelle,
    String? couleur, 
  }) {
    return Note(
      id: id ?? this.id,
      date: date ?? this.date,
      contenu: contenu ?? this.contenu,
      id_type: id_type ?? this.id_type,
      libelle: libelle ?? this.libelle,
      couleur: couleur ?? this.couleur, 
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'contenu': contenu,
      'id_type': id_type,
      'libelle': libelle,
      'couleur': couleur, 
    };
  }

  final supabase = Supabase.instance.client;

factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'].toInt() as int,
      date: map['date'] as String,
      contenu: map['contenu'] as String,
      id_type: map['id_type'] as int,
      libelle: map['type']?['libelle'] as String?,
      couleur: map['type']?['couleur'] as String?, 
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() =>
      'Note(id: $id, date: $date, contenu: $contenu, type: $id_type, libelle: $libelle, couleur: $couleur)'; 

  @override
  bool operator ==(covariant Note other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.contenu == contenu &&
        other.id_type == id_type &&
        other.libelle == libelle &&
        other.couleur == couleur; 
  }

  @override
  int get hashCode =>
      id.hashCode ^
      date.hashCode ^
      contenu.hashCode ^
      id_type.hashCode ^
      (libelle?.hashCode ?? 0) ^
      couleur.hashCode; 
}