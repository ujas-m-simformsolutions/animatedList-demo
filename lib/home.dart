import 'package:animated_list_demo/text_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final _key = GlobalKey<FormState>();
  final listKey = GlobalKey<AnimatedListState>();
  TextEditingController controller = TextEditingController();
  TextEditingController indexController = TextEditingController();
  List<String> text = [];
  AnimationController animationController;
  Animation<Offset> offsetAnimation;

  void loadItems() {
    final fetchedList = ['banana', 'apple', 'peach', 'mangoes', 'adsd'];
    var future = Future(() {});
    for (var i = 0; i < fetchedList.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 100), () {
          text.add(fetchedList[i]);
          listKey.currentState.insertItem(text.length - 1);
        });
      });
    }
  }

  void tapAnywhere() {
    FocusScope.of(context).requestFocus(
      FocusNode(),
    );
  }

  void removeElement(int index) {
    listKey.currentState.removeItem(
      index,
      (context, animation) => ScaleTransition(
        scale: animation.drive(
          Tween(begin: 0, end: 1),
        ),
      ),
      duration: Duration(seconds: 0),
    );

    setState(() {
      text.removeAt(index);
    });
    print(text);
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward();
    offsetAnimation = Tween<Offset>(
      begin: Offset(-0.5, 0.0),
      end: Offset(0.5, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInCubic,
    ));
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
        ),
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _key,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'text',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: TextFormField(
                    controller: indexController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'index',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ElevatedButton(
                  onPressed: () {
                    listKey.currentState.insertItem(
                        int.parse(indexController.text) - 1,
                        duration: Duration(seconds: 1));
                    text.insert(
                        int.parse(indexController.text) - 1, controller.text);
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                ),
                Container(
                  //height: 300,
                  child: AnimatedList(
                    key: listKey,
                    initialItemCount: text.length,
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
                        child: Dismissible(
                          key: UniqueKey(),
                          child: TextCard(
                            key: UniqueKey(),
                            text: text[index],
                          ),
                        ),
                      );
                    },
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
