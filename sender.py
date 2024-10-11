import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

SMTP_SERVER = 'smtp.gmail.com'
SMTP_PORT = 587

#####################################
sender_email = '' # gmail address
app_password = '' # generated app password
#####################################

receiver_email = 'caceh53065@chainds.com'

subject = 'Test Email from Python Script'
body = 'This is a test email sent from a Python script using Google SMTP.'

message = MIMEMultipart()
message['From'] = sender_email
message['To'] = receiver_email
message['Subject'] = subject
message.attach(MIMEText(body, 'plain'))

try:
    server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
    server.starttls()

    server.login(sender_email, app_password)

    text = message.as_string()
    server.sendmail(sender_email, receiver_email, text)

    print('Email sent successfully!')

except Exception as e:
    print(f'Error sending email: {e}')

finally:
    server.quit()
