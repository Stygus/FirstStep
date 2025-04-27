import 'dart:ui';

import 'package:firststep/main_web.dart';
import 'package:firststep/models/courses/courses.dart';
import 'package:firststep/providers/coursesProvider.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppPage extends ConsumerStatefulWidget {
  const AppPage({super.key});

  @override
  ConsumerState<AppPage> createState() => _AppPageState();
}

class _AppPageState extends ConsumerState<AppPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _horizontalController =
      ScrollController(); // dodaj to pole

  void getCourses() async {
    final courses = ref.read(coursesProvider);
    final user = ref.read(userProvider);
    try {
      await courses.getAllCoursesFromApi(
        await user.getToken() ?? '',
        user.nickname,
      );
      debugPrint('Courses: ${courses.courses.length}');
    } catch (e, stack) {
      debugPrint('Błąd pobierania kursów: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProvider);
      getCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final coursesList = ref.watch(coursesProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 26, 26, 26),
      appBar: AppBar(
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        title: Text(
          'Witaj ponownie ${user.nickname}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Row(
        children: [
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Najlepsza aktywność',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  user.id == '-1'
                      ? Center(
                        child: Text(
                          'Zaloguj się, aby zobaczyć kursy',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                      : coursesList.courses.isEmpty
                      ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : SizedBox(
                        height: 300, // Wysokość kontenera dostosowana do karty
                        child: Listener(
                          onPointerSignal: (pointerSignal) {
                            if (pointerSignal is PointerScrollEvent) {
                              _horizontalController.jumpTo(
                                _horizontalController.offset +
                                    pointerSignal.scrollDelta.dy * 2,
                              );
                            }
                          },
                          child: ScrollConfiguration(
                            behavior: _CustomScrollBehavior(),
                            child: ListView.builder(
                              controller: _horizontalController,
                              scrollDirection: Axis.horizontal,
                              itemCount: coursesList.courses.length,
                              itemBuilder: (context, index) {
                                final course = coursesList.bestCourses[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: CourseCard(course: course),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          Flexible(flex: 0, child: Container(color: Colors.red)),
        ],
      ),

      drawer: Drawer(
        backgroundColor: Color.fromARGB(199, 26, 26, 26),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(178, 44, 44, 44),
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              iconColor: Colors.white,
              leading: Icon(Icons.home),
              title: Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigator.pop(context);
              },
            ),
            ListTile(
              iconColor: Colors.white,
              leading: Icon(Icons.settings),
              title: Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () async {
                // Navigator.pop(context);

                final courses = ref.read(coursesProvider);
                try {
                  await courses.getAllCoursesFromApi(
                    await user.getToken() ?? '',
                    user.nickname,
                  );
                  debugPrint('Courses: ${courses.courses.length}');
                } catch (e, stack) {
                  debugPrint('Błąd pobierania kursów: $e');
                  debugPrintStack(stackTrace: stack);
                }
              },
            ),
            ListTile(
              iconColor: Colors.white,
              leading: Icon(Icons.logout),
              title: Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                user.signOut();
                // Add logout logic here
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WebHome()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
