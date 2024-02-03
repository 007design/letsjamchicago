# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  respond_to :json
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   # super
  #   self.resource = resource_class.send_reset_password_instructions(resource_params)
  #   p self.resource
  #   yield resource if block_given?

  #   if successfully_sent?(resource)
  #     p 'here'
  #     p resource
  #     respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
  #   else
  #     'there'
  #     respond_with(resource)
  #   end
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   p 'testing'
  #   self.resource = resource_class.new
  #   set_minimum_password_length
  #   resource.reset_password_token = params[:reset_password_token]

  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def send_reset_password_instructions(params)
  #   p 'TESTINGTESTINGTESTING'
  # end

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
