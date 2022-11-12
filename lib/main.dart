import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider.dart';
import 'dart:ui' as ui;

void main() async {
  await GetStorage.init();

  GetStorage box = GetStorage();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ToDoAddProvider(box: box),
      child: const App(),
    ),
  );
}
// void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // routeInformationProvider: _router.routeInformationProvider,
      // routeInformationParser: _router.routeInformationParser,
      // routerDelegate: _router.routerDelegate,
      title: 'Todo App',
      home: HomeScreen(),
    );
  }

  // final GoRouter _router = GoRouter(
  //   routes: <GoRoute>[
  //     GoRoute(
  //       path: '/',
  //       builder: (BuildContext context, GoRouterState state) {
  //         return const HomeScreen();
  //       },
  //     ),
  //     GoRoute(
  //       path: '/new_todo',
  //       builder: (context, state) => const NewTodo(),
  //     ),
  //   ],
  // );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ToDoAddProvider>().getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screensize = (ui.window.physicalSize / ui.window.devicePixelRatio);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: DoubleBack(
          message: "Press back again to close",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          const Text(
                            'Hello',
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const Text(
                            'What are you going to do?',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          todoInput(context),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your To-Do list:',
                        style: TextStyle(fontSize: 15),
                      ),
                      listTodo(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded listTodo() {
    return Expanded(
      child: Consumer<ToDoAddProvider>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.todoList.length,
            itemBuilder: (BuildContext context, int index) {
              var todoId = value.todoList[index].id;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                padding: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(0.0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: value.todoList[index].isChecked == 0 ? false : true,
                          onChanged: (_) {
                            context.read<ToDoAddProvider>().checked(todoId, value.todoList[index].name, value.todoList[index].createdAt);
                          },
                        ),
                        Expanded(
                          child: Text(
                            value.todoList[index].name!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<ToDoAddProvider>().remove(todoId, value.todoList[index].name, value.todoList[index].isChecked, value.todoList[index].createdAt);
                          },
                          child: const Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(''),
                        Text(
                          value.todoList[index].createdAt!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  TextFormField todoInput(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      controller: context.read<ToDoAddProvider>().todoController,
      onFieldSubmitted: (value) {
        if (context.read<ToDoAddProvider>().todoController.text.isNotEmpty) {
          context.read<ToDoAddProvider>().add();
          context.read<ToDoAddProvider>().todoController.clear();
        } else {
          Fluttertoast.showToast(msg: 'Please enter what are you going to do!');
        }
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        hintText: 'Add To-Do',
        suffixIcon: GestureDetector(
          onTap: () {
            // print(todoController.text);
            if (context.read<ToDoAddProvider>().todoController.text.isNotEmpty) {
              context.read<ToDoAddProvider>().add();
              context.read<ToDoAddProvider>().todoController.clear();
            } else {
              Fluttertoast.showToast(msg: 'Please enter what are you going to do!');
            }
            FocusScope.of(context).unfocus();
          },
          child: const SizedBox(
            width: 50,
            height: 50,
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}

// class DoubleBackToCloseWidget extends StatefulWidget {
//   final Widget child; // Make Sure this child has a Scaffold widget as parent.

//   const DoubleBackToCloseWidget({
//     required this.child,
//   });

//   @override
//   _DoubleBackToCloseWidgetState createState() => _DoubleBackToCloseWidgetState();
// }

// class _DoubleBackToCloseWidgetState extends State<DoubleBackToCloseWidget> {
//   late int _lastTimeBackButtonWasTapped;
//   static const exitTimeInMillis = 2000;

//   bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

//   @override
//   Widget build(BuildContext context) {
//     if (_isAndroid) {
//       return WillPopScope(
//         onWillPop: _handleWillPop,
//         child: widget.child,
//       );
//     } else {
//       return widget.child;
//     }
//   }

//   Future<bool> _handleWillPop() async {
//     final _currentTime = DateTime.now().millisecondsSinceEpoch;

//     if (_lastTimeBackButtonWasTapped != null && (_currentTime - _lastTimeBackButtonWasTapped) < exitTimeInMillis) {
//       Scaffold.of(context).;
//       return true;
//     } else {
//       _lastTimeBackButtonWasTapped = DateTime.now().millisecondsSinceEpoch;
//       Scaffold.of(context).removeCurrentSnackBar();
//       Scaffold.of(context).showSnackBar(
//         _getExitSnackBar(context),
//       );
//       return false;
//     }
//   }

//   SnackBar _getExitSnackBar(
//     BuildContext context,
//   ) {
//     return SnackBar(
//       content: Text(
//         'Press BACK again to exit!',
//         style: TextStyle(
//           color: Colors.white,
//         ),
//       ),
//       backgroundColor: Colors.red,
//       duration: const Duration(
//         seconds: 2,
//       ),
//       behavior: SnackBarBehavior.floating,
//     );
//   }
// }
