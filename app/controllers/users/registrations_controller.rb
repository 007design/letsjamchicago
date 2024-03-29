# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
    else
      clean_up_passwords resource
      set_minimum_password_length
    end
    render json: resource.to_json(:only => ['id', 'name', 'email', 'neighborhoods', 'show_attending', 'findable'])
  end;

  protected

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end

  def update_resource(resource, params)
    if params[:current_password].blank?
     resource.update_without_password(params.except(:current_password))
    else
      resource.update_with_password(params)
    end
  end
end
