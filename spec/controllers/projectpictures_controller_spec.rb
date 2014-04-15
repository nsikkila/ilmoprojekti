require 'spec_helper'

describe ProjectpicturesController do

  it "responds to show method call and returns data" do

    user = FactoryGirl.create :teacher
    signin(username:user.username, password:user.password)
    create_objects_for_frontpage
    visit edit_project_path(1)
    fill_in('project_name', with:"Testiprojekti1")
    fill_in('project_description', with:"Description for testproject")
    fill_in('project_website', with:"http://www.hs.fi")
    fill_in('project_maxstudents', with:"15")

    attach_file("project_projectpicture", File.join(Rails.root, '/public/images/p2plogo_box_projekti_ilmo_250x111.jpeg'))

    click_button('Tallenna projekti')

    get(:show, {'id' => "1"})

    response.body.should_not be(nil)
    response.header['Content-Type'].should eql 'image/jpeg'


  end
end
