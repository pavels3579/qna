require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    before { login(user) }
    let!(:question) { create(:question, author: user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

     it 'saves a new user answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(user.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'by author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'by non-author' do
      before { login(another_user) }

      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.not_to change(Answer, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

  end

end
