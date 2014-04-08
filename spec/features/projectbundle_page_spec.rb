
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
      expect(page).to have_button("Tallenna projektiryhmä")
      expect(page).to have_link("Takaisin")
    end
    it "should go to own page after greating valid bundle" do
      user = FactoryGirl.create(:admin)
      signin(username:user.username, password:user.password)
      visit new_projectbundle_path;
      fill_in("projectbundle_name", with: 'testi')
      fill_in("projectbundle_description", with: 'testingtesting')

      click_button("Tallenna projektiryhmä")

      expect(page).to have_content "Projektiryhmä onnistuneesti luotu."


    end

    it "should not create new bundle after greating with empty name field" do
      user = FactoryGirl.create(:admin)
      signin(username:user.username, password:user.password)
      visit new_projectbundle_path;
      fill_in("projectbundle_name", with: '')
      fill_in("projectbundle_description", with: 'testingtesting')

      click_button("Tallenna projektiryhmä")

      expect(page).to have_content "Name can't be blank"
    end
    it "should not create new bundle after greating with empty description field" do
      user = FactoryGirl.create(:admin)
      signin(username:user.username, password:user.password)
      visit new_projectbundle_path;
      fill_in("projectbundle_name", with: 'testi')
      fill_in("projectbundle_description", with: '')

      click_button("Tallenna projektiryhmä")

      expect(page).to have_content "Description can't be blank"
      end
    end
end
