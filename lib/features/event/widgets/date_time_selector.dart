import 'package:flutter/material.dart';

class DateTimeSelector extends StatefulWidget {
  final GestureTapCallback onTap;
  final String label;
  final String date;
  final String time;

  DateTimeSelector({
    required this.onTap,
    required this.label,
    required this.date,
    required this.time,
  });

  @override
  State<StatefulWidget> createState() {
    return DateTimeSelectorState();
  }
}

class DateTimeSelectorState extends State<DateTimeSelector> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Text(
                widget.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
            const SizedBox(width: 8),
            Text(widget.date),
            const Spacer(),
            const Icon(Icons.access_time, size: 16, color: Colors.blue),
            const SizedBox(width: 8),
            Text(widget.time),
          ],
        ),
      ),
    );
  }
}
