FactoryBot.define do
  factory :user, class: User do
    name {"takuya kinoshita"}
    email {"kkk@gmail.com"}
    password {"password"}
    password_confirmation {"password"}
    admin { false }
  end

  factory :other_user, class: User do
    name {"aaa"}
    email {"aaa@gmail.com"}
    password {"password"}
    password_confirmation {"password"}
    admin { false }
  end

  factory :admin, class: User do
    name { "admin" }
    email { "admin@gmail.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true}
  end
end
