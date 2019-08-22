require 'rails_helper'

describe 'Answers API', type: :request do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, author: user, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
    let!(:answer) { create(:answer, :with_file, :with_comment, :with_link, author: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }
      let(:link) { answer.links.first }
      let(:link_response) { answer_response['links'].first }
      let(:comment) { answer.comments.first }
      let(:comment_response) { answer_response['comments'].first }
      let(:file) { answer.files.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all question public fiels' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains link object' do
        expect(answer_response['links'].size).to eq 1
      end

      it 'returns all link public fields' do
        %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
          expect(link_response[attr]).to eq link.send(attr).as_json
        end
      end

      it 'contains file object' do
        expect(answer_response['files'].size).to eq 1
      end

      it 'returns file url' do
        expect(answer_response['files'].first).to match(rails_blob_path(file))
      end

      it 'contains comment object' do
        expect(answer_response['comments'].size).to eq 1
      end

      it 'returns all comment public fields' do
        %w[id body commentable_type commentable_id created_at updated_at].each do |attr|
          expect(comment_response[attr]).to eq comment.send(attr).as_json
        end
      end
    end
  end

  describe 'POST api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'with valid attributed' do
      before do
        post(
          api_path,
          params: {
            answer: attributes_for(:answer),
            access_token: access_token.token
          },
          headers: headers
        )
      end

      it 'returns 201 status' do
        expect(response).to be_successful
      end

      it 'increases questions count by 1' do
        expect(question.answers.count).to eq 1
      end

      it 'returns fields of created answer' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'].has_key?(attr)).to be_truthy
        end
      end
    end

    context 'with invalid attributes' do
      before do
        post(
          api_path,
          params: {
            answer: attributes_for(:answer, :invalid_body),
            access_token: access_token.token
          },
          headers: headers
        )
      end

      it 'returns 422' do
        expect(response).to be_unprocessable
      end

      it 'returns error for title' do
        expect(json.has_key?('body')).to be_truthy
      end
    end
  end

  describe 'PATCH api/v1/answers/:id' do
    let!(:answer) { create(:answer, :with_file, :with_comment, :with_link, author: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'with valid attributed' do
      before do
        patch(
          api_path,
          params: {
            answer: { body: 'new_body' },
            access_token: access_token.token
          },
          headers: headers
        )
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'updates the answer fields' do
        expect(json['answer']['body']).to eq 'new_body'
      end

      it 'returns fields of updated answer' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'].has_key?(attr)).to be_truthy
        end
      end
    end

    context 'with invalid attributes' do
      before do
        patch(
          api_path,
          params: {
            answer: attributes_for(:answer, :invalid_body),
            access_token: access_token.token
          },
          headers: headers
        )
      end

      it 'returns 422' do
        expect(response).to be_unprocessable
      end

      it 'returns error for title' do
        expect(json.has_key?('body')).to be_truthy
      end
    end
  end

  describe 'DELETE api/v1/answers/:id' do
    let!(:answer) { create(:answer, :with_file, :with_comment, :with_link, author: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    before do
      delete(
        api_path,
        params: {
          answer: answer,
          access_token: access_token.token
        },
        headers: headers
      )
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'decreases questions count by 1' do
      expect(Answer.count).to eq 0
    end
  end
end
