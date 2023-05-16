// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({required this.name, required this.age, String? uuid})
      : uuid = uuid ?? const Uuid().v4();

  Person updated({String? name, int? age}) {
    return Person(name: name ?? this.name, age: age ?? this.age, uuid: uuid);
  }

  String get displayName => '$name ($age years old)';

  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => 'Person(name: $name, age: $age, uuid: $uuid)';
}

class DataModel extends ChangeNotifier {
  final List<Person> _people = [];

  int get count => _people.length;

  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);

  void add(Person person) {
    _people.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    _people.remove(person);
    notifyListeners();
  }

  void update(Person updatedPerson) {
    final index = _people.indexOf(updatedPerson);
    final oldPerson = _people[index];
    if (updatedPerson.name != oldPerson.name ||
        updatedPerson.age != oldPerson.age) {
      _people[index] =
          oldPerson.updated(name: updatedPerson.name, age: updatedPerson.age);
    }
    notifyListeners();
  }
}

final peopleProvider = ChangeNotifierProvider((ref) => DataModel());

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final dataModel = ref.watch(peopleProvider);
          return ListView.builder(
            itemCount: dataModel.count,
            itemBuilder: (context, index) {
              final existingPerson = dataModel.people[index];
              return GestureDetector(
                onTap: () async {
                  final updatedPerson =
                      await createOrUpatePerson(context, existingPerson);
                  if (updatedPerson != null) {
                    dataModel.update(updatedPerson);
                  }
                },
                child: ListTile(
                  title: Text(existingPerson.displayName),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPerson = await createOrUpatePerson(context);
          if (newPerson != null) ref.read(peopleProvider).add(newPerson);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

final nameController = TextEditingController();
final ageController = TextEditingController();

Future<Person?> createOrUpatePerson(BuildContext context,
    [Person? existingPerson]) {
  String? name = existingPerson?.name;
  int? age = existingPerson?.age;

  nameController.text = name ?? '';
  ageController.text = age != null ? age.toString() : '';

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a person'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                onChanged: (value) => name = value,
                decoration: const InputDecoration(labelText: 'Enter name here...'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Enter age here...'),
                onChanged: (value) {
                  age = int.tryParse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name != null && age != null) {
                  if (existingPerson != null) {
                    final updatedPerson =
                        existingPerson.updated(name: name, age: age);
                    Navigator.of(context).pop(updatedPerson);
                  } else {
                    final newPerson = Person(name: name!, age: age!);
                    Navigator.of(context).pop(newPerson);
                  }
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      });
}
