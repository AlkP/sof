class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_question, only: [ :show, :edit, :update, :destroy ]
  before_action :check_access, only: [ :edit, :update, :destroy ]

  def index
    @questions = Question.all.page(params[:page])
  end

  def show
    @answer = Answer.new if user_signed_in?
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    if @question.save
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new, alert: 'Question was not created.'
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @question.destroy
      redirect_to questions_path, notice: 'Question was successfully destroyed.'
    else
      flash[:alert] = 'You didn\'t destroy question.'
      render :show
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def check_access
    redirect_to question_path(@question), alert: 'Access denied!' unless current_user.author_of?(@question)
  end
end
