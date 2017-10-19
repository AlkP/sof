class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  after_action :set_question, only: [:new]

  def show
  end

  def new
    @answer = Answer.new
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question
    else
      render :edit
    end
  end

  def create
    @answer = Answer.new(answer_params)
    set_question
    if @answer.save
      redirect_to @answer.question
    else
      render :new
    end
  end

  def destroy
    question = @answer.question
    @answer.destroy
    redirect_to question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @answer.question_id = params[:question_id]
  end
end
