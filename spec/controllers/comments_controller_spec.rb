require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, author: user, question: question) }

    context 'question' do
      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(question.comments, :count).by(1)
        end

        it 'receives json response' do
          post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
          expect(response.headers['Content-Type']).to eq('application/json; charset=utf-8')
        end

        it 'saves a new user answer in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(user.comments, :count).by(1)
        end
      end
      context 'with invalid attributes' do
        it "doesn't save the comment" do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid_comment), question_id: question }, format: :js }.to_not change(Comment, :count)
        end

        it 'receives 422 response code' do
          post :create, params: { comment: attributes_for(:comment, :invalid_comment), question_id: question }, format: :js
          expect(response.status).to eq(422)
        end
      end
    end

    context 'answer' do
      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }.to change(answer.comments, :count).by(1)
        end

        it 'receives json response' do
          post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js
          expect(response.headers['Content-Type']).to eq('application/json; charset=utf-8')
        end

        it 'saves a new user answer in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }.to change(user.comments, :count).by(1)
        end
      end
      context 'with invalid attributes' do
        it "doesn't save the comment" do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid_comment), answer_id: answer }, format: :js }.to_not change(Comment, :count)
        end

        it 'receives 422 response code' do
          post :create, params: { comment: attributes_for(:comment, :invalid_comment), answer_id: answer }, format: :js
          expect(response.status).to eq(422)
        end
      end
    end
  end

end
