FactoryGirl.define do
	factory :user do
		username "Maija"
		password "Test123"
		password_confirmation "Test123"
	end
end

FactoryGirl.define do
	factory :user_with_too_short_username, :class => User do
		username "Ab"
		password "Test123"
		password_confirmation "Test123"
	end
end
