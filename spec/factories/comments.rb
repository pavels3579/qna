FactoryBot.define do
  factory :comment do
    body { "MyComment" }
  end

  trait :invalid_comment do
    body { nil }
  end
end
