require 'rails_helper'

RSpec.describe FeedbackController, type: :controller do
  render_views

  describe 'GET #new' do
    subject { get :new }

    context 'when no URL is passed' do
      it { is_expected.to be_success }

      specify 'that no URL is set on the feedback instance' do
        subject
        expect(assigns(:feedback).url).to be_blank
      end
    end

    context 'when a URL is passed' do
      before  { request.env['HTTP_REFERER'] = '/foo' }
      it      { is_expected.to be_success }

      specify 'that the URL is set on the feedback instance' do
        subject
        expect(assigns(:feedback).url).to eq('/foo')
      end
    end
  end

  describe 'POST #create' do
    subject(:perform) { post :create, feedback: params }

    context 'with valid params' do
      let(:params) do
        {
          url: Faker::Internet.url,
          email: Faker::Internet.email,
          comment: Faker::ChuckNorris.fact
        }
      end

      specify 'that a record is created' do
        expect { subject }.to change(Feedback, :count).by(1)
      end

      describe 'the created feedback' do
        before  { perform }
        subject { Feedback.last }

        its(:url) { is_expected.to eq(params[:url]) }
        its(:email) { is_expected.to eq(params[:email]) }
        its(:comment) { is_expected.to eq(params[:comment]) }
      end
    end

    context 'with invalid params' do
      let(:params) { { url: Faker::Internet.url } }

      specify 'that a record is NOT created' do
        expect { subject }.to_not change(Feedback, :count)
      end
    end
  end
end
