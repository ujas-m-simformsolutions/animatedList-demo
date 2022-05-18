import 'dart:math' as math;

import 'package:animated_list_demo/fruit_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'fruits.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final listKey = GlobalKey<AnimatedListState>();
  List<Fruit> fruits = [];
  List<Fruit> fetchedList = [
    Fruit(
      name: 'Banana',
      emoji: '🍌',
    ),
    Fruit(
      name: 'Apple',
      emoji: '🍎',
    ),
    Fruit(
      name: 'Grape',
      emoji: '🍇',
    ),
    Fruit(
      name: 'Mango',
      emoji: '🥭',
    ),
    Fruit(
      name: 'Orange',
      emoji: '🍊',
    ),
  ];

  void loadItems() {
    var future = Future(() {});
    for (var i = 0; i < fetchedList.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 100), () {
          fruits.add(fetchedList[i]);
          listKey.currentState!.insertItem(fruits.length - 1);
        });
      });
    }
  }

  void removeElement(int index) {
    Fruit removedElement = fruits.removeAt(index);
    listKey.currentState!.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: animation.drive(
          Tween(
            begin: Offset(1.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ),
        child: FruitCard(
          fruit: removedElement,
          removeFunction: () {},
        ),
      ),
      duration: Duration(seconds: 1),
    );
  }

  void addElement() {
    var random = math.Random().nextInt(4);

    listKey.currentState!
        .insertItem(random, duration: Duration(milliseconds: 500));
    fruits.insert(random, fetchedList[random]);
  }

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text('Animated List Demo'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addElement,
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: AnimatedList(
                key: listKey,
                initialItemCount: fruits.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index, animation) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween(
                        begin: Offset(0.5, 0.0),
                        end: Offset(0, 0.0),
                      ),
                    ),
                    child: FruitCard(
                      fruit: fruits[index],
                      removeFunction: () => removeElement(index),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
