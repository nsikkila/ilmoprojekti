require 'spec_helper'

describe EnrollmentsController do
  before :each do
    @project_bundle = FactoryGirl.create(:projectbundle)
    @projects = generate_six_unique_projects(@project_bundle.id)
  end


  it "#create takes signups to database" do
    post :create, { :enrollment=>{firstname:"Matti", lastname:"Mainio", studentnumber:'1234567', email:'testi@maili.fi', :signups_attributes => {"0"=>{"project_id"=>"1", "priority"=>"1"}, "1"=>{"project_id"=>"2", "priority"=>"2"}, "2"=>{"project_id"=>"3", "priority"=>"3"}, "3"=>{"project_id"=>"4", "priority"=>"4"}, "4"=>{"project_id"=>"5", "priority"=>"5"}, "5"=>{"project_id"=>"6", "priority"=>"6"}}} }

    #one student
    expect(Enrollment.count).to eq(1)
    #six signups
    expect(Signup.count).to eq(6)

  end

end

