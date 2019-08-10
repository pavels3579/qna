class AnswersController < ApplicationController
  include Voted
  include ApplicationHelper

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:update, :destroy, :mark_as_best]
  after_action  :publish_answer, only: %i[create]

  def index
    @answers = @question.answers
  end

  def show; end

  def new
    @answer = @question.answers.new
  end

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    @answer.save
  end

  def update
    return head :forbidden unless current_user.its_author?(@answer)

    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    return head :forbidden unless current_user.its_author?(@answer)

    @answer.destroy
  end

  def mark_as_best
    return head :forbidden unless current_user.its_author?(@answer.question)

    @answer.mark_as_best
  end

  private

  def publish_answer
    return if @answer.errors.any?

    links = []
    @answer.links.each do |link|
      if gist?(link[:url])
        GistService.new(link[:url]).content.each do |gist_file|
          links << { name: gist_file[:file_name], url: gist_file[:file_content] }
        end
      else
        links << { name: link.name, url: link.url }
      end
    end

    files = []
    @answer.files.each do |file|
      files << { url: url_for(file), name: file.filename.to_s }
    end
    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}/answers",
      answer: @answer,
      author_id: @answer.author_id,
      links: links,
      files: files
    )
  end


  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                    links_attributes: %i[name url])
  end

end
