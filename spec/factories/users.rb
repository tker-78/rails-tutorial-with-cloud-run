FactoryBot.define do
  factory :user, class: User do
    name {"takuya kinoshita"}
    email {"kkk@gmail.com"}
    password {"password"}
    password_confirmation {"password"}
  end

  factory :other_user, class: User do
    name {"aaa"}
    email {"aaa@gmail.com"}
    password {"password"}
    password_confirmation {"password"}
  end
end
