import configparser
import os

def update_ini_value(file_path, section, key, value):
    """ All arguments must be given as strings i.e written in quotations.
        If given Section already exists ,then it will be updated.
        And if it doesnot exists,then it will be created.
        For Example: 
        file_path= 'E://Abc//def.ini'
        section= 'CREDTS'
        key= 'username'
        value='456'        
        Output>>>   [CREDS]
                    username = 456      """
    
    config = configparser.ConfigParser()
    config.read(file_path)

    if not config.has_section(section):
        config.add_section(section)

    config.set(section, key, value)

    with open(file_path, "w") as configfile:
        config.write(configfile)

# update_ini_value( "D://Easypaisa_Bot//config.ini" , "JOB_PROGRESS", "progress_in_percentage" ,"65")
