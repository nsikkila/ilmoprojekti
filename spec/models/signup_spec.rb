require 'spec_helper'

#dfsajsescribe User do
# pending "add some examples to (or delete) #{__FILE__}"
#end

describe Signup do

  let(:signup){ FactoryGirl.build(:signup) }

  it "has the fields set correctly" do

    signup.project_id.should == 1
    signup.priority.should == 1
    signup.student_id.should == 1
    signup.status.should == true
  end

  it "is saved with proper fields" do
    signup.save
    expect(signup.valid?).to be(true)
    expect(Signup.count).to eq (1)
  end

    #describe "with improper fields" do
    #it "is not saved" do
    #  FactoryGirl.build(:signup, project:"asd", priority:"asd", student_id:"asd", status:"asd")

      #Signup must not be valid
    #  expect(signup.valid?).to be(false)
    #  signup.save
      #User must not be added to db
    #  expect(Signup.count).to eq(0)
   # end
  #end
end