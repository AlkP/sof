class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:edit, :update, :destroy]

  def edit
    unless current_user.author_of?(@answer)
      flash[:alert] = 'It\'s not your answer!'
      redirect_to @answer.question
    end
  end

  def update
    if current_user.author_of?(@answer) && @answer.update(answer_params)
      flash[:notice] = 'Your answer successfully updated.'
      redirect_to @answer.question
    else
      flash[:alert] = 'Your answer not updated.'
      render :edit
    end
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:alert] = 'Your answer not created.'
    end
    redirect_to question_path(@answer.question)
  end

  def destroy
    question = @answer.question
    if current_user.author_of?(@answer) && @answer.destroy
      flash[:notice] = 'Your answer successfully destroyed.'
    else
      flash[:alert] = 'It\'s not your answer!'
    end
    redirect_to question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
