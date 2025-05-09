import 'dart:ui';

import 'package:firststep/main_web.dart';
import 'package:firststep/models/courses/courses.dart';
import 'package:firststep/models/files.dart';
import 'package:firststep/providers/coursesProvider.dart';
import 'package:firststep/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppPage extends ConsumerStatefulWidget {
  const AppPage({super.key});

  @override
  ConsumerState<AppPage> createState() => _AppPageState();
}

class _AppPageState extends ConsumerState<AppPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _horizontalController = ScrollController();

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

    return ScrollConfiguration(
      behavior: _CustomScrollBehavior(),
      child: Scaffold(
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
          mainAxisSize: MainAxisSize.min,
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
                        : Expanded(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio:
                                  1.4, // Zwiększenie wartości dla niższych kart
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                            ),
                            controller: _horizontalController,
                            scrollDirection: Axis.vertical,
                            itemCount: coursesList.courses.length,
                            itemBuilder: (context, index) {
                              final course =
                                  coursesList.bestCourses.length > index
                                      ? coursesList.bestCourses[index]
                                      : coursesList.courses[index];
                              return Card(
                                elevation: 4.0,
                                color: Colors.black12,
                                margin: EdgeInsets.all(8.0),
                                child: CourseCard(course: course),
                              );
                            },
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
                  final file = FileList(files: [], ref: ref);
                  await file.fetchFiles();
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
