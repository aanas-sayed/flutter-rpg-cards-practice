import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rpg/models/skill.dart';
import 'package:flutter_rpg/models/stats.dart';
import 'package:flutter_rpg/models/vocation.dart';

class Character with Stats {
  Character({
    required this.name,
    required this.slogan,
    required this.vocation,
    required this.id,
  });

  final String name;
  final String slogan;
  final Vocation vocation;
  final Set<Skill> skills = {};
  final String id;
  bool _isFav = false;

  bool get isFav => _isFav;

  void toggleIsFav() {
    _isFav = !_isFav;
  }

  void updateSkills(Skill skill) {
    skills.clear();
    skills.add(skill);
  }

  //character to firestore (map)
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'slogan': slogan,
      'isFav': _isFav,
      'vocation': vocation.toString(),
      'skills': skills.map((s) => s.id).toList(),
      'stats': statsAsMap,
      'points': points,
    };
  }

  //character from firestore
  factory Character.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    //get data from snapshot
    final data = snapshot.data()!;

    //make Character instance
    Character character = Character(
      name: data['name'],
      slogan: data['slogan'],
      id: snapshot.id,
      vocation:
          Vocation.values.firstWhere((v) => v.toString() == data['vocation']),
    );

    //update skill
    for (String id in data['skills']) {
      Skill skill = allSkills.firstWhere((s) => s.id == id);
      character.updateSkills(skill);
    }

    //set isFav
    if (data['isFav'] == true) {
      character.toggleIsFav();
    }

    // assign stats and points

    character.setStats(points: data['points'], stats: data['stats']);

    return character;
  }
}
