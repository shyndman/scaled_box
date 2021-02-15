import 'package:flutter/material.dart';
import 'package:scaled_box/scaled_box.dart';

void main() {
  runApp(ScaledBoxExampleApp());
}

const backgroundColor = Color(0xff101318);

class ScaledBoxExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const hydrogen = AtomicElement(
      color: Color(0xff51ee60),
      number: 1,
      symbol: 'H',
      name: 'Hydrogen',
      mass: '1.008',
    );

    return Container(
      color: backgroundColor,
      child: DefaultTextStyle(
        style: TextStyle(height: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (double scale = 3.0; scale > 0.5; scale -= 0.5) ...[
              ScaledBox(scale: scale, child: hydrogen),
              SizedBox(width: 12 * (scale / 3)),
            ],
          ],
        ),
      ),
    );
  }
}

class AtomicElement extends StatelessWidget {
  const AtomicElement({
    Key key,
    this.color,
    this.number,
    this.symbol,
    this.name,
    this.mass,
  }) : super(key: key);

  final Color color;
  final int number;
  final String symbol;
  final String name;
  final String mass;

  @override
  Widget build(BuildContext context) {
    final shadow = BoxShadow(color: color, offset: Offset.zero, blurRadius: 4);
    final textStyle = TextStyle(
      color: color,
      shadows: [shadow],
    );

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2.0),
        boxShadow: [shadow],
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(6, 4, 0, 0),
            child: Text(
              '$number',
              style: textStyle.copyWith(fontSize: 8),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              symbol,
              style: textStyle.copyWith(fontSize: 28),
              textAlign: TextAlign.center,
              softWrap: false,
            ),
          ),
          Text(
            name,
            style: textStyle.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
            softWrap: false,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: Text(
              mass,
              style: textStyle.copyWith(fontSize: 6),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class ScaledBoxExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scaled Box Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ScaledBoxExample(),
    );
  }
}
