require 'spec_helper'

#dfsajsescribe User do
# pending "add some examples to (or delete) #{__FILE__}"
#end

describe Enrollment do

  let(:enrollment){ FactoryGirl.build(:enrollment) }

  it "has the proper fields" do
    #firstname "Testi"
    #lastname "Testinen"
    #studentnumber "013460745"

    enrollment.firstname.should == "Testi"
    enrollment.lastname.should == "Testinen"
    enrollment.studentnumber.should == "1234567"
  end

  it "is saved with proper fields" do
    enrollment.save
    #Enrollment is valid
    expect(enrollment.valid?).to be (true)
    #Enrollment is added to db
    expect(Enrollment.count).to eq (1)
  end


  it "when given invalid fields does not pass validation" do
    enrollment2 = FactoryGirl.build(:enrollment, firstname:"a", lastname:"b", studentnumber:"asd", email:"fakemail")
    expect(enrollment2.valid?).to be (false)

    expect(Enrollment.count).to eq (0)
  end

end