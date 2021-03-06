module TestHelper

  def signin(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Kirjaudu sisään')
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
    FactoryGirl.create(:user)

    @projectbundle = FactoryGirl.create(:projectbundle)
    @projects = generate_six_unique_projects(@projectbundle.id)
    @enrollment = FactoryGirl.build(:enrollment)

    6.times do
      @enrollment.signups << FactoryGirl.build(:signup)
    end

    @enrollment.save

  end

  def create_enrollment_with_signups
    #FactoryGirl.create(:signup)
    FactoryGirl.create(:user)
    @projectbundle = FactoryGirl.create(:projectbundle)
    @projects = generate_six_unique_projects(@projectbundle.id)
    @enrollment = FactoryGirl.build(:enrollment)

    index = 1
    6.times do
      @enrollment.signups << FactoryGirl.build(:signup, project_id:index)
      index = index + 1
    end

    @enrollment.save
    return @enrollment
  end

  def create_two_enrollments_with_signups
    FactoryGirl.create(:user)
    @projectbundle = FactoryGirl.create(:projectbundle)
    @projects = generate_six_unique_projects(@projectbundle.id)
    @enrollment = FactoryGirl.build(:enrollment)

    index = 1
    6.times do
      @enrollment.signups << FactoryGirl.build(:signup, project_id:index)
      index = index + 1
    end

    @enrollment.save

    @enrollment2 = FactoryGirl.build(:enrollment1)

    index = 1
    6.times do
      @enrollment2.signups << FactoryGirl.build(:signup, project_id:index, status:false)
      index = index + 1
    end

    @enrollment2.save


  end

  def create_another_enrollment_with_signups
    #FactoryGirl.create(:signup)
   # FactoryGirl.create(:teacher)
    @projectbundle = FactoryGirl.create(:projectbundle)
    @projects = generate_six_unique_projects(@projectbundle.id)
    @enrollment = FactoryGirl.build(:enrollment1)

    index = 1
    6.times do
      @enrollment.signups << FactoryGirl.build(:signup, project_id:index, status:false)
      index = index + 1
    end

    @enrollment.save
    @projectbundle.save
    return @enrollment
  end

  def create_enrollments_with_signups_for_old_projects
    #FactoryGirl.create(:signup)
   # FactoryGirl.create(:user)
    @projectbundle = FactoryGirl.create(:projectbundle_closed)
    @projects = generate_six_unique_projects(@projectbundle.id)
    @enrollment = FactoryGirl.build(:enrollment)

    index = 1
    6.times do
      @enrollment.signups << FactoryGirl.build(:signup, project_id:index)
      index = index + 1
    end

    @enrollment.save
    return @enrollment
  end

  def create_signups_for_projectbundle(projectbundle)
    @projects = generate_six_unique_projects(projectbundle.id)
    @enrollment = FactoryGirl.build(:enrollment)

    index = 1
    6.times do
      @enrollment.signups << FactoryGirl.build(:signup, project_id:index)
      index = index + 1
    end

    @enrollment.save
  end


  end