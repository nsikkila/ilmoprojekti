require 'spec_helper'

describe EnrollmentsController do
  before :each do
    @project_bundle = FactoryGirl.create(:projectbundle)
    @projects = generate_six_unique_projects(@project_bundle.id)
  end


  it "#create takes signups to database" do
    post :create, { enrollment_firstname:"Matti", enrollment_lastname:"Mainio", enrollment_studentnumber:'1234567', enrollment_email:'testi@maili.fi', enrollment_signups_attributes_0_project_id:{ project_id:'1' }, enrollment_signups_attributes_1_project_id:{ project_id:'2' }, enrollment_signups_attributes_2_project_id:{ project_id:'3'}, enrollment_signups_attributes_3_project_id:{ project_id:'4'}, enrollment_signups_attributes_4_project_id:{ project_id:'5' }, enrollment_signups_attributes_5_project_id:{ project_id:'6' } }
    #one student
    expect(Student.count).to eq(1)
    #six signups
    expect(Signup.count).to eq(6)
    expect(Student.first.signups.first.student_id).to eq(1)
  end

end

