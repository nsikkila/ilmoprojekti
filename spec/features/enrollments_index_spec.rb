require 'spec_helper'
include TestHelper

describe "Enrollment table view" do
  before :each do
    @user = FactoryGirl.create(:teacher)
    @projectbundle = FactoryGirl.create(:projectbundle_closed, signup_end:Date.yesterday, verified:false)
    generate_six_unique_projects(1)
  end

  it "allows the verification of a projectbundle" do
    @user2 = FactoryGirl.create(:admin)
    signin(username:@user2.username, password:@user2.password)
    #create_enrollment_with_signups
    create_signups_for_projectbundle(@projectbundle)
    visit enrollments_path

    click_link("Vahvista")
    #@projectbundle.verified.should == true

    expect(page).to have_content("Projektiryhmä vahvistettu!")
  end

  it "does not display the verification button if user is not logged in as admin" do
    signin(username:@user.username, password:@user.password)
    create_signups_for_projectbundle(@projectbundle)
    visit enrollments_path

    expect(page).not_to have_content("Vahvista")
  end

  it "can not be accessed if not logged in" do
    visit enrollments_path

    current_path.should == root_path
  end

  it "can be accessed if logged in and signup_end has passed" do
    signin(username:@user.username, password:@user.password)

    visit enrollments_path
    expect(page).to have_content 'Ilmoittautumisnäkymä'
  end

  it "allows the deletion of an enrollment" do
    signin(username:@user.username, password:@user.password)

    @projects = generate_six_unique_projects(@projectbundle.id)
    @enrollment = FactoryGirl.build(:enrollment)

    index = 1
    6.times do
      @enrollment.signups << FactoryGirl.build(:signup, project_id:index)
      index = index + 1
    end
    @enrollment.save

    visit enrollments_path

    expect {
      click_link('x')
    }.to change { Enrollment.count }.by(-1)

  end

  it "delete button deletes the Signups in addition to Enrollment" do
    signin(username:@user.username, password:@user.password)

    @projects = generate_six_unique_projects(@projectbundle.id)
    @enrollment = FactoryGirl.build(:enrollment)

    index = 1
    6.times do
      @enrollment.signups << FactoryGirl.build(:signup, project_id:index)
      index = index + 1
    end
    @enrollment.save

    visit enrollments_path

    expect {
      click_link('x')
    }.to change { Signup.count }.by(-6)

  end

  describe "when enrollments have not been made" do

    it "shows a message instead of the table" do
      signin(username:@user.username, password:@user.password)

      visit enrollments_path

      expect(page).to have_content 'Ei ilmoittautumisia.'
    end
  end


end

describe "Enrollment table view when no projectbundles exist" do
  it "is not displayed" do

    @user2 = FactoryGirl.create(:admin)
    signin(username:@user2.username, password:@user2.password)

    visit enrollments_path
    expect(page).to have_content("Ei aktiivisia projektiryhmiä")
  end
end