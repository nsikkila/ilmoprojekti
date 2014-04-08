
require 'spec_helper'
include TestHelper

describe "Projectpundle page" do
  describe "Projectbundle new" do

    it "should have correct texts in the page" do
      user = FactoryGirl.create(:admin)
      signin(username:user.username, password:user.password)
      visit new_projectbundle_path;

      expect(page).to have_content("Projektiryhmän nimi")
      expect(page).to have_content("Kuvaus")
      expect(page).to have_content("Ilmoittautuminen alkaa")
      expect(page).to have_content("Ilmoittautuminen päättyy")
      expect(page).to have_content("Aktiivinen")

    end
    it "should have correct fields in the page" do
      user = FactoryGirl.create(:admin)
      signin(username:user.username, password:user.password)
      visit new_projectbundle_path;

      expect(page).to have_unchecked_field("projectbundle_active")
      expect(page).to have_field("projectbundle_description")

    end

    end
end
