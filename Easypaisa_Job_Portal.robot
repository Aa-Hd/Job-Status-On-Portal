*** Settings ***
Library    Autosphere.Browser.Playwright
Library    D:\\Easypaisa_Bot\\upload_file_details.py
Library    Autosphere.FileSystem
Variables  config_reader.py      
Library    config_updater.py
Library    String
Library    Autosphere.Email.ImapSmtp   smtp_server=smtp.gmail.com  smtp_port=587
Task Setup  Authorize  account=${SENDER_GMAIL}  password=${GMAIL_PASSWORD}
#Suite Teardown    Run Keyword If Any Tests Failed    Failure Screenshot And Mail
#*** Variables ***
#${screenshot_name}=  EASYPAISA_ENG.png
*** Keywords ***
Open Webpage
    Open Browser      ${IP_ADDRESS}
    Maximize Browser Window
Login Portal
    Input Text    //input[@type="text" and @placeholder="Username"]    ${LOGIN_ID}
    Input Text   //input[@type="password" and @placeholder="Password"]    ${LOGIN_PASSWORD} 
    Click Button    Sign In
Find Job Status
    Wait Until Page Contains Element    //div[@class="col-sm-12"]     timeout=60
    Sleep    4s   reason=To monitor working of bot   
    # ${status}=  Run Keyword And Return Status   Page Should Contain Element   
    # ...    //tr[td[contains(normalize-space(), 'EB_EAS*AISA_') or contains(normalize-space(), 'eb_easypaisa_') or contains(normalize-space(), 'eb_Easypaisa_')]]//input[@value='Job Status']
    ${status}=  Run Keyword And Return Status   Page Should Contain Element   
    ...    //tr[td[contains(normalize-space(), 'TABEEB_') or contains(normalize-space(), 'tabeeb_') or contains(normalize-space(), 'Tabeeb_') or contains(normalize-space(), 'TABEB_') or contains(normalize-space(), 'tabeb_') or contains(normalize-space(), 'Tabeb_')]]//input[@value='Job Status']


    IF  ${status}==True
    
        ${current_progress}=  Get Text
        ...  //tr[td[contains(normalize-space(), 'TABEEB_') or contains(normalize-space(), 'tabeeb_') or contains(normalize-space(), 'Tabeeb_') or contains(normalize-space(), 'TABEB_') or contains(normalize-space(), 'tabeb_') or contains(normalize-space(), 'Tabeb_')]]//td//div[@role="progressbar"]
        ${current_progress_percentage}=  Split String  ${current_progress}  %
        #${current_progress_percentage}=  Set Variable  45
        #IF  ('${current_progress}'=='${previous_progress_in_percentage}') or ('${current_progress}'=='100% Complete (success)')
        IF  '${current_progress_percentage}[0]'=='${previous_progress_in_percentage}' or '${current_progress_percentage}[0]'== '100' 
            Send Message    
            ...    sender=${SENDER_GMAIL}
            ...    recipients=${RECIEVER_GMAIL}
            ...    subject="Bot Progress Message"
            ...    body="This message is sent to inform you about the Bot Progress that has reached to its maximum of ${current_progress_percentage}[0] percentage"
            
            Skip                                           #moves to teardown
            
        ELSE
            Click Element   
            ...    //tr[td[contains(normalize-space(), 'TABEEB_') or contains(normalize-space(), 'tabeeb_') or contains(normalize-space(), 'Tabeeb_') or contains(normalize-space(), 'TABEB_') or contains(normalize-space(), 'tabeb_') or contains(normalize-space(), 'Tabeb_')]]//input[@value='Job Status']    
            Take Screenshot
            Upload File
            Logging Out
            Update Ini Value    
            ...     D://Easypaisa_Bot//config.ini
            ...     JOB_PROGRESS
            ...     previous_progress_in_percentage
            ...     ${current_progress_percentage}[0]
        END
    ELSE
        Screenshot    //div[@class="col-sm-12"]    filename=${None}
        LOG   TABE*B_EASYPAISA_ENG : Job Entry Is Not Found
        Logging Out
    END
Take Screenshot
    Wait Until Page Contains Element    //div[@class="col-sm-12"]     timeout=60
    Sleep    4s    reason=To monitor working of bot
    Screenshot    //div[@class="col-sm-12"]    filename=${SCREENSHOT_NAME}                             #${screenshot_name}
Logging Out
    Click Element  //li//a[text()="Sign Out"]
    Sleep   4s     reason=To monitor working of bot
Upload File 
    Upload Via Sftp
    ...    local_path=${LOCAL_PATH}                                                      #D:\\hello world\\${screenshot_name}
    ...    remote_path=${REMOTE_PATH}                                   #Practice Workbook.xls #home\\amna\\tabeeb_easypaisa_obd_screenshot
    ...    hostname=${HOST_NAME}                           #192.168.1.139
    ...    port=${PORT}
    ...    username=${USER_NAME}
    ...    password=${PASSWORD}
Deleting Saved Screenshot
    Remove File   ${CURDIR}\\${SCREENSHOT_NAME}
Failure Screenshot And Mail
    Run Keyword And Ignore Error    Capture Page Screenshot    Failure_Screenshot.png
    Send Message    
    ...    sender=${SENDER_GMAIL}
    ...    recipients=${RECIEVER_GMAIL}
    ...    subject="Bot Failure Message"
    ...    body="this message is sent to inform you about the bot failure"
    ...    images=${OUTPUTDIR}\\Failure_Screenshot.png
    #Remove File    ${OUTPUTDIR}\\Failure_Screenshot.png
*** Tasks ***
Get Job Update
    Open Webpage
    Login Portal
    Find Job Status
    Deleting Saved Screenshot
    [Teardown]  Run Keywords
    ...    Run Keyword If Test Failed    Failure Screenshot And Mail
    # ...    AND
    # ...    Remove File    ${OUTPUTDIR}\\Failure_Screenshot.png
    ...    AND
    ...    Close Browser