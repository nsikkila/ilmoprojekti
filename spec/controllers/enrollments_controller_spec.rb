require 'spec_helper'

describe EnrollmentsController do
  before :each do
    @project_bundle = FactoryGirl.create(:projectbundle)
    @projects = generate_six_unique_projects(@project_bundle.id)
  end


  it "#create takes signups to database" do
    post :create, { sfirstname:"Matti", slastname:"Mainio", studentnumber:'1234567', email:'testi@maili.fi', p1:{ project_id:'1' }, p2:{ project_id:'2' }, p3:{ project_id:'3'}, p4:{ project_id:'4'}, p5:{ project_id:'5' }, p6:{ project_id:'6' } }
    #one student
    expect(Student.count).to eq(1)
    #six signups
    expect(Signup.count).to eq(6)
    expect(Student.first.signups.first.student_id).to eq(1)
  end

end

