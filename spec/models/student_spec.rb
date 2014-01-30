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
    student.studentnumber.should == "013460745"
  end

  it "is saved with proper fields" do
    student.save
    #student is valid
    expect(student.valid?).to be (true)
    #Student is added to db
    expect(Student.count).to eq (1)
  end

end