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

  def send_invitation(record)
    Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> 'daniel@letsjamchicago.com',
        'Name'=> "Let's Jam Chicago"
      },
      'To'=> [
        {
          'Email'=> record['email'],
          'Name'=> record['name']
        }
      ],
      'Subject'=> "Let's Jam Chicago - You've been invited!",
      'TextPart'=> "You have been invited to an event. Please visit https://letsjamchicago.com/event/#{record['event_id']} to view the event.",
      'HTMLPart'=> "<!DOCTYPE html>
<html>
<head>
<meta charset=\"UTF-8\">
<title>Let's Jam Chicago Invitation</title>
</head>
<body style=\"color:black;font-family:sans-serif;margin:0;\">
<table width=\"100%\">
<tr>
<td style=\"background:#44B6E5;color:white;font-weight:600;font-size:24px;padding:10px 10px 0;\">
<img src=\"https://letsjamchicago.com/ljc-note-logo.gif\" height=\"30\" />
<p style=\"display:inline;height:100%;margin:0;padding:0;vertical-align:top;\">Let's Jam Chicago</p>
</td>
</tr>
</table>
<table width=\"100%\" style=\"text-align:center\">
<tr>
<td>
<p><strong>You have been invited to an event!</strong></p>
<p>Please click the button below to view the event.</p>
<a href=\"http://letsjamchicago.com/event/#{record['event_id']}\" style=\"text-decoration:none;background:#44B6E5;color:white;font-weight:600;font-size:16px;padding:10px;border:none;border-radius:5px;\">View event</a>
<p>If you are having trouble, please visit <a style=\"color:#44B6E5\" href=\"http://letsjamchicago.com/event/#{record['event_id']}\">http://letsjamchicago.com/event/#{record['event_id']}</a></p>
<p><strong>Happy jamming!</strong></p>
</td>
</tr>
</table>
</body>
</html>"
    }]
    )
  end
end