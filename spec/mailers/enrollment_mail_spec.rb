require "spec_helper"
include TestHelper

describe EnrollmentMail do
  describe "confirmation email " do

    before(:each) do
      @enrollment =create_enrollment_with_signups
      @email=EnrollmentMail.confirmation_email(@enrollment, "tamaontestihash", @enrollment.projects.first.projectbundle)
    end

    it "should have right sender" do
      @email.should deliver_from("ilmoprojekti@gmail.com")
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

  describe "email after verification" do
    before(:each) do
      @enrollment = create_enrollment_with_signups
      @email = EnrollmentMail.result_email_for_all(@enrollment)
    end

    it "should have right recipient" do
      @email.should bcc_to("test@email.com")
    end

    it "should have correct subject" do
      @email.should have_subject("Ilmottautumisen tulokset")
    end

    it "should tell if not accepted to any project" do
      @email.should have_body_text("valitettavasti sinua ei valittu mihinkään projektiin")
      end
  end

end
