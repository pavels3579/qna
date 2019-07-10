RSpec.shared_examples 'voted' do
  let(:user) { create :user }
  let(:another_user) { create :user }

  describe 'PATCH #vote_up' do
    it 'user can vote up' do
      login(another_user)

      expect do
        patch :vote_up, params: { id: model }, format: :json
      end.to change(Vote, :count).by 1
    end

    it "author can't vote for his own resource" do
      login(model.author)
      patch :vote_up, params: { id: model }, format: :json

      expect(response).to have_http_status 403
    end
  end

  describe 'PATCH #vote_down' do
    it 'user can vote down' do
      login(another_user)

      expect do
        patch :vote_down, params: { id: model }, format: :json
      end.to change(Vote, :count).by 1
    end

    it "author can't vote for his own resource" do
      login(model.author)
      patch :vote_down, params: { id: model }, format: :json

      expect(response).to have_http_status 403
    end
  end
end
