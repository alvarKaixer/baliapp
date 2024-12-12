// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_recommender/views/bali_trip_screen/bali_trip_screen.dart';
import 'package:music_recommender/views/create_plan_page/views/preferences_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Import the intl package

class CreatePlanPage extends StatefulWidget {
  const CreatePlanPage({Key? key}) : super(key: key);

  @override
  _CreatePlanPageState createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> {
  final TextEditingController _planNameController = TextEditingController();
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  void _savePlanData() {
    String planName = _planNameController.text.trim();

    if (planName.isEmpty) {
      _showErrorDialog('Please enter a name for your plan.');
      return;
    }

    if (kDebugMode) {
      print("Plan Name: $planName");
      print("Selected Date: $_selectedDay");
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PreferencesPage()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Back',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool _isInRange(DateTime day) {
    return day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
        day.isBefore(_selectedDay.add(const Duration(days: 1)));
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date); // Format the date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a Plan',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E4F4F), // Dark teal color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BaliTripScreen()),
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'BaliTrip',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name your plan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _planNameController,
              decoration: InputDecoration(
                hintText: 'Enter the name of your plan',
                labelText: 'Plan Name',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                floatingLabelStyle: TextStyle(
                  color: Colors.black,
                ),   
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF2E4F4F), width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              'Select a date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFF2E4F4F),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF2E4F4F),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(color: Colors.white),
                selectedTextStyle: TextStyle(color: Colors.white),
              ),
              calendarBuilders: CalendarBuilders(
                rangeHighlightBuilder: (context, day, focusedDay) {
                  if (_isInRange(day)) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E4F4F),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 20),
            // Centered trip range card with the Next button inside
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Your Bali Trip will be from',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_formatDate(DateTime.now())} to ${_formatDate(_selectedDay)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E4F4F),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _savePlanData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E4F4F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 40),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _planNameController.dispose();
    super.dispose();
  }
}
