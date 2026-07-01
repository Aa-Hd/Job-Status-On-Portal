import configparser
import os

def get_variables():
    config = configparser.ConfigParser()
    config_path = os.path.join(os.path.dirname(__file__), 'config.ini')

    with open(config_path, 'r') as f:
        content =  f.read()
    config.read_string(content)

    variables = {}
    for key, value in config['DEFAULT'].items():
        variables[key] = value
    return variables
