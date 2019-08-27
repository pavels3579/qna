require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:another_user) { create(:user) }

  describe 'POST #create' do
    before { login(another_user) }

    context 'with valid attributes' do
      it 'saves a new subscription in the database' do
        expect { post :create, params: { question_id: question }, format: :js }.to change(Subscription, :count).by(1)
      end

      it 'saves a new question subscription in the database' do
        expect { post :create, params: { question_id: question }, format: :js }.to change(question.subscriptions, :count).by(1)
      end

      it 'saves a new user subscription in the database' do
        expect { post :create, params: { question_id: question }, format: :js }.to change(another_user.subscriptions, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'receives 403 error' do
        question.subscriptions.create(user: another_user)
        post :create, params: { question_id: question }, format: :js
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'with valid attributes' do
      before do
        login(user)
        question.subscriptions.create(user: user)
      end

      it 'deletes the subscription' do
        expect { delete :destroy, params: { question_id: question }, format: :js }.to change(Subscription, :count).by(-1)
      end
    end

    context 'with invalid attributes' do
      before do
        login(another_user)
        question.subscriptions.create(user: user)
      end

      it 'receives 403 error' do
        delete :destroy, params: { question_id: question.id }, format: :js
        expect(response.status).to eq(403)
      end
    end
  end

end
