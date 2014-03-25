require 'spec_helper'

describe "User page" do

  it "listing cannot be accessed if not logged in" do
    FactoryGirl.create(:user, username:"testi")
    create_objects_for_frontpage

    visit users_path

    expect(page).not_to have_content "Käyttäjät"
    expect(page).not_to have_content "Maija"

  end

  it "listing cannot be accessed if logged in as a teacher" do
    user = FactoryGirl.create(:teacher)
    create_objects_for_frontpage
    signin(username:user.username, password:user.password)

    visit users_path
    expect(page).not_to have_content "Käyttäjät"

  end

  it "listing can be accessed if logged in as an admin" do
    user = FactoryGirl.create(:admin)
    signin(username:user.username, password:user.password)

    visit users_path
    expect(page).to have_content "Käyttäjät"
    expect(page).to have_content "Admin"
  end

  describe "a logged in user" do

    it "can succesfully edit his information" do
      user = FactoryGirl.create(:teacher)
      signin(username:user.username, password:user.password)
      visit edit_user_path(user)

      expect(page).to have_content "Käyttäjän muokkaus"

      fill_in('user_firstname', with: "Teemu")
      fill_in('user_lastname', with: "Testinen")
      fill_in('user_password', with: "Testi1")
      fill_in('user_password_confirmation', with: "Testi1")

      click_button('Tallenna käyttäjä')

      expect(page).to have_content "Teemu"
      expect(page).to have_content "Testinen"


    end

    it "cannot edit his details with faulty information" do
      user = FactoryGirl.create(:teacher)
      signin(username:user.username, password:user.password)
      visit edit_user_path(user)

      expect(page).to have_content "Käyttäjän muokkaus"

      fill_in('user_firstname', with: "Teemu")
      fill_in('user_lastname', with: "Testinen")
      fill_in('user_password', with: "a")
      fill_in('user_password_confirmation', with: "b")

      click_button('Tallenna käyttäjä')

      expect(page).to have_content "Password confirmation doesn't match Password"


    end

  end

  describe "admin" do

    before :each do
      user = FactoryGirl.create(:admin)
      signin(username:user.username, password:user.password)
    end

    it "can create a user" do
      visit new_user_path

      fill_in('user_firstname', with: "Teemu")
      fill_in('user_lastname', with: "Testinen")
      fill_in('user_username', with: "Test")
      fill_in('user_password', with: "Testi1")
      fill_in('user_password_confirmation', with: "Testi1")

      expect {
        click_button('Tallenna käyttäjä')
      }.to change { User.count }.by(1)
    end

    it "can delete a user" do
      FactoryGirl.create(:user)
      visit users_path

      expect {
        find(:xpath, "(//a[text()='Poista'])[2]").click
      }.to change { User.count }.by(-1)

    end

    it "cannot create a user with faulty information" do
      visit new_user_path

      fill_in('user_firstname', with: "Teemu")
      fill_in('user_lastname', with: "Testinen")
      fill_in('user_username', with: "asd")
      fill_in('user_password', with: "a")
      fill_in('user_password_confirmation', with: "b")

      expect {
        click_button('Tallenna käyttäjä')
      }.to change { User.count }.by(0)
    end

  end


end