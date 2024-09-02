// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FourHomePage extends StatefulWidget {
  const FourHomePage({super.key});

  @override
  State<FourHomePage> createState() => _FourHomePageState();
}

//TICKER PROVIDER STATE MIXIN CAN SYNC WITH MORE THAN ONE ANIMATION CONTROLLER
class _FourHomePageState extends State<FourHomePage> with TickerProviderStateMixin {
  static const people = [
    Person(
      name: 'teste',
      age: 22,
      emoji: '🤶',
    ),
    Person(
      name: 'teste',
      age: 21,
      emoji: '👨‍🎓',
    ),
    Person(
      name: 'teste',
      age: 26,
      emoji: '👳‍♂️',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: people.length,
          itemBuilder: (context, index) => ListTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailsPage(person: people[index]),
              ),
            ),
            leading: Hero(
              tag: people[index].name,
              child: Text(people[index].emoji),
            ),
            title: Text(people[index].name),
            subtitle: Text('${people[index].age} years old'),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
          ),
        ),
      ),
    );
  }
}

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;
  const Person({
    required this.name,
    required this.age,
    required this.emoji,
  });
}

class DetailsPage extends StatelessWidget {
  final Person person;
  const DetailsPage({
    Key? key,
    required this.person,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
            switch (flightDirection) {
              case HeroFlightDirection.push:
                return Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                    scale: animation.drive(
                      Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).chain(
                        CurveTween(curve: Curves.fastOutSlowIn),
                      ),
                    ),
                    child: toHeroContext.widget,
                  ),
                );
              case HeroFlightDirection.pop:
                return Material(
                  color: Colors.transparent,
                  child: fromHeroContext.widget,
                );
            }
          },
          tag: person.name,
          child: Text(person.emoji),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(person.name),
          const SizedBox(height: 20),
          Text('${person.age} years old'),
        ],
      ),
    );
  }
}
