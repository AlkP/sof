require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create( :question, title: 'Title', body: 'Body', user_id: user.id )}
  let(:answer){ create( :answer, body: 'MyAnswer', question_id: question.id, user_id: user.id ) }

  describe 'GET #edit' do
    before { sign_in(user) }

    before { get :edit, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

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
    before { sign_in(user) }

    context 'with valid attributes' do
      it 'save new answer in database' do
        expect { post :create, params: { question_id: question, answer: { body: 'NewAnswer' } } }.to change(user.answers, :count).by(1)
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
        expect(subject).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with log in user' do
      before { sign_in(user) }
  
      it 'delete answer' do
        answer
        expect { delete :destroy, params: { id: answer} }.to change(question.answers, :count).by(-1)
      end
  
      it 'redirect to show question'do
        delete :destroy, params: { id: answer}
        expect(response).to redirect_to question_path(question)
      end
    end
    
    context 'with not log in user' do
      it 'delete answer' do
        answer
        expect { delete :destroy, params: { id: answer} }.to_not change(Answer, :count)
      end

      it 'redirect to show question'do
        delete :destroy, params: { id: answer}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
