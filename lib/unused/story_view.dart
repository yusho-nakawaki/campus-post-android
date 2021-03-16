import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'dart:math';

//ah ha
//ah ha
class StoryView extends HookWidget {
  StoryView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController(viewportFraction: 0.6);

    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          itemCount: 7,
          controller: _pageController,
          itemBuilder: (context, index) {
            return Transformer(
              index: index,
              pageController: _pageController,
              length: 7,
            );
          },
        ),
      ),
    );
  }
}

class Transformer extends HookWidget {
  const Transformer({Key key, this.pageController, this.index, this.length})
      : super(key: key);
  final int index;
  final int length;
  final PageController pageController;


  @override
  Widget build(BuildContext context) {
    final day = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final _value = useState<double>(0);

    VoidCallback _update = () {
      _value.value = index -
          pageController.offset /
              pageController.position.maxScrollExtent *
              (length - 1);
    };

    useEffect(() {
      pageController.addListener(_update);
      return () => pageController.removeListener(_update);
    }, []);

    final _threeD = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(-0.2 * pi * _value.value);

    return Transform(
      alignment: _value.value > 0
          ? FractionalOffset.centerLeft
          : FractionalOffset.centerRight,
      transform: _threeD,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.black26,
        ),
        child: Center(child: Text(day[index % 8])),
      ),
    );
  }
}