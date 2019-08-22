FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  factory :question do
    title
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    trait :with_comment do
      after(:create) { |question| create(:question_comment, commentable: question, user: question.author) }
    end

    trait :with_file do
      files { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    end

    trait :with_link do
      after(:create) { |question| create(:link, linkable: question) }
    end
  end
end
