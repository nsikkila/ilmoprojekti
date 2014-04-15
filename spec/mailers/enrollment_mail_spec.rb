require "spec_helper"
include TestHelper

describe EnrollmentMail do
  describe "confirmation email " do

    before(:each) do
    # @bundle=FactoryGirl.create(:projectbundle)
    #  generate_six_unique_projects(@bundle.id)
      @enrollment =create_enrollment_with_signups
      @email=EnrollmentMail.confirmation_email(@enrollment, "tamaontestihash", @enrollment.projects.first.projectbundle)
    #  @email = FactoryGirl.create(:enrollment, email:"jepa@gmail.com")
    end

    it "should have right recipient" do
      @email.should deliver_to("test@email.com")
    end

    it "should have correct link" do
      @email.should have_body_text("http://ilmoprojekti.herokuapp.com/enrollments/"+@enrollment.id.to_s+"/tamaontestihash")
    end

    it "should have correct subject" do
      @email.should have_subject("Vahvistus ilmottautumisesta")
    end



  end

end
