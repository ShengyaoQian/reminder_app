import 'package:flutter/material.dart';
import 'package:reminder_app/database_provider.dart';
import 'package:reminder_app/routine_model.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/dialog.dart';
import 'package:reminder_app/routine_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReminderAppDatabaseProvider>(
        builder: (context, db, child) {
          return FutureBuilder<List<Routine>>(
            future: db.routines(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Routine>> snapshot) {
              if (!snapshot.hasData) {
                // while data is loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // data loaded:
                final routines = snapshot.requireData;
                return Center(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.only(top: 80.0, left: 20.0, right: 20),
                    itemCount: routines.length,
                    itemBuilder: (context, index) {
                      final routine = routines[index];
                      return Dismissible(
                          // Each Dismissible must contain a Key. Keys allow Flutter to
                          // uniquely identify widgets.
                          key: Key("${routine.id}"),
                          // Provide a function that tells the app
                          // what to do after an item has been swiped away.
                          onDismissed: (direction) {
                            // Remove the item from the data source.
                            Provider.of<ReminderAppDatabaseProvider>(context,
                                listen: false)
                                .deleteRoutine(routine.id);
                            setState(() {
                              routines.removeAt(index);
                            });

                            // Then show a snackbar.
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('${routine.title} deleted')));
                          },
                          child: RoutineCard(routine));
                    },
                  ),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        tooltip: 'show',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
