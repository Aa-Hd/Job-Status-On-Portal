This Bot will do the following steps: 
Bot will read all required variables' values from a config.ini file, 
Bot will Login to portal ,
Check for ["EASYPAISA"] job entry,
If "EASYPAISA" job entry is present:
    Bot will click "Job_Status" button And all "EASYPAISA" jobs will appear in a Table,
    Bot will take Screenshot of Table and save it,
    Then Bot will send this Screenshot to a remote server via sftp,
    And Bot Will SignOut. 
If "EASYPAISA" job entry is not present:
    Bot will take Screenshot of this Table, 
    And Paste it in Log for record and cross check(if the required job entry is really absent or it is present but Bot is not recognizing it),
    Then Bot will Sign Out.
If there is a failure at any step:
    Bot will send Failure Email via smtp, 
    and include screenshot of failure,
    Delete Screenshot,
    And will Close Browser.
