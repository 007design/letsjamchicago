# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super do
      sign_in(resource) if resource.errors.empty?
    end
  end

  protected

  def respond_with_navigational(*args, &block)
    redirect_to '/account'
  end
end
