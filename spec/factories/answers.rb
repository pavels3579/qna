FactoryBot.define do
  sequence :body do |n|
    "MyAnswerText#{n}"
  end

  factory :answer do
    body

    trait :invalid_body do
      body { nil }
    end

    trait :with_comment do
      after(:create) { |answer| create(:answer_comment, commentable: answer, user: answer.author) }
    end

    trait :with_file do
      files { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    end

    trait :with_link do
      after(:create) { |answer| create(:link, linkable: answer) }
    end
  end

end
