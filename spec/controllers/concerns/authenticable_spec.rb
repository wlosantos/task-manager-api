require 'rails_helper'

RSpec.describe Authenticable, type: :controller do

  controller(ApplicationController) do
    include Authenticable
  end

  let(:app_controller) { subject }

  describe '#authenticate_with_token!' do
    controller do
      before_action :authenticate_with_token!

      def restricted_ation; end
    end

    context 'when there is no user logged in' do
      before do
        allow(app_controller).to receive(:current_user).and_return(nil)
        routes.draw { get 'restricted_ation' => 'anonymous#restricted_ation' }
        get :restricted_ation
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe '#user_logged_in?' do
    context 'when there is a user logged in' do
      before do
        user = create(:user)
        allow(app_controller).to receive(:current_user).and_return(user)
      end

      it { expect(app_controller.user_logged_in?).to be true }
    end

    context 'when there is no user logged in' do
      before do
        allow(app_controller).to receive(:current_user).and_return(nil)
      end

      it { expect(app_controller.user_logged_in?).to be false }
    end
  end

end
