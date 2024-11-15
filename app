import tkinter as tk
from tkinter import ttk, messagebox
from PIL import Image, ImageTk
import sqlite3

# Initialize database
conn = sqlite3.connect("attendance.db")
cursor = conn.cursor()

# Create tables
cursor.execute("""
CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
)
""")
cursor.execute("""
CREATE TABLE IF NOT EXISTS subjects (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
)
""")
cursor.execute("""
CREATE TABLE IF NOT EXISTS timetable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    day TEXT,
    time TEXT,
    subject_id INTEGER,
    FOREIGN KEY(subject_id) REFERENCES subjects(id)
)
""")
cursor.execute("""
CREATE TABLE IF NOT EXISTS attendance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER,
    subject_id INTEGER,
    date TEXT,
    status TEXT,
    FOREIGN KEY(student_id) REFERENCES students(id),
    FOREIGN KEY(subject_id) REFERENCES subjects(id)
)
""")
conn.commit()

# Global Variables
themes = {
    "Light": {"bg": "white", "fg": "black", "highlight": "#f0f0f0", "button_bg": "#4CAF50", "button_fg": "white"},
    "Dark": {"bg": "#2b2b2b", "fg": "white", "highlight": "#3c3c3c", "button_bg": "#1E1E1E", "button_fg": "white"},
    "Blue": {"bg": "#eaf6ff", "fg": "#003366", "highlight": "#cde3f7", "button_bg": "#007ACC", "button_fg": "white"},
    "Professional": {"bg": "#F5F5F5", "fg": "#2C3E50", "highlight": "#D5DBDB", "button_bg": "#2980B9", "button_fg": "white"}
}

current_theme = "Light"

def apply_theme():
    theme = themes[current_theme]
    root.configure(bg=theme["bg"])
    # Apply theme to all widgets that need styling
    for widget in all_widgets:
        if isinstance(widget, tk.Label) or isinstance(widget, tk.Radiobutton):
            widget.configure(bg=theme["bg"], fg=theme["fg"])
        elif isinstance(widget, (tk.Text, tk.Entry)):
            widget.configure(bg=theme["highlight"], fg=theme["fg"])
        elif isinstance(widget, ttk.Combobox):
            widget.configure(style=f"{current_theme}.TCombobox")
        elif isinstance(widget, ttk.Button):
            widget.configure(style=f"{current_theme}.TButton")

def change_theme(theme_name):
    global current_theme
    current_theme = theme_name
    apply_theme()

def initialize_styles():
    for theme_name, style in themes.items():
        s = ttk.Style()
        s.configure(f"{theme_name}.TCombobox", fieldbackground=style["highlight"], foreground=style["fg"])
        s.configure(f"{theme_name}.TButton", background=style["button_bg"], foreground=style["button_fg"])

# Functions
def add_student():
    name = student_name_entry.get()
    if name:
        cursor.execute("INSERT INTO students (name) VALUES (?)", (name,))
        conn.commit()
        update_student_list()
        student_name_entry.delete(0, tk.END)
        messagebox.showinfo("Success", "Student added successfully!")
    else:
        messagebox.showwarning("Input Error", "Please enter a student name!")

def add_subject():
    name = subject_name_entry.get()
    if name:
        cursor.execute("INSERT INTO subjects (name) VALUES (?)", (name,))
        conn.commit()
        update_subject_list()
        subject_name_entry.delete(0, tk.END)
        messagebox.showinfo("Success", "Subject added successfully!")
    else:
        messagebox.showwarning("Input Error", "Please enter a subject name!")

def update_student_list():
    students_list.delete(*students_list.get_children())
    cursor.execute("SELECT * FROM students")
    for student in cursor.fetchall():
        students_list.insert("", "end", values=(student[0], student[1]))

def update_subject_list():
    subject_dropdown["values"] = []
    cursor.execute("SELECT * FROM subjects")
    subjects = cursor.fetchall()
    subject_dropdown["values"] = [f"{subject[0]}: {subject[1]}" for subject in subjects]

def add_timetable_entry():
    day = day_entry.get()
    time = time_entry.get()
    subject_id = int(subject_dropdown.get().split(":")[0])
    if day and time:
        cursor.execute(
            "INSERT INTO timetable (day, time, subject_id) VALUES (?, ?, ?)",
            (day, time, subject_id)
        )
        conn.commit()
        timetable_text.insert(tk.END, f"{day} - {time} - {subject_dropdown.get().split(':')[1]}\n")
        messagebox.showinfo("Success", "Timetable entry added successfully!")
    else:
        messagebox.showwarning("Input Error", "Please enter valid day and time!")

def mark_attendance():
    try:
        selected_student = students_list.focus()
        student_id = students_list.item(selected_student)["values"][0]
        subject_id = int(subject_dropdown.get().split(":")[0])
        date = date_entry.get()
        status = attendance_status.get()
        cursor.execute(
            "INSERT INTO attendance (student_id, subject_id, date, status) VALUES (?, ?, ?, ?)",
            (student_id, subject_id, date, status),
        )
        conn.commit()
        messagebox.showinfo("Success", "Attendance marked successfully!")
    except IndexError:
        messagebox.showerror("Selection Error", "Please select a student and subject!")

def show_attendance_report():
    cursor.execute("""
        SELECT students.name, subjects.name, date, status
        FROM attendance
        INNER JOIN students ON attendance.student_id = students.id
        INNER JOIN subjects ON attendance.subject_id = subjects.id
    """)
    records = cursor.fetchall()
    report_text.delete("1.0", tk.END)
    for record in records:
        report_text.insert(tk.END, f"{record[0]} - {record[1]} - {record[2]} - {record[3]}\n")

# UI Setup
root = tk.Tk()
root.title("Attendance Management System")
root.geometry("1000x700")
root.configure(bg="white")

# Add Icon
icon_path = "my_icon.ico"  # Replace with your icon file path
try:
    root.iconbitmap(icon_path)
except Exception:
    pass

# Add Background Image
bg_image_path = "background.jpg"  # Replace with your background image path
try:
    bg_image = Image.open(bg_image_path)
    bg_image = bg_image.resize((1000, 700), Image.ANTIALIAS)
    bg_photo = ImageTk.PhotoImage(bg_image)
    bg_label = tk.Label(root, image=bg_photo)
    bg_label.place(x=0, y=0, relwidth=1, relheight=1)
except Exception:
    root.configure(bg="white")

# Header
header_frame = tk.Frame(root, bg="black", height=50)
header_frame.pack(fill=tk.X)
header_label = tk.Label(header_frame, text="Attendance Management System", font=("Arial", 24, "bold"), bg="black", fg="white")
header_label.pack()

# Main Frames
main_frame = tk.Frame(root, bg="white", padx=10, pady=10)
main_frame.pack(fill=tk.BOTH, expand=True)

left_frame = tk.Frame(main_frame, bg="white", padx=10, pady=10)
left_frame.pack(side=tk.LEFT, fill=tk.Y)

center_frame = tk.Frame(main_frame, bg="white", padx=10, pady=10)
center_frame.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

right_frame = tk.Frame(main_frame, bg="white", padx=10, pady=10)
right_frame.pack(side=tk.RIGHT, fill=tk.Y)

# Left Panel - Student and Subject Management
tk.Label(left_frame, text="Manage Students", font=("Arial", 16), bg="white").pack(pady=5)
student_name_entry = ttk.Entry(left_frame)
student_name_entry.pack(pady=5)
add_student_button = ttk.Button(left_frame, text="Add Student", command=add_student)
add_student_button.pack(pady=5)

students_list = ttk.Treeview(left_frame, columns=("ID", "Name"), show="headings", height=15)
students_list.heading("ID", text="ID")
students_list.heading("Name", text="Name")
students_list.pack(pady=10)

tk.Label(left_frame, text="Manage Subjects", font=("Arial", 16), bg="white").pack(pady=5)
subject_name_entry = ttk.Entry(left_frame)
subject_name_entry.pack(pady=5)
add_subject_button = ttk.Button(left_frame, text="Add Subject", command=add_subject)
add_subject_button.pack(pady=5)

# Center Panel - Timetable and Attendance Management
tk.Label(center_frame, text="Timetable Management", font=("Arial", 16), bg="white").pack(pady=5)
tk.Label(center_frame, text="Day:", font=("Arial", 12), bg="white").pack(anchor=tk.W)
day_entry = ttk.Entry(center_frame)
day_entry.pack(pady=2)

tk.Label(center_frame, text="Time:", font=("Arial", 12), bg="white").pack(anchor=tk.W)
time_entry = ttk.Entry(center_frame)
time_entry.pack(pady=2)

tk.Label(center_frame, text="Subject:", font=("Arial", 12), bg="white").pack(anchor=tk.W)
subject_dropdown = ttk.Combobox(center_frame, width=25)
subject_dropdown.pack(pady=2)

add_timetable_button = ttk.Button(center_frame, text="Add to Timetable", command=add_timetable_entry)
add_timetable_button.pack(pady=5)

# Timetable Display
tk.Label(center_frame, text="Timetable", font=("Arial", 14), bg="white").pack(pady=10)
timetable_text = tk.Text(center_frame, width=50, height=10, wrap=tk.WORD, bg="#f0f0f0", font=("Arial", 10))
timetable_text.pack(pady=5)

# Attendance Management
tk.Label(center_frame, text="Mark Attendance", font=("Arial", 16), bg="white").pack(pady=15)
tk.Label(center_frame, text="Date (YYYY-MM-DD):", font=("Arial", 12), bg="white").pack(anchor=tk.W)
date_entry = ttk.Entry(center_frame)
date_entry.pack(pady=2)

attendance_status = tk.StringVar(value="Present")
tk.Radiobutton(center_frame, text="Present", variable=attendance_status, value="Present", bg="white", font=("Arial", 10)).pack(anchor=tk.W)
tk.Radiobutton(center_frame, text="Absent", variable=attendance_status, value="Absent", bg="white", font=("Arial", 10)).pack(anchor=tk.W)

mark_attendance_button = ttk.Button(center_frame, text="Mark Attendance", command=mark_attendance)
mark_attendance_button.pack(pady=10)

# Right Panel - Attendance Reports
tk.Label(right_frame, text="Attendance Reports", font=("Arial", 16), bg="white").pack(pady=5)
report_text = tk.Text(right_frame, width=40, height=25, wrap=tk.WORD, bg="#f0f0f0", font=("Arial", 10))
report_text.pack(pady=10)

generate_report_button = ttk.Button(right_frame, text="Generate Report", command=show_attendance_report)
generate_report_button.pack(pady=5)

# Footer
footer_frame = tk.Frame(root, bg="black", height=30)
footer_frame.pack(fill=tk.X)
footer_label = tk.Label(footer_frame, text="Attendance Management System - Developed by Suraj Nath Goswami", font=("Arial", 10), bg="black", fg="white")
footer_label.pack()

# Initialize Data
update_student_list()
update_subject_list()
initialize_styles()

# Create Buttons for Changing Themes
theme_button_frame = tk.Frame(root, bg="white")
theme_button_frame.pack(side=tk.BOTTOM, fill=tk.X)
theme_buttons = {
    "Light": tk.Button(theme_button_frame, text="Light Theme", command=lambda: change_theme("Light"), bg="#4CAF50", fg="white"),
    "Dark": tk.Button(theme_button_frame, text="Dark Theme", command=lambda: change_theme("Dark"), bg="#1E1E1E", fg="white"),
    "Blue": tk.Button(theme_button_frame, text="Blue Theme", command=lambda: change_theme("Blue"), bg="#007ACC", fg="white"),
    "Professional": tk.Button(theme_button_frame, text="Professional Theme", command=lambda: change_theme("Professional"), bg="#2980B9", fg="white")
}
for btn in theme_buttons.values():
    btn.pack(side=tk.LEFT, padx=5, pady=5)

# Collect all widgets for styling
all_widgets = [
    header_label, student_name_entry, add_student_button, students_list, subject_name_entry, add_subject_button, 
    day_entry, time_entry, subject_dropdown, add_timetable_button, timetable_text, date_entry, 
    mark_attendance_button, report_text, generate_report_button, footer_label
]

# Run the app
root.mainloop()
