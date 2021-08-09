import 'package:animated_list_demo/fruits.dart';
import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  final Fruit fruit;
  final Function removeFunction;

  TextCard({
  required this.fruit,
  required this.removeFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              CircleAvatar(
                child: Text(
                  fruit.emoji,
                  style: TextStyle(fontSize: 40),
                ),
                backgroundColor: Color(0xff36c5f0),
                minRadius: 30,
              ),
              SizedBox(width: 50),
              SizedBox(
                width: 130,
                child: Text(
                  fruit.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.blueGrey,
                ),
                onPressed: removeFunction as void Function(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
