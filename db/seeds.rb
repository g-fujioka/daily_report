Department.create!(department_name: "開発部", state: true)
Department.create!(department_name: "事業企画部", state: true)

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
#users = User.order(:created_at).take(6)
# 50.times do |n|
#  n = n % 10
#  report_date = "2017-04-0#{n}"
#  title = Faker::Cat.breed
#  content = Faker::Lorem.sentence(5)
#  users.each { |user| user.reports.create!(report_date: report_date, title: title,
#                                            content: content, user_id: user.id) }
