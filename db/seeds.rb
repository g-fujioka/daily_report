Department.create!(name: "開発部", state: true)
Department.create!(name: "事業企画部", state: true)

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
users = User.order(:created_at).take(50)
report_date = Date.today
users.each do |user|
  report_date = report_date.tomorrow
  title = Faker::Cat.breed
  content = Faker::Lorem.sentence(5)
  user.reports.create!(report_date: report_date, title: title, content: content)
end