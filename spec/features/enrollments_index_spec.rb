require 'spec_helper'
include TestHelper

describe "Enrollment table view" do
  before :each do
    @user = FactoryGirl.create(:teacher)
    FactoryGirl.create(:projectbundle_closed, signup_end:Date.yesterday)
    generate_six_unique_projects(1)
  end

  it "can not be accessed if not logged in" do
    visit enrollments_path

    current_path.should == root_path
  end

  it "can be accessed if logged in and signup_end has passed" do
    signin(username:@user.username, password:@user.password)

    #byebug
    visit enrollments_path
    expect(page).to have_content 'Ilmoittautumisnäkymä'
  end

  describe "when enrollments have not been made" do

    it "shows a message instead of the table" do
      signin(username:@user.username, password:@user.password)

      visit enrollments_path

      expect(page).to have_content 'Ei ilmoittautumisia.'
    end
  end

end

describe "Enrollment table view when signup is still active" do

  it "can not be accessed" do
    FactoryGirl.create(:projectbundle, signup_end:Date.tomorrow)

    visit enrollments_path

    expect(page).not_to have_content("Ilmoittautumisnäkymä")

  end

end