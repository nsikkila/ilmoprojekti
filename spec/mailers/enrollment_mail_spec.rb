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
      @enro = create_enrollment_with_signups
      @email = EnrollmentMail.result_email_for_all(@enro)
      @bundle = Projectbundle.find_by_active(true)
      if not @bundle.nil?
        @bundle.active = false
        @bundle.save
      end
    end

    it "should have right sender" do
      @email.should deliver_from("ilmoprojekti@gmail.com")
    end

    it "should have right recipient" do
      @email.should bcc_to("test@email.com")
    end

    it "should have all the recipients when several enrollments" do
      @projectbundle = FactoryGirl.create(:projectbundle)
      @projects = generate_six_unique_projects(@projectbundle.id)
      @enrollment = FactoryGirl.build(:enrollment)

      index = 1
      6.times do
        @enrollment.signups << FactoryGirl.build(:signup, project_id:index)
        index = index + 1
      end

      @enrollment.save

      @projs = generate_six_unique_projects(@projectbundle.id)
      @enro = FactoryGirl.build(:enrollment1, email: "jepa@gmail.com")

      index = 1
      6.times do
        @enro.signups << FactoryGirl.build(:signup, project_id:index)
        index = index + 1
      end

      @enro.save

      arr = [@enrollment, @enro]
      @mail = EnrollmentMail.result_email_for_all(arr)
      @mail.should bcc_to("test@email.com", "jepa@gmail.com")
    end


    it "should have correct subject" do
      @email.should have_subject("Ilmottautumisen tulokset")
    end

    it "should tell if not accepted to any project" do
      @enro.signups.each do |sign|
        sign.status = false
        sign.save
        @enro.save

      end
      @enro.save
      @mail = EnrollmentMail.result_email_for_all(@enro)
      @mail.should have_body_text("valitettavasti sinua ei valittu mihinkään projektiin")
    end

    it "should tell if accepted to projects" do
      @enr = create_another_enrollment_with_signups
      sign = @enr.signups.first
      sign.status = true
      sign.save
      @mail = EnrollmentMail.result_email_for_all(@enr)
      @mail.should have_body_text("sinut on valittu seuraaviin projekteihin:")
    end
  end

end
