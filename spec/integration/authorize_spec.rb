require 'rails_helper'

RSpec.describe 'Authorized', :type => :request do

  context 'not saved user' do
    it 'try secret' do
      get '/secret'
      expect(response).to_not render_template('home/secret')
    end

    it 'try log_in with some email and password' do
      post '/sessions', params: {email: Faker::Internet.email, password: '33453454'}
      expect(response).to_not render_template('home/secret')
    end

    it 'try sign_up with correct password' do
      post '/users', params: {
          user: {
            email: Faker::Internet.email,
            password: '33453454',
            password_confirmation: '33453454'
          }
       }
      expect(response).to redirect_to('/secret')
    end

    it 'try sign_up with incorrect password' do
      post '/users', params: {
          user: {
              email: Faker::Internet.email,
              password: '33453454',
              password_confirmation: '3345'
          }
      }
      expect(response).to_not redirect_to('/secret')
    end
  end

  context 'saved user' do
    before do
      User.delete_all
      @user = User.create(email: Faker::Internet.email, password: '123455678', password_confirmation: '123455678')
    end

    context 'not log in' do
      it 'try with incorrect password' do
        post '/sessions', params: {email: @user.email, password: 'incorrect'}
        expect(response).to_not redirect_to('/secret')
      end

      it 'try with correct password' do
        post '/sessions', params: {email: @user.email, password: '123455678'}
        expect(response).to redirect_to(secret_path)
      end
    end

    context 'log in' do
      before do
        post '/sessions', params: {email: @user.email, password: '123455678'}
      end

      it 'try secret' do
        get '/secret'
        expect(response).to render_template('home/index')
      end
    end
  end
end