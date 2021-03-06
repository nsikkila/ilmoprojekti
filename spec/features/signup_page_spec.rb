=begin signup ei yksittäisenä käytössä
require 'spec_helper'
include TestHelper

describe "Signup page" do

    it "listing cannot be accessed if user is not logged in as at least a teacher" do

      create_objects_for_frontpage

      visit signups_path
      expect(page).to have_content("Opiskelija")
    end

    it "can be accessed if the user is logged in as a teacher" do
      user = FactoryGirl.create :teacher
      signin(username:user.username, password:user.password)

      visit signups_path
      expect(page).to have_content("Ilmottautumisten listaus")
    end

  #Turha testi?
  it "does not allow editing if user is not logged in" do

    FactoryGirl.create(:signup)
    create_objects_for_frontpage

    visit edit_signup_path(1)
    expect(page).not_to have_content("Ilmottautumisten muokkaus")
  end

end
=end
