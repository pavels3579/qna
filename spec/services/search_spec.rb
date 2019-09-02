require 'rails_helper'

RSpec.describe Services::Search do
  it 'searches for question' do
    expect(Question).to receive(:search).with('test')
    subject.perform('question', 'test')
  end

  it 'searches for answer' do
    expect(Answer).to receive(:search).with('test')
    subject.perform('answer', 'test')
  end

  it 'searches for comment' do
    expect(Comment).to receive(:search).with('test')
    subject.perform('comment', 'test')
  end

  it 'searches for user' do
    expect(User).to receive(:search).with('test')
    subject.perform('user', 'test')
  end

  it 'searches for all' do
    expect(ThinkingSphinx).to receive(:search).with('test')
    subject.perform('thinking_sphinx', 'test')
  end

  it 'doesn\'t search if attribute is invalid' do
    expect(ThinkingSphinx).not_to receive(:search).with('error')
    subject.perform('error', 'test')
  end

  it 'returns nil if attribute is invalid' do
    expect(subject.perform('error', 'test')).to be_nil
  end
end
