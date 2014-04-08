require 'spec_helper'

describe EnrollmentsController do

  describe "when signups are ongoing" do
    before :each do
      @projectbundle = FactoryGirl.create(:projectbundle)
      @projects = generate_six_unique_projects(@projectbundle.id)
    end

    it "#create takes signups to database" do
      post :create, { :enrollment=>{firstname:"Matti", lastname:"Mainio", studentnumber:'1234567', email:'testi@maili.fi', :signups_attributes => {"0"=>{"project_id"=>"1", "priority"=>"1"}, "1"=>{"project_id"=>"2", "priority"=>"2"}, "2"=>{"project_id"=>"3", "priority"=>"3"}, "3"=>{"project_id"=>"4", "priority"=>"4"}, "4"=>{"project_id"=>"5", "priority"=>"5"}, "5"=>{"project_id"=>"6", "priority"=>"6"}}} }

      #one student
      expect(Enrollment.count).to eq(1)
      #six signups
      expect(Signup.count).to eq(6)
    end
  end


  describe "when signup deadline has passed" do
    before :each do
      @projectbundle = FactoryGirl.create(:projectbundle, signup_end:Date.yesterday)
      @projects = generate_six_unique_projects(@projectbundle.id)
    end

    describe "when not signed in" do
      it "can not change signup status to true" do
        enro = generate_enro_with_signup(false, false)
        sign = enro.signups.first
        xhr :post, :setstatus, {enrollment_id:enro.id, project_id:sign.project_id, status:"true"}
        expect(Signup.find(sign.id).status).to be false
      end

      it "can not change signup status to false" do
        enro = generate_enro_with_signup(true, false)
        sign = enro.signups.first
        xhr :post, :setstatus, {enrollment_id:enro.id, project_id:sign.project_id, status:"false"}
        expect(Signup.find(sign.id).status).to be true
      end

      it "can not force a signup" do
        enro = generate_enro_with_signup(false, false)
        expected_signup = enro.signups.first
        project_to_force = @projects.last

        xhr :post, :setforced, {enrollment_id:enro.id, project_id:project_to_force.id, forced:"true"}

        #haetaan enro uudelleen
        enro.reload
        #ei uutta signupia
        expect(enro.signups.count).to eq 1
        #signup ei ole pakotettu
        expect(enro.signups.first).to eq expected_signup
        expect(enro.signups.last.forced).to eq false
      end

      it "can not remove forced signup" do
        enro = generate_enro_with_forced_signup
        forced_signup = enro.signups.find_by_forced true
        forced_project = forced_signup.project

        xhr :post, :setforced, {enrollment_id:enro.id, project_id:forced_project.id, forced:"false"}

        #ladataan enro uudelleen
        enro.reload
        #signupit ovat pysyneet
        expect(enro.signups.count).to eq 2
        expect(enro.signups.find_by_forced true).to eq forced_signup
      end
    end

    describe "when signed in as a teacher" do
      before :each do
        user = FactoryGirl.create :teacher
        session[:user_id] = user.id
      end

      it "can change signup status to true" do
        enro = generate_enro_with_signup(false, false)
        sign = enro.signups.first
        xhr :post, :setstatus, {enrollment_id:enro.id, project_id:sign.project_id, status:"true"}
        expect(Signup.find(sign.id).status).to be true
      end

      it "can change signup status to false" do
        enro = generate_enro_with_signup(true, false)
        sign = enro.signups.first
        xhr :post, :setstatus, {enrollment_id:enro.id, project_id:sign.project_id, status:"false"}
        expect(Signup.find(sign.id).status).to be false
      end

      it "can force a signup" do
        enro = generate_enro_with_signup(false, false)
        project_to_force = @projects.last

        xhr :post, :setforced, {enrollment_id:enro.id, project_id:project_to_force.id, forced:"true"}

        #haetaan enro uudelleen
        enro.reload
        #uusi signup
        expect(enro.signups.count).to eq 2
        #uus signup on pakotettu
        expect(enro.signups.last.forced).to eq true
        expect(enro.signups.last.status).to eq true
      end

      it "can remove forced signup" do
        enro = generate_enro_with_forced_signup
        forced_signup = enro.signups.find_by_forced true
        forced_project = forced_signup.project

        xhr :post, :setforced, {enrollment_id:enro.id, project_id:forced_project.id, forced:"false"}

        #ladataan enro uudelleen
        enro.reload
        #signup hävinnyt
        expect(enro.signups.count).to eq 1
        expect(enro.signups.find_by_forced true).to be nil
      end
    end

    describe "when signed in as an admin" do
      before :each do
        user = FactoryGirl.create :admin
        session[:user_id] = user.id
      end

      it "can change signup status to true" do
        enro = generate_enro_with_signup(false, false)
        sign = enro.signups.first
        xhr :post, :setstatus, {enrollment_id:enro.id, project_id:sign.project_id, status:"true"}
        expect(Signup.find(sign.id).status).to be true
      end

      it "can change signup status to false" do
        enro = generate_enro_with_signup(true, false)
        sign = enro.signups.first
        xhr :post, :setstatus, {enrollment_id:enro.id, project_id:sign.project_id, status:"false"}
        expect(Signup.find(sign.id).status).to be false
      end

      it "can force a signup" do
        enro = generate_enro_with_signup(false, false)
        project_to_force = @projects.last

        xhr :post, :setforced, {enrollment_id:enro.id, project_id:project_to_force.id, forced:"true"}

        #haetaan enro uudelleen
        enro.reload
        #uusi signup
        expect(enro.signups.count).to eq 2
        #uus signup on pakotettu
        expect(enro.signups.last.forced).to eq true
        expect(enro.signups.last.status).to eq true
      end

      it "can remove forced signup" do
        enro = generate_enro_with_forced_signup
        forced_signup = enro.signups.find_by_forced true
        forced_project = forced_signup.project

        xhr :post, :setforced, {enrollment_id:enro.id, project_id:forced_project.id, forced:"false"}

        #ladataan enro uudelleen
        enro.reload
        #signup hävinnyt
        expect(enro.signups.count).to eq 1
        expect(enro.signups.find_by_forced true).to be nil
      end
    end

  end

  describe "when signups have been verified" do
    before :each do
      @projectbundle = FactoryGirl.create(:projectbundle, signup_end:Date.yesterday, verified:true)
      @projects = generate_six_unique_projects(@projectbundle.id)
      enro1 = generate_enro_with_signup(true, false)
      enro2 = generate_enro_with_signup(false, false)
    end

    describe "when signed in as a teacher" do
      before :each do
        user = FactoryGirl.create :teacher
        session[:user_id] = user.id
      end

      it "can not change signup status to true" do
        enro = generate_enro_with_signup(false, false)
        sign = enro.signups.first
        xhr :post, :setstatus, {enrollment_id:enro.id, project_id:sign.project_id, status:"true"}
        expect(Signup.find(sign.id).status).to be false
      end

      it "can not change signup status to false" do
        enro = generate_enro_with_signup(true, false)
        sign = enro.signups.first
        xhr :post, :setstatus, {enrollment_id:enro.id, project_id:sign.project_id, status:"false"}
        expect(Signup.find(sign.id).status).to be true
      end

      it "can not force a signup" do
        enro = generate_enro_with_signup(false, false)
        expected_signup = enro.signups.first
        project_to_force = @projects.last

        xhr :post, :setforced, {enrollment_id:enro.id, project_id:project_to_force.id, forced:"true"}

        #haetaan enro uudelleen
        enro.reload
        #ei uutta signupia
        expect(enro.signups.count).to eq 1
        #signup ei ole pakotettu
        expect(enro.signups.first).to eq expected_signup
        expect(enro.signups.last.forced).to eq false
      end

      it "can not remove forced signup" do
        enro = generate_enro_with_forced_signup
        forced_signup = enro.signups.find_by_forced true
        forced_project = forced_signup.project

        xhr :post, :setforced, {enrollment_id:enro.id, project_id:forced_project.id, forced:"false"}

        #ladataan enro uudelleen
        enro.reload
        #signupit ovat pysyneet
        expect(enro.signups.count).to eq 2
        expect(enro.signups.find_by_forced true).to eq forced_signup
      end
    end

    describe "when signed in as an admin" do
      before :each do
        user = FactoryGirl.create :admin
        session[:user_id] = user.id
      end

      it "can change signup status to true" do
        enro = generate_enro_with_signup(false, false)
        sign = enro.signups.first
        xhr :post, :setstatus, {enrollment_id:enro.id, project_id:sign.project_id, status:"true"}
        expect(Signup.find(sign.id).status).to be true
      end

      it "can change signup status to false" do
        enro = generate_enro_with_signup(true, false)
        sign = enro.signups.first
        xhr :post, :setstatus, {enrollment_id:enro.id, project_id:sign.project_id, status:"false"}
        expect(Signup.find(sign.id).status).to be false
      end

      it "can force a signup" do
        enro = generate_enro_with_signup(false, false)
        project_to_force = @projects.last

        xhr :post, :setforced, {enrollment_id:enro.id, project_id:project_to_force.id, forced:"true"}

        #haetaan enro uudelleen
        enro.reload
        #uusi signup
        expect(enro.signups.count).to eq 2
        #uus signup on pakotettu
        expect(enro.signups.last.forced).to eq true
        expect(enro.signups.last.status).to eq true
      end

      it "can remove forced signup" do
        enro = generate_enro_with_forced_signup
        forced_signup = enro.signups.find_by_forced true
        forced_project = forced_signup.project

        xhr :post, :setforced, {enrollment_id:enro.id, project_id:forced_project.id, forced:"false"}

        #ladataan enro uudelleen
        enro.reload
        #signup hävinnyt
        expect(enro.signups.count).to eq 1
        expect(enro.signups.find_by_forced true).to be nil
      end
    end

  end

end



def generate_enro_with_signup(status, forced)
  enro =  FactoryGirl.build(:enrollment)
  enro.signups << FactoryGirl.build(:signup, status:status, forced:forced, project_id:@projects.first.id)
  enro.save
  enro
end

def generate_enro_with_forced_signup
  enro = generate_enro_with_signup(false, false)
  enro.signups << FactoryGirl.build(:signup, status:true, forced:true, project_id:@projects.last.id)
  enro.save
  enro
end