import configparser

config = configparser.ConfigParser()
config['REQUIRED'] = {
    'Sender_address' : '',
    'Receiver_address' : '',
    'Sender_application_password' : '',
}
config['DEFAULT'] = {
    'Send_onbatt' : 'True',
    'Send_offbatt' : 'True',
    'Subject_onbatt' : 'UPS Alert: Power Loss',
    'Subject_offbatt' : 'UPS Info: Power Restored',
    'Body_onbatt' : 'The UPS has switched to battery power. Please check the system.',
    'Body_offbatt' : 'The UPS has switched back to AC power.',
}
with open('sender_config.ini', 'w') as configfile:
    config.write(configfile)