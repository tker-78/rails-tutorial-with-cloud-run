FactoryBot.define do
  factory :user do
    name {"takuya kinoshita"}
    email {"kkk@gmail.com"}
    password {"password"}
    password_confirmation {"password"}
  end

  factory :user2 do
    name {"aaa"}
    email {"aaa@gmail.com"}
    password {"password"}
    password_confirmation {"password"}
  end
end
