import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ConsultationsPage extends StatefulWidget {
  @override
  _ConsultationsPageState createState() => _ConsultationsPageState();
}

class _ConsultationsPageState extends State<ConsultationsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Event>> events = {
    DateTime(2045, 5, 12): [Event('Shooting Stars', Colors.green, ['John', 'Doe'])],
    DateTime(2045, 5, 13): [
      Event('The Amazing Hubble', Colors.red, ['Jane', 'Smith']),
    ],
    DateTime(2045, 5, 15): [
      Event('Choosing a Quality Cookware Set', Colors.purple, ['John', 'Doe']),
      Event('The Amazing Hubble', Colors.blue, ['Jane', 'Smith']),
    ],
    DateTime(2045, 5, 16): [
      Event('Astronomy Binoculars', Colors.orange, ['Alice', 'Bob']),
    ],
    DateTime(2045, 5, 17): [
      Event('A Great Alternative', Colors.yellow, ['Mary', 'Johnson']),
    ],
  };

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultations'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2050),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 8.0),
          _selectedDay != null
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _getEventsForDay(_selectedDay!).length,
                    itemBuilder: (context, index) {
                      Event event = _getEventsForDay(_selectedDay!)[index];
                      return Card(
                        color: event.color,
                        child: ListTile(
                          title: Text(event.title),
                          subtitle: Text("Members: ${event.members.join(', ')}"),
                        ),
                      );
                    },
                  ),
                )
              : Center(child: Text('No events selected')),
        ],
      ),
    );
  }
}

class Event {
  final String title;
  final Color color;
  final List<String> members;

  Event(this.title, this.color, this.members);
}
