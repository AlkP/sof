class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_answer, only: [:show]
  before_action :set_question, only: [:new, :create]
  before_action :protected_set_answer, only: [:edit, :update, :destroy]

  def show
  end

  def new
    @answer = @question.answers.new
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
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to @answer.question
    else
      render :new
    end
  end

  def destroy
    question = @answer.question
    @answer.destroy
    flash[:notice] = 'Your answer successfully destroyed.'
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
    @question = Question.find(params[:question_id])
  end

  def protected_set_answer
    @answer = current_user.answers.find(params[:id])
  end
end
