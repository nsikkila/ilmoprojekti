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

      expect(page).to have_content("123456")
      #expect(page).to have_content("Prioriteetti 2:123456")
      #expect(page).to have_content("Prioriteetti 3:123456")
      #expect(page).to have_content("Prioriteetti 4:123456")
      #expect(page).to have_content("Prioriteetti 5:123456")
      #expect(page).to have_content("Prioriteetti 6:123456")


    end

    it "accepts enrollment with correct form values" do

      FactoryGirl.create :projectbundle

      generate_six_unique_projects_with_user(1)
      @projects = Project.all

      expect(Project.count).to eq(6)

      visit root_path

      fill_in('enrollment_firstname', with: "Testi")
      fill_in('enrollment_lastname', with: "Testinen")
      fill_in('enrollment_studentnumber', with: "1234567")
      fill_in('enrollment_email', with: "testi@testi.fi")

      select('1', from: 'enrollment[signups_attributes][0][project_id]')
      select('2', from: 'enrollment[signups_attributes][1][project_id]')
      select('3', from: 'enrollment[signups_attributes][2][project_id]')
      select('4', from: 'enrollment[signups_attributes][3][project_id]')
      select('5', from: 'enrollment[signups_attributes][4][project_id]')
      select('6', from: 'enrollment[signups_attributes][5][project_id]')

      expect {
        click_button('Tallenna ilmoittautuminen')
      }.to change { Signup.count }.by(6)

      expect(page).to have_content 'Nimi: Testi Testinen'
    end

    it "does not save if the enrollment has invalid data" do

      FactoryGirl.create :projectbundle

      generate_six_unique_projects_with_user(1)
      @projects = Project.all

      expect(Project.count).to eq(6)

      visit root_path

      fill_in('enrollment_firstname', with: "-1")
      fill_in('enrollment_lastname', with: "-1")
      fill_in('enrollment_studentnumber', with: "-1")
      fill_in('enrollment_email', with: "-1")

      select('1', from: 'enrollment[signups_attributes][0][project_id]')
      select('2', from: 'enrollment[signups_attributes][1][project_id]')
      select('3', from: 'enrollment[signups_attributes][2][project_id]')
      select('4', from: 'enrollment[signups_attributes][3][project_id]')
      select('5', from: 'enrollment[signups_attributes][4][project_id]')
      select('6', from: 'enrollment[signups_attributes][5][project_id]')

      click_button('Tallenna ilmoittautuminen')

      expect(Enrollment.count).to eq(0)
      expect(page).to have_content 'Opiskelijanumeron täytyy olla numeroista koostuva ja 7 merkkiä pitkä'
      expect(page).to have_content 'Sähköpostiosoitteen täytyy olla muotoa esi@merk.ki'

    end

    it "creates unique hash for users" do
      FactoryGirl.create :projectbundle

      generate_six_unique_projects_with_user(1)
      @projects = Project.all

      expect(Project.count).to eq(6)

      visit root_path

      fill_in('enrollment_firstname', with: "Testi")
      fill_in('enrollment_lastname', with: "Testinen")
      fill_in('enrollment_studentnumber', with: "1234567")
      fill_in('enrollment_email', with: "testi@testi.fi")

      select('1', from: 'enrollment[signups_attributes][0][project_id]')
      select('2', from: 'enrollment[signups_attributes][1][project_id]')
      select('3', from: 'enrollment[signups_attributes][2][project_id]')
      select('4', from: 'enrollment[signups_attributes][3][project_id]')
      select('5', from: 'enrollment[signups_attributes][4][project_id]')
      select('6', from: 'enrollment[signups_attributes][5][project_id]')

      click_button('Tallenna ilmoittautuminen')

      enroll= Enrollment.find_by studentnumber: '1234567'
      hash= Enrollment.create_hash(enroll)
      #expect(page).to have_content hash

      visit root_path

      fill_in('enrollment_firstname', with: "Kalle")
      fill_in('enrollment_lastname', with: "Kokeilu")
      fill_in('enrollment_studentnumber', with: "1234568")
      fill_in('enrollment_email', with: "kok@kok.fi")

      select('1', from: 'enrollment[signups_attributes][0][project_id]')
      select('2', from: 'enrollment[signups_attributes][1][project_id]')
      select('3', from: 'enrollment[signups_attributes][2][project_id]')
      select('4', from: 'enrollment[signups_attributes][3][project_id]')
      select('5', from: 'enrollment[signups_attributes][4][project_id]')
      select('6', from: 'enrollment[signups_attributes][5][project_id]')

      click_button('Tallenna ilmoittautuminen')

      enroll= Enrollment.find_by studentnumber: '1234568'
      hash1= Enrollment.create_hash(enroll)
      #expect(page).to have_content hash1

      expect(hash.equal? hash1).to be_false

    end

    it "redirects to confirmation page containing information about signups" do
      FactoryGirl.create :projectbundle

      generate_six_unique_projects_with_user(1)
      @projects = Project.all

      expect(Project.count).to eq(6)

      visit root_path

      fill_in('enrollment_firstname', with: "Testi")
      fill_in('enrollment_lastname', with: "Testinen")
      fill_in('enrollment_studentnumber', with: "1234567")
      fill_in('enrollment_email', with: "testi@testi.fi")

      select('1', from: 'enrollment[signups_attributes][0][project_id]')
      select('2', from: 'enrollment[signups_attributes][1][project_id]')
      select('3', from: 'enrollment[signups_attributes][2][project_id]')
      select('4', from: 'enrollment[signups_attributes][3][project_id]')
      select('5', from: 'enrollment[signups_attributes][4][project_id]')
      select('6', from: 'enrollment[signups_attributes][5][project_id]')

      click_button('Tallenna ilmoittautuminen')
      expect(page).to have_content('Henkilötiedot')
      expect(page).to have_content('Nimi: Testi Testinen')
      expect(page).to have_content('Opiskelijanumero: 1234567')
      expect(page).to have_content('Email: testi@testi.fi')

      @projects.each do |pro|
        expect(page).to have_content(pro.name)
      end

    end


  end

  describe "Enrollment edit" do

    # before :each do
    # FactoryGirl.create(:projectbundle)
    #  generate_six_unique_projects_with_user(1)
    #end
    it "does NOT display the edit page if the correct hash is not present" do
      enrollment = create_enrollment_with_signups()

      #visit enrollment_path(enrollment)
      visit "enrollments/#{enrollment.id}/feikkihash"


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
    end

    it "displays the edit page when the correct hash IS present" do
      enrollment = create_enrollment_with_signups()

      #visit enrollment_path(enrollment)
      hash = Enrollment.create_hash(enrollment)
      visit "enrollments/#{enrollment.id}/#{hash}"

      expect(page).to have_content("Ilmoittautumisen muokkaus")

    end

    it "allows the editing of enrollment and saves changes if deadline not passed" do
      enrollment = create_enrollment_with_signups

      hash = Enrollment.create_hash(enrollment)

      visit "enrollments/#{enrollment.id}/#{hash}"

      fill_in('enrollment_firstname', with: "edit")
      fill_in('enrollment_lastname', with: "edit")
      fill_in('enrollment_studentnumber', with: "7654321")
      fill_in('enrollment_email', with: "edit@testi.fi")

      click_button('Tallenna ilmoittautuminen')

      expect(page).to have_content("Ilmoittautuminen onnistui!")
      expect(page).to have_content("Muokkaa")
      expect(page).to have_content("7654321")
      #save_and_open_page

    end

    it "doesnt allow editing if deadline has passed" do
      enrollment = create_enrollments_with_signups_for_old_projects
      hash = Enrollment.create_hash(enrollment)

      visit "enrollments/#{enrollment.id}/#{hash}"

      expect(page).to have_content("Ilmottautumisen muokkaus ei ole enää mahdollista")
    end
  end
end