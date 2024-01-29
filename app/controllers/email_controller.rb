require 'mailjet'
class EmailController < ApplicationController

  def index
    variable = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> params[:email],
        'Name'=> params[:from]
      },
      'To'=> [
        {
          'Email'=> '007design.com@gmail.com',
          'Name'=> 'Daniel Hinds-Bond'
        }
      ],
      'Subject'=> "Let's Jam Chicago Contact Form",
      'TextPart'=> params[:message],
      # 'HTMLPart'=> '<h3>Dear passenger 1, welcome to <a href=\'https://www.mailjet.com/\'>Mailjet</a>!</h3><br />May the delivery force be with you!'
    }]
    )

    render json: {
      message: 'Email sent successfully'
    }
  end
end
