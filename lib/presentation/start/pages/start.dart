import 'package:fitness_project/presentation/start/pages/how_it_works.dart';
import 'package:fitness_project/presentation/start/pages/login.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              children: [
                const Spacer(),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.orangeAccent,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(32),
                      child: Icon(Icons.fitness_center,
                          size: 128, color: Colors.white),
                    )),
              ],
            )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Column(
                    children: [
                      Text(
                        "The Fitness Project",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Dare your friends to move",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HowItWorks(),
                          ),
                        );
                      },
                      child: const Text("Get started")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
