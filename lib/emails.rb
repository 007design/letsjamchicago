require 'mailjet'

module Emails
  def send_contact_form(params)
    variable = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> 'daniel@letsjamchicago.com',
        'Name'=> 'LetsJamChicago'
      },
      'To'=> [
        {
          'Email'=> '007design.com@gmail.com',
          'Name'=> 'Daniel Hinds-Bond'
        }
      ],
      'Subject'=> "Let's Jam Chicago Contact Form",
      'TextPart'=> "#{params[:message]}\n\nUser email: #{params[:email]}\nUser name: #{params[:from]}",
      # 'HTMLPart'=> ''
    }]
    )
  end
end