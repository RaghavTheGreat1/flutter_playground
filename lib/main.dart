import 'package:flutter/material.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_playground/box_animation.dart';

void main() {
  runApp(const MyApp());
}

bool useSystemCursor = false;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Faker faker = Faker.instance;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: ImprovedScrolling(
          scrollController: scrollController,
          // onScroll: (scrollOffset) => debugPrint(
          //   'Scroll offset: $scrollOffset',
          // ),
          // onMMBScrollStateChanged: (scrolling) => debugPrint(
          //   'Is scrolling: $scrolling',
          // ),
          // onMMBScrollCursorPositionUpdate:
          //     (localCursorOffset, scrollActivity) => debugPrint(
          //   'Cursor position: $localCursorOffset\n'
          //   'Scroll activity: $scrollActivity',
          // ),
          // enableMMBScrolling: true,
          enableKeyboardScrolling: true,
          // enableCustomMouseWheelScrolling: true,
          // mmbScrollConfig: MMBScrollConfig(
          //   customScrollCursor:
          //       useSystemCursor ? null : const DefaultCustomScrollCursor(),
          // ),
          keyboardScrollConfig: KeyboardScrollConfig(
            homeScrollDurationBuilder: (currentScrollOffset, minScrollOffset) {
              return const Duration(milliseconds: 100);
            },
            endScrollDurationBuilder: (currentScrollOffset, maxScrollOffset) {
              return const Duration(milliseconds: 2000);
            },
          ),
          // customMouseWheelScrollConfig: const CustomMouseWheelScrollConfig(
          //   scrollAmountMultiplier: 4.0,
          //   scrollDuration: Duration(milliseconds: 350),
          // ),
          child: Stack(
            children: [
              BoxAnimation(
                scrollController: scrollController,
              ),
              CustomScrollView(
                controller: scrollController,
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Image.network(
                        faker.image.loremPicsum.image(),
                      ),
                      childCount: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
