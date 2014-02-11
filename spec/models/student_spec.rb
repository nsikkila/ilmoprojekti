require 'spec_helper'

#dfsajsescribe User do
# pending "add some examples to (or delete) #{__FILE__}"
#end

describe Student do

  let(:student){ FactoryGirl.build(:student) }

  it "has the proper fields" do
    #firstname "Testi"
    #lastname "Testinen"
    #studentnumber "013460745"

    student.firstname.should == "Testi"
    student.lastname.should == "Testinen"
    student.studentnumber.should == "1234567"
  end

  it "is saved with proper fields" do
    student.save
    #student is valid
    expect(student.valid?).to be (true)
    #Student is added to db
    expect(Student.count).to eq (1)
  end


  it "when given invalid fields does not pass validation" do
    student2 = FactoryGirl.build(:student, firstname:"a", lastname:"b", studentnumber:"1", email:"fakemail")
    expect(student2.valid?).to be (false)

    expect(Student.count).to eq (0)
  end

end