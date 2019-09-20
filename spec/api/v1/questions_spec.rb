require 'rails_helper'

describe 'Questions API', type: :request do
  let!(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2, author: user) }
      #let(:question) { questions.first }
      let(:question_id_min) { questions.pluck(:id).min }
      let(:question) { questions.select { |q| q.id == question_id_min }.first }

      #let(:question_response) { json['questions'].first }
      let(:question_response) { json['questions'].select { |x| x['id'] == question.id }.first }

      let!(:answers) { create_list(:answer, 3, author: user, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response.dig('author', 'id')).to eq question.author.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
    let!(:question) { create(:question, :with_file, :with_comment, :with_link, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      let(:link) { question.links.first }
      let(:link_response) { question_response['links'].first }
      let(:comment) { question.comments.first }
      let(:comment_response) { question_response['comments'].first }
      let(:file) { question.files.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all question public fiels' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains link object' do
        expect(question_response['links'].size).to eq 1
      end

      it 'returns all link public fields' do
        %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
          expect(link_response[attr]).to eq link.send(attr).as_json
        end
      end

      it 'contains file object' do
        expect(question_response['files'].size).to eq 1
      end

      it 'returns file url' do
        expect(question_response['files'].first).to match(rails_blob_path(file))
      end

      it 'contains comment object' do
        expect(question_response['comments'].size).to eq 1
      end

      it 'returns all comment public fields' do
        %w[id body commentable_type commentable_id created_at updated_at].each do |attr|
          expect(comment_response[attr]).to eq comment.send(attr).as_json
        end
      end
    end
  end

  describe 'POST api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'with valid attributed' do
      before do
        post(
          api_path,
          params: {
            question: attributes_for(:question),
            access_token: access_token.token
          },
          headers: headers
        )
      end

      it 'returns 201 status' do
        expect(response).to be_successful
      end

      it 'increases questions count by 1' do
        expect(Question.count).to eq 1
      end

      it 'returns fields of created question' do
        %w[id title body created_at updated_at].each do |attr|
          expect(json['question'].has_key?(attr)).to be_truthy
        end
      end
    end

    context 'with invalid attributes' do
      before do
        post(
          api_path,
          params: {
            question: attributes_for(:question, :invalid),
            access_token: access_token.token
          },
          headers: headers
        )
      end

      it 'returns 422' do
        expect(response).to be_unprocessable
      end

      it 'returns error for title' do
        expect(json.has_key?('title')).to be_truthy
      end
    end
  end

  describe 'PATCH api/v1/questions/:id' do
    let!(:question) { create(:question, :with_file, :with_comment, :with_link, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'with valid attributed' do
      before do
        patch(
          api_path,
          params: {
            question: { body: 'new_body', title: 'new_title' },
            access_token: access_token.token
          },
          headers: headers
        )
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'updates the question fields' do
        expect(json['question']['title']).to eq 'new_title'
        expect(json['question']['body']).to eq 'new_body'
      end

      it 'returns fields of updated question' do
        %w[id title body created_at updated_at].each do |attr|
          expect(json['question'].has_key?(attr)).to be_truthy
        end
      end
    end

    context 'with invalid attributes' do
      before do
        patch(
          api_path,
          params: {
            question: attributes_for(:question, :invalid),
            access_token: access_token.token
          },
          headers: headers
        )
      end

      it 'returns 422' do
        expect(response).to be_unprocessable
      end

      it 'returns error for title' do
        expect(json.has_key?('title')).to be_truthy
      end
    end
  end

  describe 'DELETE api/v1/questions/:id' do
    let!(:question) { create(:question, :with_file, :with_comment, :with_link, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    before do
      delete(
        api_path,
        params: {
          question: question,
          access_token: access_token.token
        },
        headers: headers
      )
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'decreases questions count by 1' do
      expect(Question.count).to eq 0
    end
  end

end
