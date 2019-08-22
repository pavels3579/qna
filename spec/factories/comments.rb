FactoryBot.define do
  factory :comment do
    body { "MyComment" }
  end

  trait :invalid_comment do
    body { nil }
  end

  factory :question_comment, class: Comment do
    association :commentable, factory: :question
    body { "question_comment" }
  end

  factory :answer_comment, class: Comment do
    association :commentable, factory: :answer
    body { "answer_comment" }
  end
end
