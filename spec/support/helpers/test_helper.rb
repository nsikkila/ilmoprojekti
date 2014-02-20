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
      projects[i] = FactoryGirl.create(:project, name: i+1, projectbundle_id:bundle_id)
    end
    projects
  end

  def generate_six_unique_projects_with_user(bundle_id)
    user = FactoryGirl.create(:user)
    projects = Array.new(6)
    (0..5).each do |i|
      projects[i] = FactoryGirl.create(:project, name: i+1, projectbundle_id:bundle_id, user_id:user.id)
    end
    projects
  end

  def create_objects_for_frontpage
    #FactoryGirl.create(:signup)
    @projectbundle = FactoryGirl.create(:projectbundle)
    @projects = generate_six_unique_projects(@projectbundle.id)
    @enrollment = FactoryGirl.build(:enrollment)

    6.times do
      @enrollment.signups << FactoryGirl.build(:signup)
    end
  end

end