Factory.define :user do |user|
  user.email                 "test1@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

=begin
FactoryGirl.define do
  factory :user do
    email                 "test1@example.com"
    password              "foobar"
    password_confirmation "foobar"
    remember_me           false
  end
end

=end