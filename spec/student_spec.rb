require "spec_helper"


describe "Student" do 

  let(:josh) {Student.new("Josh", "9th")}

  before(:each) do 
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  describe "attributes" do 
    it 'has a name and a grade' do 
      student = Student.new("Tiffany", "11th")
      expect(student.name).to eq("Tiffany")
      expect(student.grade).to eq("11th")
    end

    it 'has a name that is readable but not writable' do 
      expect{josh.id = 1}.to raise_error
    end
  end

  describe "#create_table" do 
    it 'creates the students table in the database' do
      Student.create_table 
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(['students'])
    end
  end

  describe "#drop_table" do 
    it 'drops the students table from the database' do 
      Student.create_table
      Student.drop_table
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(nil)
    end
  end

  describe "#save" do 
    it 'is a class method that takes an argument of a student instance and saves that instance to the database' do 
      Student.create_table
      Student.save(josh)
      expect(DB[:conn].execute("SELECT * FROM students")).to eq([[1, "Josh", "9th"]])
    end
  end

  describe "#create" do 
    it 'takes in a hash of attributes and uses metaprogramming to create a new student object. Then it uses the #save method to save that student to the database' do 
      Student.create_table
      Student.create(name: "Sally", grade: "10th")
      expect(DB[:conn].execute("SELECT * FROM students")).to eq([[1, "Sally", "10th"]])
    end
  end



end