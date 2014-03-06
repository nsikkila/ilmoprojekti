require 'spec_helper'
include TestHelper

describe "Projects page" do

  describe "Project listing page" do

    it "Cannot be accessed if not logged in" do
      create_objects_for_frontpage
      visit projects_path
      expect(page).to_not have_content("Luo uusi projekti")
      expect(page).to have_content("Etunimi")
      expect(page).to have_content("Sukunimi")
      expect(page).to have_content("Opiskelijanumero")
    end
  end

  describe "Create new project form" do

    #before :each do
    # user = FactoryGirl.create :teacher
    # signin(username:user.username, password:user.password)
    # FactoryGirl.create :projectbundle
    #end

    it "Cannot be accessed if not logged in" do
        create_objects_for_frontpage
        visit new_project_path
        expect(page).to_not have_content("Luo projekti")
        expect(page).to have_content("Etunimi")
        expect(page).to have_content("Sukunimi")
        expect(page).to have_content("Opiskelijanumero")

    end

    it "Creates a new project when valid values are passed" do

    end

    it "Does not create a new project when invalid values are passed" do

    end


  end
end