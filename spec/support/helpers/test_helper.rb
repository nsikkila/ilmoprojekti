module TestHelper

  def signin(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end

  def generate_six_unique_projects(bundle_id)
    projects = Array.new(6)
    (0..5).each do |i|
      projects[i] = FactoryGirl.create(:project, name: i+1, bundle_id:i+1)
    end
    projects
  end

  def generate_six_unique_projects_with_user(bundle_id)
    user = FactoryGirl.create(:user)
    projects = Array.new(6)
    (0..5).each do |i|
      projects[i] = FactoryGirl.create(:project, name: i+1, bundle_id:i+1, user_id:user.id)
    end
    projects
  end

end