class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new #build
    @question.build_best_answer_award
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    return head :forbidden unless current_user.its_author?(@question)
    @question.update(question_params)
  end

  def destroy
    @question.destroy if current_user.its_author?(@question)

    redirect_to questions_path
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question  }
      )
    )
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
                                :title,
                                :body,
                                files: [],
                                links_attributes: [:name, :url],
                                best_answer_award_attributes: %i[title image]
                                )
  end

end
