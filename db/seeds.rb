Department.create!(department_name: "development")
Department.create!(department_name: "planning")

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             department_id: 1)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password,
               department_id: 1)
end

Report.create!(report_date: '2017-04-01', title: 'Hello', content: 'こんにちは', user_id: 1)