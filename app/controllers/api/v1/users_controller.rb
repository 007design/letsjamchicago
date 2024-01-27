class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user.to_json(:only => ['name', 'email'])
  end
end
