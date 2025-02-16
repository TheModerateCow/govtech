from flask import Flask, request, jsonify
from db import Database
from entities.student import Student

app = Flask(__name__)

# Create a Database instance
db = Database()

grades = {
    "A+": 4.3,
    "A": 4.0,
    "A-": 3.7,
    "B+": 3.3,
    "B": 3.0,
    "B-": 2.7,
    "C+": 2.3,
    "C": 2.0,
    "C-": 1.7,
    "D": 1.0,
    "F": 0.0
}

def init_db():
    """Initialise the database schema from schema.sql."""
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        with open('schema.sql', 'r') as file:
            sql = file.read()
        
        commands = sql.split(';')
        for command in commands:
            if command.strip():
                cursor.execute(command)
        
        conn.commit()
        cursor.close()
        db.return_connection(conn)
        print("Database initialised successfully with schema.sql")
    except Exception as e:
        print("Error initialising the database:", e)

# Run init_db() before handling the first request
with app.app_context():
    init_db()

@app.route('/student/<int:student_id>', methods=['GET'])
def get_student(student_id):
    try:
        # Get a connection from the pool
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT s.student_id, s.name, t.name, c.grade 
            FROM student s
            INNER JOIN teacher t ON t.teacher_id = s.teacher_id
            INNER JOIN course c ON c.student_id = s.student_id
            WHERE s.student_id = %s
        """, (student_id,))

        rows = cursor.fetchall()
        print(rows)
        cursor.close()
        db.return_connection(conn)
        
        if not rows:
            return jsonify({"error": "Student not found"}), 404
        
        cgpa = 0
        count = 0
        for row in rows:
            cgpa += grades[row[3]]
            count += 1
        
        if count > 0:
            cgpa = cgpa / count
        student_obj = Student(rows[0][0], rows[0][1], rows[0][2], cgpa)
        
        return jsonify(student_obj.to_dict())
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/students/<int:student_id>', methods=['POST'])
def update_student(student_id):
    try:
        data = request.get_json()
        teacher_id = data.get('teacher_id')
        if teacher_id is None:
            return jsonify({"error": "teacher_id is required"}), 400

        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            UPDATE student
            SET teacher_id = %s
            WHERE student_id = %s
        """, (teacher_id, student_id))
        
        if cursor.rowcount == 0:
            cursor.close()
            db.return_connection(conn)
            return jsonify({"error": "Student not found"}), 404
        
        conn.commit()
        
        cursor.execute("""
            SELECT student_id, name, teacher_id
            FROM student
            WHERE student_id = %s
        """, (student_id,))
        student_row = cursor.fetchone()
        
        cursor.execute("""
            SELECT grade
            FROM course
            WHERE student_id = %s
        """, (student_id,))
        course_rows = cursor.fetchall()
        
        cursor.close()
        db.return_connection(conn)
        
        total = 0.0
        count = 0
        for r in course_rows:
            grade_letter = r[0]
            total += grades.get(grade_letter, 0)
            count += 1
        cgpa = total / count if count > 0 else 0
        
        student_obj = Student(student_row[0], student_row[1], student_row[2], cgpa)
        return jsonify(student_obj.to_dict())
    except Exception as e:
        return jsonify({"error": str(e)}), 500

from flask import request, jsonify

@app.route('/students/cumulative', methods=['GET'])
def cumulative_gpa():
    try:
        start_year = request.args.get('start_year', type=int)
        start_sem = request.args.get('start_sem', type=int)
        end_year = request.args.get('end_year', type=int)
        end_sem = request.args.get('end_sem', type=int)
        
        if None in (start_year, start_sem, end_year, end_sem):
            return jsonify({"error": "start_year, start_sem, end_year, and end_sem are required parameters."}), 400
        
        start_val = start_year * 10 + start_sem
        end_val = end_year * 10 + end_sem
        
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT s.student_id, s.name, c.grade, c.year, c.sem_no
            FROM course c
            JOIN student s ON c.student_id = s.student_id
            WHERE (c.year * 10 + c.sem_no) BETWEEN %s AND %s
            ORDER BY s.student_id, c.year, c.sem_no
        """, (start_val, end_val))
        
        rows = cursor.fetchall()
        cursor.close()
        db.return_connection(conn)
        
        student_data = {}
        for row in rows:
            student_id, student_name, grade_letter, course_year, course_sem = row
            if student_id not in student_data:
                student_data[student_id] = {
                    'student_name': student_name,
                    'total_points': 0.0,
                    'count': 0
                }
            grade_point = grades.get(grade_letter, 0)
            student_data[student_id]['total_points'] += grade_point
            student_data[student_id]['count'] += 1
        
        results = []
        for student_id, data in student_data.items():
            cumulative = data['total_points'] / data['count'] if data['count'] > 0 else 0
            results.append({
                "student_id": student_id,
                "student_name": data['student_name'],
                "cumulative_gpa": cumulative
            })
        
        return jsonify(results)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
