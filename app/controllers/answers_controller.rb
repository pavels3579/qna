class AnswersController < ApplicationController
  before_action :load_question, only: [:new, :create, :index, :destroy]
  before_action :load_answer, only: [:show, :edit, :update, :destroy]

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

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to @answer.question
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
