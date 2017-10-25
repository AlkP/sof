class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all.page(params[:page])
  end

  def show
    @answers = @question.answers
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
    unless current_user.author_of?(@question)
      flash[alert] = 'It\'s not your question!'
      redirect_to question_path(@question)
    end
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question) && @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@question) && @question.destroy
      flash[:notice] = 'Your question successfully destroyed.'
    else
      flash[:alert] = 'It\'s not your question!'
    end
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
