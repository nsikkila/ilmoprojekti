require 'spec_helper'

#dfsajsescribe User do
# pending "add some examples to (or delete) #{__FILE__}"
#end

describe Enrollment do

  describe "enrollment" do
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
      enrollment.signups << FactoryGirl.create(:signup)
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

    describe "when has accepted signups" do
      before :each do
        @enro = Enrollment.new
        @enro.signups << Signup.new(status:true, priority:2)
        @enro.signups << Signup.new(status:true, priority:3)
        @enro.signups << Signup.new(status:false, priority:4)
      end

      it "returns correct magic number" do
        result = @enro.magic_number
        expected_result = 2.5

        expect(result).to eq(expected_result)
      end

      it "return correct amount of accepted signups" do
        result = @enro.accepted_amount
        expected_result = 2

        expect(result).to eq(expected_result)
      end

    end

    describe "when has no accepted signups" do
      before :each do
        @enro = Enrollment.new
        @enro.signups << Signup.new(status:false, priority:2)
        @enro.signups << Signup.new(status:false, priority:3)
        @enro.signups << Signup.new(status:false, priority:4)
      end

      it "returns correct magic number" do
        result = @enro.magic_number
        expected_result = 0

        expect(result).to eq(expected_result)
      end

      it "return correct amount of accepted signups" do
        result = @enro.accepted_amount
        expected_result = 0

        expect(result).to eq(expected_result)
      end
    end
  end

  describe 'removing enrollment' do

    it 'removes associated signups' do
      e = create_enrollment_with_two_signups(1)

      #initial
      expect(Enrollment.count).to eq 1
      expect(Signup.count).to eq 2
      expect(e.signups.count).to eq 2

      #remove
      e.destroy
      expect(Enrollment.count).to eq 0
      expect(Signup.count).to eq 0
    end

    it 'does not remove unassiociated signups' do
      e1 = create_enrollment_with_two_signups(1)
      e2 = create_enrollment_with_two_signups(2)

      #initial
      expect(Enrollment.count).to eq 2
      expect(Signup.count).to eq 4
      expect(e1.signups.count).to eq 2
      expect(e2.signups.count).to eq 2

      #remove
      e1.destroy
      expect(Enrollment.count).to eq 1
      expect(Signup.count).to eq 2
    end
  end

end

def create_enrollment_with_two_signups(enrollment_id)
  e = FactoryGirl.build(:enrollment, id:enrollment_id)
  s1 = FactoryGirl.create(:signup, project_id:1, enrollment_id:enrollment_id)
  s2 = FactoryGirl.create(:signup, project_id:2, enrollment_id:enrollment_id)

  e.save

  e
end