import 'package:animated_list_demo/text_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'fruits.dart';

//https://medium.com/flutter-community/updating-data-in-an-animatedlist-in-flutter-9dbfb136e515
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final listKey = GlobalKey<AnimatedListState>();
  TextEditingController controller = TextEditingController();
  TextEditingController indexController = TextEditingController();
  List<Fruit> fruits = [];
  late AnimationController animationController;
  late Animation<double> offsetAnimation;
  AnimationController? rotateController;
  AnimationController? scaleController;
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

  void tapAnywhere() {
    FocusScope.of(context).requestFocus(
      FocusNode(),
    );
  }

// explain
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
        child: TextCard(
          fruit: removedElement,
          removeFunction: (){},
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
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward();
    offsetAnimation =
        Tween<double>(begin: -0.5, end: 0).animate(animationController);
    rotateController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();
    scaleController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapAnywhere,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[400],
          title: Text('Animated List Demo'),
          actions: [
            IconButton(
                icon: Icon(Icons.sort_by_alpha),
                onPressed: () async {
                  animationController.reset();
                  setState(() {
                    fruits.sort((a, b) => a.name.compareTo(b.name));
                  });
                  await animationController.forward();
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addElement,
          child: Icon(Icons.add),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                      child: AnimatedBuilder(
                        animation: offsetAnimation,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.0002)
                              ..rotateX(-1 * math.pi * offsetAnimation.value),
                            alignment: Alignment.center,
                            child: TextCard(
                              fruit: fruits[index],
                              removeFunction: () {
                                removeElement(index);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
