class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    students = DB[:conn].execute("SELECT * FROM students")
    students.map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE students.name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
   
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE students.grade = 9").map do |row|
      Student.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE students.grade < 12").map do |row|
      Student.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(num)
    DB[:conn].execute("SELECT * FROM students WHERE students.grade = 10 LIMIT ? ", num).map do |row|
      Student.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    student = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1").flatten
    Student.new_from_db(student)
  end

  def self.all_students_in_grade_X(num)
    DB[:conn].execute("SELECT * FROM students WHERE students.grade = ? ", num).map do |row|
      Student.new_from_db(row)
    end
  end


end
