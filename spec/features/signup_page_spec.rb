require 'spec_helper'
include TestHelper

describe "Signup page" do

    it "listing cannot be accessed if user is not logged in as at least a teacher" do
      visit signups_path
      expect(page).to have_content("Etunimi:")
    end

    it "can be accessed if the user is logged in as a teacher" do
      user = FactoryGirl.create :teacher
      signin(username:user.username, password:user.password)

      visit signups_path
      expect(page).to have_content("Listing signups")
    end

  #Turha testi?
  it "does not allow editing if user is not logged in" do
    FactoryGirl.create(:signup)
    visit edit_signup_path(1)
    expect(page).not_to have_content("Editing signup")
  end

end
