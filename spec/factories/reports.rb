FactoryGirl.define do
  factory :report do
    report_date '2017-04-01'
    title 'こんにちは'
    content '今日はいい天気です'
    user
  end
end