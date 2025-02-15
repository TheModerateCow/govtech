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
            SELECT s.student_id, s.name AS student_name, t.name AS teacher_name, g.grade
            FROM grade g
            JOIN student s ON g.student_id = s.student_id
            JOIN teacher t ON g.teacher_id = t.teacher_id
            WHERE g.student_id = %s
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

# Create one API endpoint that is able to update your data to assign a student from one teacher to another. This reassignment should affect all past data, i.e. after the API call, one teacher would have taught 4 students for the entire schooling duration, the other teacher would have taught 6 students. You are free to define the API contract.
@app.route('/students/<int:student_id>', methods=['POST'])
def update_student(student_id):
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT s.student_id, s.name AS student_name, t.name AS teacher_name, g.grade
            FROM grade g
            JOIN student s ON g.student_id = s.student_id
            JOIN teacher t ON g.teacher_id = t.teacher_id
            WHERE g.student_id = %s
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
    


if __name__ == '__main__':
    app.run(debug=True)
