class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:update, :destroy, :mark_as_best]

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

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
