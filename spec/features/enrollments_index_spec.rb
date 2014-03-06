require 'spec_helper'
include TestHelper

describe "Enrollment table view" do
  before :each do
    @user = FactoryGirl.create(:user)
    FactoryGirl.create(:projectbundle)
    generate_six_unique_projects(1)
  end

  it "can not be accessed if not logged in" do
    visit enrollments_path

    current_path.should == root_path
  end

  it "can be accessed if logged in" do
    signin(username:@user.username, password:@user.password)

    visit enrollments_path
    expect(page).to have_content 'Ilmottautumisnäkymä'
  end

  describe "when enrollments have not been made" do

    it "shows a message instead of the table" do
      signin(username:@user.username, password:@user.password)

      visit enrollments_path

      expect(page).to have_content 'Ei ilmottautumisia.'
    end
  end

end