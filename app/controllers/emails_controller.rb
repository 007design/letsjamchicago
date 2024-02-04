require 'mailjet'

class EmailsController < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def confirmation_instructions(record, token, opts = {})
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> 'daniel@letsjamchicago.com',
        'Name'=> "Let's Jam Chicago"
      },
      'To'=> [
        {
          'Email'=> record[:email],
          'Name'=> record[:name]
        }
      ],
      'Subject'=> "Let's Jam Chicago - Confirm Registration",
      'TextPart'=> "Welcome to Let's Jam Chicago!\n\nPlease visit http://letsjamchicago.com/confirm/#{token} to confirm your email address.",
      # 'HTMLPart'=> ''
    }]
    )
  end

  def reset_password_instructions(record, token, opts = {})
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> 'daniel@letsjamchicago.com',
        'Name'=> "Let's Jam Chicago"
      },
      'To'=> [
        {
          'Email'=> record[:email],
          'Name'=> record[:name]
        }
      ],
      'Subject'=> "Let's Jam Chicago - Reset Password",
      'TextPart'=> "Please visit http://letsjamchicago.com/reset/#{token} to reset your password.",
      # 'HTMLPart'=> ''
    }]
    )
  end
end
