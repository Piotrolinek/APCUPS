import smtplib
import argparse
import configparser
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def read_config(configfile):
    config = configparser.ConfigParser()
    config.read("/home/cti/APCUPS/sender_config.ini")
    if 'REQUIRED' not in config:
        raise Exception("REQUIRED section not found in configuration file!")
    missing_fields = [key for key, value in config['REQUIRED'].items() if not value.strip()]

    if missing_fields:
        raise Exception(f"Missing values in REQUIRED section: {', '.join(missing_fields)}")
    sender_address = config['REQUIRED']["sender_address"]
    receiver_address = config['REQUIRED']["receiver_address"]
    sender_application_password = config['REQUIRED']["sender_application_password"]

    send_onbatt = config.getboolean('DEFAULT', 'send_onbatt', fallback=True)
    send_offbatt = config.getboolean('DEFAULT', 'send_offbatt', fallback=True)
    subject_onbatt = config.get('DEFAULT', "subject_onbatt", fallback='UPS Alert: Power Loss')
    subject_offbatt = config.get('DEFAULT', "subject_offbatt", fallback='UPS Info: Power Restored')
    body_onbatt = config.get('DEFAULT', "body_onbatt", fallback='The UPS has switched to battery power. Please check the system.')
    body_offbatt = config.get('DEFAULT', "body_offbatt", fallback='The UPS has switched back to AC power.')
    return sender_address, receiver_address, sender_application_password, send_onbatt, send_offbatt, subject_onbatt, subject_offbatt, body_onbatt, body_offbatt

def send_email(sender_email, app_password, receiver_email, subject, body):
    SMTP_SERVER = 'smtp.gmail.com'
    SMTP_PORT = 587

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
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Send UPS alert emails based on UPS events.")
    parser.add_argument('--onbatt', action='store_true', help="Trigger email alert for 'on battery' event.")
    parser.add_argument('--offbatt', action='store_true', help="Trigger email alert for 'off battery' event.")
    args = parser.parse_args()

    sender_address, receiver_address, sender_application_password, send_onbatt, send_offbatt, subject_onbatt, subject_offbatt, body_onbatt, body_offbatt = read_config("sender_config.ini")
    
    if args.onbatt and send_onbatt:
        subject = subject_onbatt
        body = body_onbatt
        send_email(sender_address, sender_application_password, receiver_address, subject, body)
    
    elif args.offbatt and send_offbatt:
        subject = subject_offbatt
        body = body_offbatt
        send_email(sender_address, sender_application_password, receiver_address, subject, body)