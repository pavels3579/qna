require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  let(:link_url) { 'https://ya.ru' }
  let(:link_name) { 'ya.ru' }

  describe 'DELETE #destroy' do
    context 'answer' do
      let(:another_user) { create(:user) }
      let!(:answer) { create(:answer, question: question, author: user) }
      let!(:link) { create(:link, url: link_url, name: link_name, linkable: answer) }

      context 'by author' do
        before { login(user) }

        it "deletes the answer's link" do
          expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
        end

        it 'renders destroy' do
          delete :destroy, params: { id: link }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'by non-author' do
        before { login(another_user) }

        it "tries to delete the answer's link" do
          expect { delete :destroy, params: { id: link }, format: :js }.not_to change(Link, :count)
        end

        it 'receives 403 responce code' do
          delete :destroy, params: { id: link }, format: :js
          expect(response.status).to eq(403)
        end
      end

    end

    context 'question' do
      let(:another_user) { create(:user) }
      let!(:link) { create(:link, url: link_url, name: link_name, linkable: question) }

      context 'by author' do
        before { login(user) }

        it "deletes the question's link" do
          expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
        end

        it 'renders destroy' do
          delete :destroy, params: { id: link }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'by non-author' do
        before { login(another_user) }

        it "tries to delete the question's link" do
          expect { delete :destroy, params: { id: link }, format: :js }.not_to change(Link, :count)
        end

        it 'receives 403 responce code' do
          delete :destroy, params: { id: link }, format: :js
          expect(response.status).to eq(403)
        end
      end

    end

  end

end
