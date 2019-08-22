class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer, only: %i[show update destroy]

  authorize_resource

  def index
    question = Question.find(params[:question_id])
    answers = question.answers
    render json: answers, each_serializer: AnswersSerializer

  end

  def show
    render json: @answer
  end

  def create
    question = Question.find(params[:question_id])
    @answer = question.answers.new(answer_params)
    @answer.author = current_resource_owner

    if @answer.save
      render json: @answer, status: :created
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, status: :ok
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
