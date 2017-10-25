require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create( :question )}

  describe 'GET #index' do
    let(:questions) { create_list( :question, 16 ) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions.first(15))
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers1) { create_list( :answer, 5, body: 'MyAnswer', question_id: question.id, user_id: question.user.id ) }
    let(:answer) { create( :answer )}
    before { get :show, params: { id: question } }
    
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end

    it 'populates an array of answers only for @question' do
      expect(assigns(:answers)).to match_array(answers1)
    end
  end

  describe 'GET #new' do
    before { sign_in(question.user) }

    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { sign_in(question.user) }

    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    before { sign_in(question.user) }

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

  describe 'POST #create' do
    before { sign_in(question.user) }

    context 'with valid attributes' do
      it 'save new question in database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(question.user.questions, :count).by(1)
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

  describe 'DELETE #destroy' do
    context 'with sign in user' do
      before { sign_in(question.user) }

      it 'delete question' do
        question
        expect { delete :destroy, params: { id: question } }.to change(question.user.questions, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
    
    context 'with sign in oter user' do
      let(:user){ create( :user ) }
      
      before { sign_in(user) }

      it 'delete question' do
        question
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'without sign in user' do
      it 'delete question' do
        question
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
