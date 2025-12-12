class Volunteer {
  final int id;
  final String owner;
  final String title;
  final String eventType;
  final String description;
  final String date;
  final String startTime;
  final String endTime;
  final String location;
  final int participantsMax;
  final int participantsCurrent;

  Volunteer({
    required this.id,
    required this.owner,
    required this.title,
    required this.eventType,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.participantsMax,
    required this.participantsCurrent,
  });
}