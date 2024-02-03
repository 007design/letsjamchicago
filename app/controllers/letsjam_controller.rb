require 'emails'

class LetsjamController < ApplicationController
  include Emails

  def index
  end

  def contact
    send_contact_form(params)
    render json: {
      message: 'Email sent successfully'
    }
  end
end
