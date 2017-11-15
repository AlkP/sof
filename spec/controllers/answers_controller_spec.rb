require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user){ create( :user ) }
  let!(:answer){ create( :answer ) }

  context 'For the guest of the system' do
    describe 'POST #create' do
      context 'with valid attributes' do
        it 'don\'t save new answer in database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: answer.question_id } }.to_not change(Answer, :count)
        end

        it 'redirect to log in' do
          post :create, params: { answer: attributes_for(:answer), question_id: answer.question_id }
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'with invalid attributes' do
        it 'don\'t save new answer in database' do
          expect { post :create, params: { answer: attributes_for(:answer_invalid), question_id: answer.question_id } }.to_not change(Answer, :count)
        end

        it 'redirect to log in' do
          post :create, params: { answer: attributes_for(:answer_invalid), question_id: answer.question_id }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        before { patch :update, params: { question_id: answer.question_id, id: answer, answer: { body: "NewAnswer" } } }

        it 'redirect to log in' do
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { question_id: answer.question_id, id: answer, answer: { body: nil } } }

        it 'doesn\'t change answer' do
          answer.reload
          expect(answer.body).to eq answer.body
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'don\'t delete answer' do
        expect { delete :destroy, params: { id: answer} }.to_not change(Answer, :count)
      end

      it 'redirect to log in' do
        delete :destroy, params: { id: answer}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'For the registered user of the system' do
    before { sign_in(answer.user) }

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'save new answer in database' do
          expect { post :create, format: :js, params: { answer: attributes_for(:answer), question_id: answer.question } }.to change(answer.user.answers, :count).by(1)
        end

        it 'redirect to question show view' do
          post :create, format: :js, params: { question_id: answer.question, answer: { body: 'NewAnswer' } }
          #TODO expect(response).to redirect_to question_path(answer.question)
        end
      end

      context 'with invalid attributes' do
        it 'doesn\'t save the answer' do
          expect { post :create, format: :js, params: { answer: { body: nil }, question_id: answer.question } }.to_not change(Answer, :count)
        end

        it 'redirect to answer.question' do
          post :create, format: :js, params: { answer: { body: nil }, question_id: answer.question }
          #TODO expect(response).to redirect_to answer.question
        end
      end
    end
  end

  context 'The registered user is NOT the author of the answer', %q{
    If User not the author of the answer
    He should be forbidden access to edit, update, destroy
  } do
    before { sign_in(user) }

    describe 'GET #edit' do
      before { get :edit, params: { id: answer } }

      it 'show alert flash' do
        should set_flash[:alert].to('Access denied!')
      end

      it 'render show view' do
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        before { patch :update, params: { question_id: answer.question, id: answer, answer: { body: "NewAnswer" } } }

        it 'show alert flash' do
          should set_flash[:alert].to('Access denied!')
        end

        it 'redirect to the show question for updated answer' do
          expect(response).to redirect_to question_path(answer.question)
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { question_id: answer.question, id: answer, answer: { body: nil } } }

        it 'show alert flash' do
          should set_flash[:alert].to('Access denied!')
        end

        it 're-render edit view' do
          expect(response).to redirect_to question_path(answer.question)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'show alert flash' do
        delete :destroy, params: { id: answer }
        should set_flash[:alert].to('Access denied!')
      end

      it 'render show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end

  context 'The registered user is the author of the answer', %q{
    If User the author of the answer
    He can edit, update, destroy
  } do
    before { sign_in(answer.user) }

    describe 'GET #edit' do
      before { get :edit, format: :js, params: { id: answer } }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'render edit view' do
        expect(response).to render_template :edit
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        before { patch :update, format: :js, params: { question_id: answer.question, id: answer, answer: { body: "NewAnswer" } } }

        it 'change answer attributes' do
          answer.reload
          expect(answer.body).to eq 'NewAnswer'
        end

        it 'redirect to the show question for updated answer' do
          #TODO expect(response).to redirect_to question_path(answer.question)
        end
      end

      context 'with invalid attributes' do
        before { patch :update, format: :js, params: { question_id: answer.question, id: answer, answer: { body: nil } } }

        it 'doesn\'t change answer' do
          answer.reload
          expect(answer.body).to eq answer.body
        end

        it 're-render edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      before { @question  = answer.question }

      it 'delete answer' do
        expect { delete :destroy, params: { id: answer} }.to change(@question.answers, :count).by(-1)
      end

      it 'redirect to show question'do
        delete :destroy, params: { id: answer}
        expect(response).to redirect_to question_path(@question)
      end
    end
  end
end
