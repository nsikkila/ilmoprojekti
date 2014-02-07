require 'spec_helper'

describe CasasController do
  before :each do
    @project_bundle = FactoryGirl.create(:projectbundle)
    @projects = generate_six_unique_projects(@project_bundle.id)
  end


  it "#create takes signups to database" do
    post :create, { sfirstname:"Matti", slastname:"Mainio", studentnumber:'1234567', p1:{ projectid:'1' }, p2:{ projectid:'2' }, p3:{ projectid:'3'}, p4:{projectid:'4'}, p5:{ projectid:'5' }, p6:{ projectid:'6' } }
    #six signups
    expect(Signup.count).to eq(6)
    #one student
    expect(Student.count).to eq(1)
  end

end

def generate_six_unique_projects(bundle_id)
  projects = Array.new(6)
  (0..5).each do |i|
    projects[i] = FactoryGirl.create(:project, bundle_id:i+1)
  end
  projects
end