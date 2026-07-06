import configparser
import os

def get_variables():
    config = configparser.ConfigParser()
    #config_path = os.path.join(os.path.dirname(__file__), 'config.ini')
    file_path="D://Easypaisa_Bot//config.ini"

    with open(file_path, 'r') as f:
        content =  f.read()
    config.read_string(content)

    variables = {}
    for section in ['DEFAULT','LOGIN_CREDS','SFTP_CREDS','SMTP_CREDS','JOB_PROGRESS']:
        for key, value in config[section].items():
            variables[key] = value
    return variables



# get_variables("D://Easypaisa_Bot//config.ini")
