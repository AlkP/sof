require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create( :question, title: 'Title', body: 'Body', user_id: user.id )}
  let(:answer){ create( :answer, body: 'MyAnswer', question_id: question.id ) }

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    context ' with valid attributes' do
      before { patch :update, params: { question_id: question, id: answer, answer: { body: "NewAnswer" } } }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'NewAnswer'
      end

      it 'redirect to the show question for updated answer' do
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { question_id: question, id: answer, answer: { body: nil } } }

      it 'doesn\'t change answer' do
        answer.reload
        expect(answer.body).to eq 'MyAnswer'
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save new answer in database' do
        expect { post :create, params: { question_id: question, answer: { body: 'NewAnswer' } } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question show view' do
        post :create, params: { question_id: question, answer: { body: 'NewAnswer' } }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t save the answer' do
        expect { post :create, params: { question_id: question, answer: { body: nil } } }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { question_id: question, answer: { body: nil } }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'delete answer' do
      answer
      expect { delete :destroy, params: { id: answer} }.to change(question.answers, :count).by(-1)
    end

    it 'redirect to show question'do
      delete :destroy, params: { id: answer}
      expect(response).to redirect_to question_path(question)
    end
  end
end
