class Routine {
  final int id;
  final String title;
  final int starttimeUnix;
  final int durationNumber;
  final String unit;

  Routine({
    required this.id,
    required this.title,
    required this.starttimeUnix,
    required this.durationNumber,
    required this.unit,
  });

  // Convert a Routine into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'starttimeUnix': starttimeUnix,
      'durationNumber': durationNumber,
      'unit': unit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Routine{id: $id, title: $title, starttimeUnix: $starttimeUnix, durationNumber: $durationNumber, unit: $unit}';
  }
}
