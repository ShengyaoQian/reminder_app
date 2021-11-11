import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/database_provider.dart';

import 'routine_model.dart';

class MyDialog extends StatefulWidget {
  final int? routineId;
  final String? titleInput;
  final String? numberInput;
  final String? unitInput;

  const MyDialog(
      {Key? key,
      this.routineId,
      this.titleInput,
      this.numberInput,
      this.unitInput})
      : super(key: key);

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? titleInput;
  String? numberInput;
  String? unitInput;

  @override
  initState() {
    titleInput = widget.titleInput;
    numberInput = widget.numberInput;
    unitInput = widget.unitInput;
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return object of type Dialog
    return AlertDialog(
      title: const Text("New Routine"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              initialValue: titleInput,
              onSaved: (String? value) {
                titleInput = value!;
              },
              decoration: const InputDecoration(
                hintText: 'Enter a title',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 20.0,
                  child: Text("In"),
                ),
                Expanded(
                  child: SizedBox(
                    width: 100.0,
                    child: TextFormField(
                      onSaved: (String? value) {
                        numberInput = value!;
                      },
                      initialValue: numberInput,
                      decoration: const InputDecoration(
                        hintText: 'number',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      // Only numbers can be entered
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 90.0,
                  child: DropdownButton<String>(
                    value: unitInput,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    onChanged: (String? newValue) {
                      setState(() {
                        unitInput = newValue!;
                      });
                    },
                    items: <String>['Minutes', 'Hours', 'Days', 'Months']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.red,
          ),
          child: const Text('Abandon'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            // Validate will return true if the form is valid, or false if
            // the form is invalid.
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // Process data.
              // unix in seconds
              int number = int.parse(numberInput ?? "0");
              int unixNow =
              (DateTime.now().millisecondsSinceEpoch / 1000).round();
              if (widget.routineId == null) {
                var routine = Routine(
                    id: unixNow,
                    title: titleInput ?? "No title",
                    starttimeUnix: unixNow,
                    durationNumber: number,
                    unit: unitInput ?? "Days");
                Provider.of<ReminderAppDatabaseProvider>(context, listen: false)
                    .insertRoutine(routine);
              } else {
                var routine = Routine(
                    id: widget.routineId!,
                    title: titleInput ?? "No title",
                    starttimeUnix: unixNow,
                    durationNumber: number,
                    unit: unitInput ?? "Days");
                Provider.of<ReminderAppDatabaseProvider>(context, listen: false)
                    .updateRoutine(routine);
              }

              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
