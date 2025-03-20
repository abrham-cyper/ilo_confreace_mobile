import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';

// Task model defined inline
class Task {
  final int id;
  final String title;
  final String startTime;
  final String endTime;
  final String date;
  final String duration;
  final String status;
  final int color;

  Task({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.duration,
    required this.status,
    required this.color,
  });
}

class Program extends StatefulWidget {
  const Program({Key? key}) : super(key: key);

  @override
  _ProgramState createState() => _ProgramState();
}

class _ProgramState extends State<Program> {
  // Updated task list for May 19-23, 2020
  List<Task> tasks = [
    Task(
      id: 1,
      title: "Team Briefing",
      startTime: "09:00",
      endTime: "09:30",
      date: "2020-05-19",
      duration: "30 Minutes",
      status: "Done",
      color: 0xFFBBDEFB,
    ),
    Task(
      id: 2,
      title: "Client Meeting",
      startTime: "10:00",
      endTime: "11:30",
      date: "2020-05-19",
      duration: "1.5 Hours",
      status: "In Progress",
      color: 0xFFE1BEE7,
    ),
    Task(
      id: 3,
      title: "Project Review",
      startTime: "12:00",
      endTime: "13:30",
      date: "2020-05-20",
      duration: "1.5 Hours",
      status: "Upcoming",
      color: 0xFFB2DFDB,
    ),
    Task(
      id: 4,
      title: "Lunch Break",
      startTime: "14:00",
      endTime: "15:00",
      date: "2020-05-20",
      duration: "1 Hour",
      status: "Upcoming",
      color: 0xFFFFCDD2,
    ),
    Task(
      id: 5,
      title: "Design Sprint",
      startTime: "09:00",
      endTime: "10:00",
      date: "2020-05-21",
      duration: "1 Hour",
      status: "Upcoming",
      color: 0xFFBBDEFB,
    ),
    Task(
      id: 6,
      title: "Code Review",
      startTime: "11:00",
      endTime: "12:30",
      date: "2020-05-22",
      duration: "1.5 Hours",
      status: "Upcoming",
      color: 0xFFE1BEE7,
    ),
    Task(
      id: 7,
      title: "Weekly Wrap-up",
      startTime: "14:00",
      endTime: "15:00",
      date: "2020-05-23",
      duration: "1 Hour",
      status: "Upcoming",
      color: 0xFFB2DFDB,
    ),
  ];

  DateTime selectedDate = DateTime(2020, 5, 19); // Default date set to May 19, 2020

  // Method to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 5, 19), // Start of range: May 19, 2020
      lastDate: DateTime(2020, 5, 23),  // End of range: May 23, 2020
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF3F51B5), // Header background color
              onPrimary: Colors.white,    // Header text color
              surface: Colors.white,      // Background color
              onSurface: Colors.black,    // Text color
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter tasks for the selected date
    List<Task> filteredTasks = tasks.where((task) {
      DateTime taskDate = DateTime.parse(task.date);
      return taskDate.day == selectedDate.day &&
          taskDate.month == selectedDate.month &&
          taskDate.year == selectedDate.year;
    }).toList();

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF3F51B5), // Dark blue
                Color(0xFFB0BEC5), // Light grey-blue
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // Date Selector Section
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${DateFormat('MMMM, yyyy').format(selectedDate)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Color(0xFF3F51B5), size: 20),
                            8.width,
                            Text(
                              DateFormat('d MMM').format(selectedDate),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3F51B5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Task List Section
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Tasks",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      16.height,
                      Expanded(
                        child: filteredTasks.isEmpty
                            ? Center(
                                child: Text(
                                  "No tasks for this date",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredTasks.length,
                                itemBuilder: (context, index) {
                                  Task task = filteredTasks[index];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Color(task.color),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              task.startTime,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              task.endTime,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                        16.width,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                task.title,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              4.height,
                                              Text(
                                                task.duration,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            task.status,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
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
}