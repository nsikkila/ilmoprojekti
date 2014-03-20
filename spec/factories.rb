FactoryGirl.define do
	factory :user do
		username "Maija"
		password "Test123"
		password_confirmation "Test123"
    accesslevel 0
	end
end

FactoryGirl.define do
  factory :teacher, class: User do
    username "testi"
    firstname "testi"
    lastname "testinen"
    password "Opettaja1"
    password_confirmation "Opettaja1"
    accesslevel 1
  end
end

FactoryGirl.define do
  factory :signup do
    enrollment_id 1
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
  signup_start Date.current
  signup_end Date.tomorrow
  end
end

FactoryGirl.define do
  factory :enrollment do
    firstname "Testi"
    lastname "Testinen"
    studentnumber "1234567"
    email "test@email.com"
  end
end

FactoryGirl.define do
  factory :enrollment1, class:Enrollment do
    firstname "Jaska"
    lastname "Jokunen"
    studentnumber "1234561"
    email "test@email.com"
  end
end

FactoryGirl.define do
  factory :project do
    name "Testproject"
    description "This is a test project created by factorygirl"
    maxstudents 15
    user_id 1
    projectbundle_id 1
  end
end


FactoryGirl.define do
  factory :projectbundle_closed, class:Projectbundle do
    name "Menneet"
    description "This is an old projectbundle"
    active true
    signup_start Date.today - 7
    signup_end Date.yesterday
  end
end


