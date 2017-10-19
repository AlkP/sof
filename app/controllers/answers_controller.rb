class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @answer = Answer.new
    @answer.question_id = params[:question_id]
    puts "!"
    puts params[:question_id]
    puts "!"
    puts params.to_json
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
    params.require(:answer).permit(:body, :question_id)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
