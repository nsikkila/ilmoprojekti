require 'spec_helper'
include TestHelper

describe "Projects page" do

  describe "Project listing page" do

    it "Cannot be accessed if not logged in" do
      create_objects_for_frontpage
      visit projects_path

      expect(page).to have_content 'Sinun täytyy kirjautua sisään'
    end

    it "allows the deletion of a project" do
      sign_in_and_initialize
      FactoryGirl.create(:project)
      visit projects_path

      expect {
        click_link("Poista")
      }.to change{Project.count}.by(-1)
    end

  end

  describe "Create new project form" do

    #before :each do
    #
    #end

    it "Cannot be accessed if not logged in" do
        create_objects_for_frontpage
        visit new_project_path
        expect(page).to have_content("Sinun täytyy kirjautua sisään")


    end

    it "Creates a new project when valid values are passed" do
       sign_in_and_initialize
       visit new_project_path
       fill_in('project_name', with:"Testiprojekti1")
       fill_in('project_description', with:"Description for testproject")
       fill_in('project_website', with:"http://www.hs.fi")
       fill_in('project_maxstudents', with:"15")


       #select('1', from:'enrollment[signups_attributes][0][project_id]')

       expect {
         click_button('Luo projekti')
       }.to change{Project.count}.by(1)
    end

    it "Does not create a new project when invalid values are passed and gives correct validation error messages" do
      sign_in_and_initialize
      visit new_project_path
      fill_in('project_name', with:"")
      fill_in('project_description', with:"")
      fill_in('project_website', with:"i am not an url")
      fill_in('project_maxstudents', with:"asd")


      #select('1', from:'enrollment[signups_attributes][0][project_id]')

      expect {
        click_button('Luo projekti')
      }.to_not change{Project.count}

      expect(page).to have_content("Nimi on liian lyhyt")
      expect(page).to have_content("Kuvaus on liian lyhyt")
      expect(page).to have_content("Kotisivu is not a valid URL")
    end


  end

  describe "Edit project form" do

    it "cannot be accessed if not logged in" do
      create_objects_for_frontpage
      visit edit_project_path(1)
      expect(page).to have_content("Sinun täytyy kirjautua sisään")

    end

    it "can be accessed and succesfully edited with proper values" do
      #sign_in_and_initialize
      user = FactoryGirl.create :teacher
      signin(username:user.username, password:user.password)
      create_objects_for_frontpage
      visit edit_project_path(1)
      fill_in('project_name', with:"Testiprojekti1")
      fill_in('project_description', with:"Description for testproject")
      fill_in('project_website', with:"http://www.hs.fi")
      fill_in('project_maxstudents', with:"15")
      click_button('Luo projekti')

      visit project_path(1)

      expect(page).to have_content("Testiprojekti1")
      expect(page).to have_content("Description for testproject")
      expect(page).to have_content("http://www.hs.fi")
      expect(page).to have_content("15")


      #select('1', from:'enrollment[signups_attributes][0][project_id]')

    end

    it "cannot be edited with improper values" do
      #sign_in_and_initialize

      user = FactoryGirl.create :teacher
      signin(username:user.username, password:user.password)

      create_objects_for_frontpage
      visit edit_project_path(1)
      fill_in('project_name', with:"")
      fill_in('project_description', with:"")
      fill_in('project_website', with:"I am not a url")
      fill_in('project_maxstudents', with:"asd")
      click_button('Luo projekti')

      expect(page).to have_content("Nimi on liian lyhyt")
      expect(page).to have_content("Kuvaus on liian lyhyt")
      expect(page).to have_content("Kotisivu is not a valid URL")

      visit project_path(1)

      expect(page).to_not have_content("I am not a url")
      expect(page).to_not have_content("asd")


      #select('1', from:'enrollment[signups_attributes][0][project_id]')

    end


  end

  describe "The created project" do
    it "shows up correctly on enrollment form" do

      sign_in_and_initialize
      visit new_project_path
      fill_in('project_name', with:"Testiprojekti1")
      fill_in('project_description', with:"Description for testproject")
      fill_in('project_website', with:"http://www.hs.fi")
      fill_in('project_maxstudents', with:"15")


      #select('1', from:'enrollment[signups_attributes][0][project_id]')

      click_button('Luo projekti')

      visit new_enrollment_path
      expect(page).to have_content("Testiprojekti1")
      expect(page).to have_content("Description for testproject")
      expect(page).to have_content("http://www.hs.fi")
      expect(page).to have_content("Vastuuhenkilö: Opettaja")
    end

  end

  describe "Project page" do

    it "shows list of students who have signed up for the project" do
      #@enrollment = create_enrollment_with_signups
      #enroll=create_another_enrollment_with_signups
      create_two_enrollments_with_signups
      visit project_path(1)

      expect(page).to have_content("Jaska Jokunen")
      expect(page).to have_content("Testi Testinen")
    end

    it "shows which students have been accepted for the project" do
      usr=FactoryGirl.create :user, username:"koklaus"
      signin(username:usr.username, password:usr.password)
      @enrollment = create_another_enrollment_with_signups
      visit project_path(1)

      expect(page).to have_content("Jaska Jokunen")
      expect(page).to have_content("Odottaa vielä hyväksymistä tai ei hyväksytty")
      @enrollment.signups.first.status = true

      visit project_path(1)

      expect(page).to have_content("Jaska Jokunen")
      expect(page).to have_content("Hyväksytty")
    end

    it "has link to page which contains email addresses of accepted students" do
      usr=FactoryGirl.create :user, username:"koklaus"
      signin(username:usr.username, password:usr.password)
      @enrollment = create_enrollment_with_signups

      visit project_path(1)
      expect(page).to have_link("Hyväksyttyjen opiskelijoiden sähköpostiosoitteet")
      click_link("Hyväksyttyjen opiskelijoiden sähköpostiosoitteet")

   #   save_and_open_page

      expect(page).to have_content("test@email.com")
    end

  end

end

def sign_in_and_initialize
  user = FactoryGirl.create :teacher
  signin(username:user.username, password:user.password)
  FactoryGirl.create :projectbundle
end