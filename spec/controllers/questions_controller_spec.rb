require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  context 'For the guest of the system', %q{
    User do not need to log in
    If he wants see a question
    or in order to be able see a list question
    But He should be forbidden access to everything else
  } do
    describe 'GET #index' do
      let(:questions) { create_list(:question, 25) }
      before { get :index }

      it 'populates an array of all questions' do
        expect(assigns(:questions)).to match_array(Question.all.first(15))
      end

      it 'render index view' do
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      before { get :show, params: { id: question } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'don\'t assigns the new answer to @answer' do
        expect(assigns(:answer)).to_not be_a_new(Answer)
      end

      it 'render show view' do
        expect(response).to render_template :show
      end
    end

    describe 'GET #new' do
      before { get :new }

      it 'redirect to log in' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'don\'t save new question in database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
        end

        it 'redirect to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to new_user_session_path
        end
      end

      context 'with invalid attributes' do
        it 'don\'t save new question in database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
        end

        it 'redirect to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end

  context 'For the registered user of the system', %q{
    User need to log in
    If He wants create a question
    Also He sees list questions
  } do
    before { sign_in(question.user) }

    describe 'GET #index' do
      let(:questions) { create_list(:question, 25) }
      before { get :index }

      it 'populates an array of all questions' do
        expect(assigns(:questions)).to match_array(Question.all.first(15))
      end

      it 'render index view' do
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      before { get :show, params: { id: question } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'assigns the new answer to @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'render show view' do
        expect(response).to render_template :show
      end
    end

    describe 'GET #new' do
      before { get :new }

      it 'assigns a new question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'save new question in database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it 'redirect to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'with invalid attributes' do
        it 'doesn\'t save the question' do
          expect { post :create, params: { question: attributes_for(:question_invalid) } }.to_not change(Question, :count)
        end

        it 're-render new view' do
          post :create, params: { question: attributes_for(:question_invalid) }
          expect(response).to render_template :new
        end
      end
    end
  end

  context 'The registered user is NOT the author of the question', %q{
    If User not the author of the question
    He should be forbidden access to edit, update, destroy
  } do
    before { sign_in(user) }

    describe 'GET #edit' do
      before { get :edit, params: { id: question } }

      it 'show alert flash' do
        should set_flash[:alert].to('Access denied!')
      end

      it 'render show view' do
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it 'do not change question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

        it 'show alert flash' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
          should set_flash[:alert].to('Access denied!')
        end

        it 'redirects to the show view' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'show alert flash' do
        delete :destroy, params: { id: question.id }
        should set_flash[:alert].to('Access denied!')
      end

      it 'render show view' do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end

  context 'The registered user is the author of the question', %q{
    If User the author of the question
    He can edit, update, destroy
  } do
    before { sign_in(question.user) }

    describe 'GET #edit' do
      before { get :edit, params: { id: question } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'render edit view' do
        expect(response).to render_template :edit
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(assigns(:question)).to eq question
        end

        it 'change question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirects to the updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: { title: 'new title', body: nil } } }
        it 'doesn\'t change the question' do
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

        it 're-render edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      before { sign_in(question.user) }

      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to change(question.user.questions, :count).by(-1)
      end

      it 'show alert flash' do
        delete :destroy, params: { id: question.id }
        should set_flash[:notice].to('Question was successfully destroyed.')
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
