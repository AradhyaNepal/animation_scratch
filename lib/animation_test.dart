import 'package:flutter/material.dart';

class AnimationTestScreen extends StatefulWidget {
  const AnimationTestScreen({Key? key}) : super(key: key);

  @override
  State<AnimationTestScreen> createState() => _AnimationTestScreenState();
}

class _AnimationTestScreenState extends State<AnimationTestScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> firstBoxOffsetAnimation;
  late Animation<Offset> midBoxOffsetAnimation;
  late Animation<double> midBoxOpacityAnimation;
  late Animation<Offset> endBoxOffsetAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    final curve = Curves.easeInOut;
    firstBoxOffsetAnimation =
        Tween<Offset>(begin: const Offset(0, -500), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0,
        0.33,
        curve: curve,
      ),
    ));

    final midBoxInterval = CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.33,
        0.66,
        curve: curve,
      ),
    );
    midBoxOffsetAnimation =
        Tween<Offset>(begin: const Offset(0, 150), end: const Offset(0, 0))
            .animate(midBoxInterval);
    midBoxOpacityAnimation =
        Tween<double>(begin: 0, end: 1).animate(midBoxInterval);
    endBoxOffsetAnimation =
        Tween<Offset>(begin: const Offset(0, 500), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.66,
        1,
        curve: curve,
      ),
    ));

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                animationController.reset();
                animationController.forward();
              },
              icon: const Icon(
                Icons.play_arrow,
              )),
        ],
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            const Spacer(),
            AnimatedBuilder(
                animation: firstBoxOffsetAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: firstBoxOffsetAnimation.value,
                    child: const FirstBoxWidget(),
                  );
                }),
            const SizedBox(
              height: 30,
            ),
            AnimatedBuilder(
                animation: midBoxOffsetAnimation,
                builder: (context, child) {
                  return AnimatedBuilder(
                      animation: midBoxOpacityAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: midBoxOffsetAnimation.value,
                          child: Opacity(
                            opacity: midBoxOpacityAnimation.value,
                            child: const SecondBox(),
                          ),
                        );
                      });
                }),
            const SizedBox(
              height: 30,
            ),
            AnimatedBuilder(
                animation: endBoxOffsetAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: endBoxOffsetAnimation.value,
                    child: const LastBoxWidget(),
                  );
                }),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    ));
  }
}

class FirstBoxWidget extends StatelessWidget {
  const FirstBoxWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: const [
          Text("Login"),
          Text("Bla Bla Bla"),
        ],
      ),
    );
  }
}

class SecondBox extends StatelessWidget {
  const SecondBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        children: const [
          Text("TextField"),
          Text("Save Password"),
        ],
      ),
    );
  }
}

class LastBoxWidget extends StatelessWidget {
  const LastBoxWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(
        children: const [
          Text("Last Box"),
          Text("Bla Bla Bla"),
        ],
      ),
    );
  }
}
