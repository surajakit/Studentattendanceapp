Overview
The Attendance Management System is a Python-based desktop application designed to simplify the process of managing student attendance, timetables, and subject records in educational institutions. The system features a user-friendly interface built using Tkinter and stores data in an SQLite database for easy retrieval and management.

This application is suitable for schools, colleges, universities, and any organization that needs to track attendance, manage schedules, and generate reports for students and subjects.

Features
Student Management:

Add, list, and manage student records.
Store student information such as name and ID.
Subject Management:

Add, list, and manage subjects.
Link subjects to the timetable and attendance records.
Timetable Management:

Add and manage class schedules, including the subject, time, and day.
View the schedule in an easy-to-read format.
Attendance Marking:

Mark attendance for students on specific dates and subjects.
Track attendance status (Present or Absent).
Attendance Reports:

Generate detailed attendance reports for students and subjects.
View, print, or export reports for future reference.
Dynamic Theming:

Switch between multiple themes (Light, Dark, Blue, Professional) to suit user preferences.
Database Integration:

Store all data in an SQLite database for easy management and updates.
Automatic updates when adding, modifying, or deleting records.
Error Handling:

Informative error messages guide the user in case of missing input or incorrect actions.
Requirements
Python 3.x
Tkinter (usually comes pre-installed with Python)
SQLite3 (usually comes pre-installed with Python)
Pillow (for handling images such as background or icons)
Installation Instructions
Clone the repository:

bash
Copy code
git clone https://github.com/yourusername/attendance-management-system.git
cd attendance-management-system
Install Dependencies: Make sure Python 3.x is installed. You can install the required Python packages using pip:

bash
Copy code
pip install pillow
Run the application: After setting up the dependencies, run the application by executing:

bash
Copy code
python main.py
Database Setup: Upon first launch, the system will automatically create an SQLite database (attendance.db) in the application directory to store student, subject, timetable, and attendance data.

Usage
Once the application is running:

Add Students:

Enter a student name in the "Manage Students" section and click "Add Student" to add students to the database.
The list of students will be displayed in a table format.
Add Subjects:

Enter a subject name in the "Manage Subjects" section and click "Add Subject" to register new subjects.
Manage Timetable:

In the "Timetable Management" section, enter the class day, time, and subject to create a new timetable entry.
Mark Attendance:

Select a student from the list, choose the subject and date, then mark their attendance as "Present" or "Absent."
Generate Attendance Report:

Click "Generate Report" in the "Attendance Reports" section to view the attendance record for all students.
Change Themes:

Switch between different themes by clicking the theme buttons in the bottom panel (Light, Dark, Blue, or Professional).
Screenshots
(Add relevant screenshots here to show the user interface of the application)

Troubleshooting
Widget not defined error:
If you encounter an error like "Widget not defined," make sure that all necessary variables (like buttons, entries, etc.) are defined in your code before using them.

Database Issues:
If the database is not created, ensure that SQLite3 is correctly installed and that the app has permission to write to the directory.

Theme not changing:
Ensure that all widgets are collected in the all_widgets list for theme changes to apply. If you add new widgets, they should be added to this list.

Contributing
Contributions to the project are welcome! Feel free to fork the repository, make changes, and submit a pull request. Ensure that you follow these guidelines:

Submit well-commented and clean code.
Provide a description of the change in the pull request.
Test your changes thoroughly before submitting.
License
This project is licensed under the MIT License - see the LICENSE file for details.

Acknowledgments
Tkinter for the graphical user interface.
SQLite3 for the database integration.
Pillow for image handling.
