FactoryGirl.define do
	factory :user do
		username "Maija"
		password "Test123"
		password_confirmation "Test123"
    accesslevel 0
	end
end

FactoryGirl.define do
  factory :signup do
    student_id 1
    project_id 1
    priority 1
    status true
  end
end

FactoryGirl.define do
  factory :projectbundle do
  name "Testibundle"
  description "This is a test bundle created by factorygirl"
  active true
  end
end

FactoryGirl.define do
  factory :student do
    firstname "Testi"
    lastname "Testinen"
    studentnumber "013460745"
  end
end

FactoryGirl.define do
  factory :project do
    name "Testproject"
    description "This is a test project created by factorygirl"
    maxstudents 15
    user_id 1
    bundle_id 1
  end
end

