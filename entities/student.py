import json

class Student:  
    def __init__(self, student_id, student_name, teacher_name, cgpa):
        self.student_id = student_id
        self.student_name = student_name
        self.teacher_name = teacher_name
        self.cgpa = cgpa
        
    def to_dict(self):
        return {
            'student_id': self.student_id,
            'student_name': self.student_name,
            'teacher_name': self.teacher_name,
            'cpga': self.cgpa
        }

    def __repr__(self):
        return f"Student({self.student_name}, '{self.teacher_name}, {self.cgpa}')"
