class AnswersController < ApplicationController
  protect_from_forgery except: :edit

  before_action :authenticate_user!
  before_action :set_answer, except: [ :create ]
  before_action :check_access, except: [ :create ]

  def update
    unless @answer.update(answer_params)
      render :edit
    end
  end

  def create
    @answer = current_user.answers.build(answer_params.merge(question_id))
    if @answer.save
      @answer_new = Answer.new
    else
      @answer_new = @answer
    end
  end

  def edit
  end

  def destroy
    question = @answer.question
    if @answer.destroy
      redirect_to question, notice: 'Answer was successfully destroyed.'
    else
      redirect_to question, alert: 'Answer was not destroyed.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question_id
    params.permit(:question_id)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def check_access
    redirect_to question_path(@answer.question), alert: 'Access denied!' unless current_user.author_of?(@answer)
  end
end
