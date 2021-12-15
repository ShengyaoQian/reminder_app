import 'package:flutter/material.dart';
import 'package:reminder_app/dialog.dart';
import 'package:reminder_app/routine_model.dart';
import 'package:provider/provider.dart';
import 'routine_model.dart';
import 'package:reminder_app/database_provider.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard(this.routine, {Key? key}) : super(key: key);
  final Routine routine;

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
            routineId: routine.id,
            titleInput: routine.title,
            numberInput: "${routine.durationNumber}",
            unitInput: routine.unit);
      },
    );
  }

  int _getDispalyNumber(String unit, int epoch, int duration) {
    Duration diff = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(epoch*1000));
    switch(unit) {
      case "Months":
        return duration - (diff.inDays/30).round();
      case "Days":
        return duration - diff.inDays;
      case "Hours":
        return duration - diff.inHours;
      case "Minutes":
        return duration - diff.inMinutes;
    }
    return 0;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(routine.title),
            trailing: Text(
                "In ${_getDispalyNumber(routine.unit, routine.starttimeUnix, routine.durationNumber)} ${routine.unit}",
                style: TextStyle(color: _getDispalyNumber(routine.unit, routine.starttimeUnix, routine.durationNumber) > 0 ? Colors.black : Colors.red),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Edit'),
                onPressed: () {
                  _showDialog(context);
                },
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Reset'),
                onPressed: () {
                  // change the starttimeUnix to now
                  int unixNow =
                  (DateTime.now().millisecondsSinceEpoch / 1000).round();
                  var updateRoutine = Routine(
                      id: routine.id,
                      title: routine.title,
                      starttimeUnix: unixNow,
                      durationNumber: routine.durationNumber,
                      unit: routine.unit);
                  Provider.of<ReminderAppDatabaseProvider>(context, listen: false)
                      .updateRoutine(updateRoutine);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
