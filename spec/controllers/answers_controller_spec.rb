require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'saves a new user answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(user.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js } }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:another_user) { create(:user) }
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'by author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'by non-author' do
      before { login(another_user) }

      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.not_to change(Answer, :count)
      end

      it 'receives 403 responce code' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response.status).to eq(403)
      end
    end

  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, author: user) }

    context 'with valid attributes' do

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end

    end

  end

  describe 'PATCH #mark_as_best' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'by author' do
      before { login(user) }
      it 'changes answer as the best in the database' do
        patch :mark_as_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to eq true
      end

      it 'renders mark_as_best view' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(response).to render_template :mark_as_best
      end
    end

    context 'by non-author' do
      let(:another_user) { create(:user) }
      before { login(another_user) }

      it 'tries to delete the answer' do
        expect {patch :mark_as_best, params: { id: answer }, format: :js}.not_to change(Answer.where(best: true), :count)
      end

      it 'receives 403 responce code' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(response.status).to eq(403)
      end

    end

  end

  it_behaves_like 'voted' do
    let(:model) { create :answer, question: question, author: user }
  end

end
