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
      'HTMLPart'=> "<!DOCTYPE html>
<html>
<head>
<meta charset=\"UTF-8\">
<title>Let's Jam Chicago Password Reset</title>
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
<p><strong>Welcome to Let's Jam Chicago!</strong></p>
<p>Please click the button below to confirm your email address.</p>
<a href=\"http://letsjamchicago.com/confirm/#{token}\" style=\"text-decoration:none;background:#44B6E5;color:white;font-weight:600;font-size:16px;padding:10px;border:none;border-radius:5px;\">Confirm email</a>
<p>If you are having trouble, please visit <a style=\"color:#44B6E5\" href=\"http://letsjamchicago.com/confirm/#{token}\">http://letsjamchicago.com/confirm/#{token}</a></p>
<p><strong>Happy jamming!</strong></p>
</td>
</tr>
</table>
</body>
</html>"
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
      'HTMLPart'=> "<!DOCTYPE html>
<html>
<head>
<meta charset=\"UTF-8\">
<title>Let's Jam Chicago Password Reset</title>
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
<p>Please click the button below to reset your password.</p>
<a href=\"http://letsjamchicago.com/reset/#{token}\" style=\"text-decoration:none;background:#44B6E5;color:white;font-weight:600;font-size:16px;padding:10px;border:none;border-radius:5px;\">Reset password</a>
<p>If you are having trouble, please visit <a style=\"color:#44B6E5\" href=\"http://letsjamchicago.com/reset/#{token}\">http://letsjamchicago.com/reset/#{token}</a></p>
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
