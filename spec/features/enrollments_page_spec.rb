require 'spec_helper'
include TestHelper

describe "Enrollments page" do

  describe "Signup form" do

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

  end

end