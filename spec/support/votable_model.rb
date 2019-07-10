RSpec.shared_examples 'votable' do
  let!(:user) { create :user }
  let!(:user1) { create :user }
  let!(:user2) { create :user }

  it '#vote_up as not  author of resource' do
    model.vote_up(user1)
    model.reload

    expect(model.vote_sum).to eq(1)
  end

  it '#vote_up as author of resource' do
    model.vote_up(model.author)
    model.reload

    expect(model.vote_sum).to_not eq(1)
  end

  it '#vote_down as not author of resource' do
    model.vote_down(user1)
    model.reload

    expect(model.vote_sum).to eq(-1)
  end

  it '#vote_down as author of resource' do
    model.vote_down(model.author)
    model.reload

    expect(model.vote_sum).to_not eq(-1)
  end

  it '#score_resource' do
    model.vote_up(user1)
    model.vote_up(user2)
    model.reload

    expect(model.vote_sum).to eq(2)
  end
end
