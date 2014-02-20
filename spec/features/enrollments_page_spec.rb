require 'spec_helper'
include TestHelper

describe "Enrollments page" do

  describe "Signup form" do

    it "has all the correct fields, lists project information and projects" do

      FactoryGirl.create :projectbundle

      generate_six_unique_projects_with_user(1)
      @projects = Project.all

      visit root_path

      expect(page).to have_content("Testibundle")

      expect(page).to have_content("Etunimi")
      expect(page).to have_content("Sukunimi")
      expect(page).to have_content("Opiskelijanumero")
      expect(page).to have_content("Sähköpostiosoite")

      expect(page).to have_content("1 This is a")
      expect(page).to have_content("2 This is a")
      expect(page).to have_content("3 This is a")
      expect(page).to have_content("4 This is a")
      expect(page).to have_content("5 This is a")
      expect(page).to have_content("6 This is a")

      expect(page).to have_content("Prioriteetti 1:123456")
      expect(page).to have_content("Prioriteetti 2:123456")
      expect(page).to have_content("Prioriteetti 3:123456")
      expect(page).to have_content("Prioriteetti 4:123456")
      expect(page).to have_content("Prioriteetti 5:123456")
      expect(page).to have_content("Prioriteetti 6:123456")


    end

    it "accepts enrollment with correct form values" do

      FactoryGirl.create :projectbundle

      generate_six_unique_projects_with_user(1)
      @projects = Project.all

      expect(Project.count).to eq(6)

      visit root_path

      fill_in('sfirstname', with:"Testi")
      fill_in('slastname', with:"Testinen")
      fill_in('studentnumber', with:"1234567")
      fill_in('email', with:"testi@testi.fi")

      select('1', from:'p1[project_id]')
      select('2', from:'p2[project_id]')
      select('3', from:'p3[project_id]')
      select('4', from:'p4[project_id]')
      select('5', from:'p5[project_id]')
      select('6', from:'p6[project_id]')

      expect {
        click_button('Ilmoittaudu')
      }.to change{Signup.count}.by(6)

      expect(page).to have_content 'Etunimi: Testi Sukunimi: Testinen'
    end

    it "creates unique hash for users" do
      FactoryGirl.create :projectbundle

      generate_six_unique_projects_with_user(1)
      @projects = Project.all

      expect(Project.count).to eq(6)

      visit root_path

      fill_in('sfirstname', with:"Testi")
      fill_in('slastname', with:"Testinen")
      fill_in('studentnumber', with:"1234567")
      fill_in('email', with:"testi@testi.fi")

      select('1', from:'p1[project_id]')
      select('2', from:'p2[project_id]')
      select('3', from:'p3[project_id]')
      select('4', from:'p4[project_id]')
      select('5', from:'p5[project_id]')
      select('6', from:'p6[project_id]')

      user= Student.find_by studentnumber:'1234567'
  #    hash= Enrollment.create_hash(user)
  #    expect(page).to have_content 'http://ilmoprojekti.herokuapp.com/enrollments/edit/' + user.id + '/' + hash 
    end

    it "redirets to confirmation page containing information about signups" do
       FactoryGirl.create :projectbundle

      generate_six_unique_projects_with_user(1)
      @projects = Project.all

      expect(Project.count).to eq(6)

      visit root_path

      fill_in('sfirstname', with:"Testi")
      fill_in('slastname', with:"Testinen")
      fill_in('studentnumber', with:"1234567")
      fill_in('email', with:"testi@testi.fi")

      select('1', from:'p1[project_id]')
      select('2', from:'p2[project_id]')
      select('3', from:'p3[project_id]')
      select('4', from:'p4[project_id]')
      select('5', from:'p5[project_id]')
      select('6', from:'p6[project_id]')

      click_button('Ilmoittaudu')
      expect(page).to have_content('1. valinta:' )
      expect(page).to have_content('2. valinta: ')
      expect(page).to have_content('3. valinta: p3[name]')
      expect(page).to have_content('4. valinta: p4[name]')
      expect(page).to have_content('5. valinta: p5[name]')
      expect(page).to have_content('6. valinta: p6[name]')
    end

 

  end

end