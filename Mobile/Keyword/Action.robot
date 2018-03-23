*** Settings ***
Library         AppiumLibrary
##For manage dictionary and retrieve CSV file
Library         Collections
Library         CSVLibrary
Library			BuiltIn
Library         String

#Resource	../Resource/MobilityValiable.robot
Resource	../Resource/MobilityUsers.robot
##Resource	../Resource/LoginElementUK.txt
##Resource	../Resource/LoginElementUKFleet.txt
#Resource	../Resource/LoginElementAT.txt
#Library  AppiumLibrary  #run_on_failutre=Selenium2Library.CapturePageScreenshot

*** Variables ***
#${RESOURCE DIR}    //Users//amosuser01//Desktop//Automation//GDF//Resource//
${RESOURCE DIR}  ..//Resource//
#${RESOURCE}  ${/}Users${/}amosuser01${/}Desktop${/}Automation${/}GDF${/}Resource${/}
${URL}	http://127.0.0.1:4723/wd/hub
@{PinAcces}  UKFleet
@{Platform}  Android  iOS
@{PlatformVersionAndriod}  5.1  6.0  7.0
@{AndroidDevice}  Galaxy J2  Galaxy S8
@{AppPackage}  com.austria.allianz.gdf.mobilityapp
@{AppActivity}  .SplashScreen
&{CsvFile}    Login=LoginObject.csv    Term=TermsofUseObject.csv    Dashboard=DashboardObject.csv    Tabbar=TabbarObject.csv
...    More=MoreObject.csv    MyClaim=ClaimObject.csv    Register=RegisterObject.csv    Contact=ContactObject.csv
${CsvLogin}  LoginObject.csv
${CsvLanguage}  LanguageCheck.csv
${CsvTerm}  TermsofUseObject.csv
${CsvDashboard}  DashboardObject.csv
${CsvTabbar}  TabbarObject.csv
${CsvMore}  MoreObject.csv
${Avation}  E://Software//Automation_SW//Build//Mobility-AGCS-8_Dec26.apk
${ATMaintenance}    E://Software//Automation_SW//Build//Mobility-AT-build-54Dec20.apk



*** Keywords ***

Open Mobility App
    [Arguments]    ${application}

    #Open Application	${URL}	platformName=Android	platformVersion=5.1.1     deviceName=Galaxy J2
	#Open Application	${URL}	platformName=@{Platform}[0]    platformVersion=@{PlatformVersionAndriod}[0]     deviceName=@{AndroidDevice}[0]    appPackage=@{AppPackage}[0]   appActivity=@{AppActivity}[0]
	#Open Application	${URL}	platformName=@{Platform}[0]    platformVersion=@{PlatformVersionAndriod}[0]     deviceName=@{AndroidDevice}[0]    app=//Users//amosuser01//Desktop//Automation//SW//apk//retail_1.0.11.apk
#	Open Application	${URL}	platformName=Android	platformVersion=7.0     deviceName=Galaxy S7    automationName=UiAutomator2    #appWaitActivity=SplashActivity
#	...  deviceid=ad0c1603a8b5e50b89    app=E://Software//Automation_SW//Build//Mobility-AGCS-8_Dec26.apk
	Open Application	${URL}	platformName=Android	platformVersion=7.0     deviceName=Galaxy S7    automationName=UiAutomator2    #appWaitActivity=SplashActivity
	...  deviceid=ad0c1603a8b5e50b89    app=${application}
	Log To Console    ........Opening application........
	Language Filter
	Find Object and Language Column  ${LANGUAGE}  ${APPNAME}


Log To Console
	[Arguments]  ${text}
		log	${text}\n	console=yes

Language Filter
    Log To Console  .......Start validate applicaton and language on opened application [edit].......
    Wait Until Page Contains  title_txt  20
    Log To Console  .......Enter in first screen.......
    ${LoginExist}=  Run Keyword And Return Status  Page Should Contain Element  login_button  10
    ${SignInExist}=  Run Keyword And Return Status  Page Should Contain Element  sign_in_button  10
#    ${RegisterExist}=  Run Keyword And Return Status  Page Should Contain Element  register_button  10
###  Display log to sepecify option we select
    Run Keyword if  ${LoginExist}  Log To Console    ........Detect Login Screen, capturing username field text.........
    Run Keyword if  ${SignInExist}  Log To Console  ........Detect First Screen, try capturing button text.........

###>>>> need improvement <<<< static implementation
    ${column}  set variable  none
    Run Keyword If    ${LoginExist}    Set Test Variable    ${column}    3
    Run Keyword If    ${SignInExist}    Set Test Variable    ${column}    4
#    Run Keyword If    ${SignInExist}    and    ${RegisterExist}     Set Test Variable    ${column}    4
#    Log To Console  This is Column value:: ${column}

    ${Marker}  set variable  none
    ${Marker}=  Run Keyword If  ${LoginExist}    Get Text  login_email_layout
    ${Marker}=  Run Keyword If  ${SignInExist}    Get Text  sign_in_button
    Log To Console  This is marker value:: ${Marker}
#    ${Marker}=  Run Keyword If  ${RegisterExist}    Get Text  register_button

    Run Keyword if  ${LoginExist}  Language Filter with Login Screen  ${column}  ${Marker}
    Run Keyword if  ${SignInExist}  Language Filter with First Screen  ${column}  ${Marker}

Language Filter with Login Screen
    [Arguments]  ${column}  ${Marker}
###>>>> need improvement <<<< Can check multiple object in screen to determind application and language
###  Initial variable
    @{LanguageList}  read csv file to list  ${RESOURCE DIR}${CsvLanguage}
	${LANGUAGE}  set variable  none
	${APPNAME}  set variable  none
	${LengthDict}  Get Length  ${LanguageList}
#	Log To Console  ${LengthDict}

    Log To Console    ........Identifying application and setting language at Login screen.........
	:For    ${index}    IN RANGE    1    ${LengthDict}
	\	Set Test Variable    ${ExpectedLanguage}    ${LanguageList[${index}][1]}
	\	Run Keyword If    '${Marker}' == '${LanguageList[${index}][${column}]}'    Set Test Variable    ${LANGUAGE}    ${ExpectedLanguage}
	\	Set Test Variable  ${ExpectedAppID}  ${LanguageList[${index}][0]}
	\	Run Keyword If  '${Marker}' == '${LanguageList[${index}][${column}]}'  Set Test Variable  ${APPNAME}  ${ExpectedAppID}
	Run Keyword If    '${LANGUAGE}' == 'none'    Set Test Variable    ${LANGUAGE}    NONE
	Run Keyword If    '${APPNAME}' == 'none'    Set Test Variable    ${APPNAME}    NONE
	Log To Console  ---Found that open application is ${APPNAME} while using language as ${LANGUAGE}---


Language Filter with First Screen
    [Arguments]  ${column}  ${Marker}
###<<<<>>>> need improvement <<<<>>>> Can check multiple object in screen to determind application and language
###  Initial variable
    @{LanguageList}  read csv file to list  ${RESOURCE DIR}${CsvLanguage}
	${LANGUAGE}  set variable  none
	${APPNAME}  set variable  none
	${LengthDict}  Get Length  ${LanguageList}
#	Log To Console  ${LengthDict}

    Log To Console    ........Identifying application and setting language at First Screen.........
	:For    ${index}    IN RANGE    1    ${LengthDict}
	\	Set Test Variable    ${ExpectedLanguage}    ${LanguageList[${index}][1]}
	\	Run Keyword If    '${Marker}' == '${LanguageList[${index}][${column}]}'    Set Test Variable    ${LANGUAGE}    ${ExpectedLanguage}
	\	Set Test Variable  ${ExpectedAppID}  ${LanguageList[${index}][0]}
	\	Run Keyword If  '${Marker}' == '${LanguageList[${index}][${column}]}'  Set Test Variable  ${APPNAME}  ${ExpectedAppID}
	Run Keyword If    '${LANGUAGE}' == 'none'    Set Test Variable    ${LANGUAGE}    NONE
	Run Keyword If    '${APPNAME}' == 'none'    Set Test Variable    ${APPNAME}    NONE
	Log To Console  ---Found that open application is ${APPNAME} while using language as ${LANGUAGE}---

Find Object and Language Column
    [Arguments]  ${LANG}    ${APP}
    Log To Console    .......Start mapping application and language column.......
    @{LanguageList}  read csv file to list  ${RESOURCE DIR}${CsvLogin}
    ${ObjectLenght}  Get Length  ${LanguageList}

    Set Test Variable  ${LanguageColumn}  100
    Set Test Variable  ${AppColumn}  100

    :FOR    ${INDEX}    IN RANGE    0  8
        \   Continue For Loop If  	'${AppColumn}' != '100' and '${LanguageColumn}' != '100'
#       \    Run Keyword If    '${LanguageList[0][${INDEX+1}]}' == 'null'    Exit For Loop
#       \    Log To Console   Column value is ${LanguageList[0][${INDEX}]} on index ${index}
        \    Run Keyword If    '${LanguageList[0][${INDEX}]}' == '${LANG}'    Set Test Variable  ${LanguageColumn}  ${INDEX}
        \    Run Keyword If    '${LanguageList[0][${INDEX}]}' == '${APP}'    Set Test Variable  ${AppColumn}  ${INDEX}
#       \    Log To Console    LangCol ${LanguageColumn} AppCol ${AppColumn}
    Run Keyword If    '${AppColumn}' == '100'    Log To Console    Input application ${APP} cannot found
    Run Keyword If    '${LanguageColumn}' == '100'    Log To Console    Input language ${LANG} cannot found
    Log To Console    ---Mapping column done found Applicaton column is ${AppColumn} and Language column is ${LanguageColumn}---

Assign Objects and Language
    [Arguments]  ${LANGUAGE}  ${APPNAME}  ${LANGUAGECOLUMN}  ${APPCOLUMN}    ${FILENAME}
#    Log To Console  language column is ${LANGUAGECOLUMN}
#    Log To Console  app column is ${APPCOLUMN}
	@{ObjectMapping}=  read csv file to list  ${RESOURCE DIR}${FILENAME}
	${length_dict}= 	Get Length  ${ObjectMapping}
	:For    ${loop}  IN RANGE  1  ${length_dict}
#  	    \   Log To Console  Number of loop is ${loop}
	    \   Run Keyword If    '${APPNAME}' == '${ObjectMapping[${loop}][0]}' and '${ObjectMapping[${loop}][1]}' == 'Text'  Set Test Variable  ${${ObjectMapping[${loop}][2]}}  ${ObjectMapping[${loop}][${LANGUAGECOLUMN}]}
#	    \   Run Keyword If    '${APPNAME}' == '${ObjectMapping[${loop}][0]}' and '${ObjectMapping[${loop}][1]}' == 'Text'  Log To Console  App value is ${ObjectMapping[${loop}][${LANGUAGECOLUMN}]}
	    \   Run Keyword If    '${APPNAME}' == '${ObjectMapping[${loop}][0]}' and '${ObjectMapping[${loop}][1]}' == 'Object'  Set Test Variable  ${${ObjectMapping[${loop}][2]}}  ${ObjectMapping[${loop}][${APPCOLUMN}]}
#	    \   Run Keyword If    '${APPNAME}' == '${ObjectMapping[${loop}][0]}' and '${ObjectMapping[${loop}][1]}' == 'Object'  Log To Console  Text value is ${ObjectMapping[${loop}][${APPCOLUMN}]}
    Set Global Variable    ${LANGUAGE}
	Set Global Variable    ${APPNAME}
	Set Global Variable    ${LanguageColumn}
	Set Global Variable    ${AppColumn}

Load Object and Language
    [Arguments]	${Screen}
    ${CsvFilename}=  get from dictionary  ${CsvFile}  ${Screen}
    Log To Console  ..... Loading Object and Language from ${CsvFilename} .....
    Assign Objects and Language  ${LANGUAGE}  ${APPNAME}  ${LanguageColumn}  ${AppColumn}  ${CsvFilename}
    Log To Console  ----- Loaded completed -----


Login With Specific User
	[Arguments]	${USER_LOGIN}	${PASSWORD_LOGIN}
	Log To Console   Logging in with username: "${USER_LOGIN}" and password: "${PASSWORD_LOGIN}"
	Load Object and Language  Login
	#Assign Objects and Language  ${LANGUAGE}  ${APPNAME}  ${LanguageColumn}  ${AppColumn}  ${CsvLogin}

    Set Test Variable  ${Access}  FALSE

	:FOR    ${element}    IN    @{PinAcces}
  	    \   Log To Console  Number of loop is ${element}
#  	    \   Log To Console  FIrst value is @{PinAcces}[${element}]
  	    \   Log To Console  value with ' is '${element}'
	    \   run keyword if  '${APPNAME}' == '${element}'  Set Test Variable  ${Access}  PIN
	run keyword if  '${Access}' == 'PIN'  Log To Console  ---we are going to run Pin access keyword---
	run keyword if  '${Access}' == 'PIN'  Login With Pin  ${USER_LOGIN}
	run keyword if  '${Access}' != 'PIN'  Log To Console  ---We using User password login---
	run keyword if  '${Access}' != 'PIN'  Login with username and password  ${USER_LOGIN}	${PASSWORD_LOGIN}

	#Wait Until Page Contains Element	${img_dash_logo}	20s

Login With Pin
	[Arguments]	${PIN_LOGIN}
	Log To Console   Logging in with Pin ID: "${PIN_LOGIN}".
	Wait Until Page Contains Element	id=${LoginUserInput}
	Input Text		id=${LoginUserInput}	${USER_LOGIN}
	Wait Until Page Contains Element    ${LoginButton}
    press keycode   4
	Click Element	${LoginButton}
	Check connection
	#Wait Until Page Contains Element	${img_dash_logo}	20s

Login with username and password
    [Arguments]	${USER_LOGIN}	${PASSWORD_LOGIN}
	Log To Console   Logging in with username: "${USER_LOGIN}" and password: "${PASSWORD_LOGIN}"
	Wait Until Page Contains Element	id=${LoginUserInput}
	Wait Until Page Contains Element	id=${LoginPasswordInput}
	Input Text		id=${LoginUserInput}	${USER_LOGIN}
	Input Password	id=${LoginPasswordInput}	${PASSWORD_LOGIN}
	Wait Until Page Contains Element    ${LoginButton}
    press keycode   4
	Click Element	${LoginButton}
	Check connection

Permission Allow
    [Arguments]    ${Response}
    ${SelectBtn}   set variable  something
    ${trigger}=  Run Keyword And Return Status  Wait Until Page Contains Element  id=com.android.packageinstaller:id/permission_message  10
#    run keyword if  ${trigger}
    run keyword unless  ${trigger}  Log To Console  ---There is no allow question pop-up---
    run keyword unless  ${trigger}  Return From Keyword

    Log To Console  ---Found Allow question process to selection---
    run keyword if  '${Response}' == 'deny'  Set test variable    ${SelectBtn}    com.android.packageinstaller:id/permission_deny_button
    run keyword if  '${Response}' == 'allow'  Set test variable    ${SelectBtn}    com.android.packageinstaller:id/permission_allow_button
    run keyword if  '${Response}' != 'allow'  and  '${Response}' != 'deny'  Log To Console  ---please input argument as 'allow' or 'deny'---
    run keyword if  '${Response}' != 'allow'  and  '${Response}' != 'deny'  Set test variable    ${SelectBtn}    none
    run keyword if  '${SelectBtn}' != 'none'  Click Element  ${SelectBtn}


Calendar selection Android
    [Arguments]    ${Date}   ${Month}   ${Year}

    click element  prev
    click element  next
    click Text   OK



Check connection
    ${Checker}=  Run Keyword And Return Status  Wait Until Page Contains Element  id=message  20
    Run Keyword if  ${Checker}  Log To Console  ........Please check your login information and internet connection then try again.........
    Run Keyword if  ${Checker}  Fail  Please check internet connection and try again.
    Run Keyword unless  ${Checker}  Log To Console    ........Login successfully with given information.........


Accept Terms of use
	Log To Console	........We are Accepting the Terms of use........
	Load Object and Language  Term
#	Assign Objects and Language  ${LANGUAGE}  ${APPNAME}  ${LanguageColumn}  ${AppColumn}  ${CsvTerm}
#	Log To Console    Printout ternsTitle value is ${TermsTitle}
#	Log To Console    Printout ternsTitle value is ${TermsCheckbox}
	Wait Until Page Contains Element	${TermsCheckbox}
	Wait Until Page Contains Element	${TermsTitle}	timeout=10s	error=Term of user screen doesn't exit or Login does not success
	element should be disabled  ${TermsLoginbutton}

	${text}	Get text	${TermsTitle}
	Log To Console  ----Check screen display correct text = ${Text}----
	Run Keyword If	'${text}'=='${TermTitletText}'	Click Element	${TermsCheckbox}
	Element Should Be Enabled	${TermsLoginbutton}
	Click Element	${TermsLoginbutton}
	Log To Console   ----Completed accept Term and condition then redirect to Dashboard screen----
	Dashboard Tutorial

Dashboard Tutorial
    Load Object and Language  Dashboard
	#Assign Objects and Language  ${LANGUAGE}  ${APPNAME}  ${LanguageColumn}  ${AppColumn}  ${CsvDashboard}
	Wait Until Page Contains Element    ${DashboardCloseButton}  20
	Log To Console	........New login user will see tutorial screen, need to handle tutorial........
	: FOR    ${INDEX}    IN RANGE    0    4
    \    Swipe Screen  R2L
#    Click Element    ${DashboardCloseButton}
	Log To Console  ----Close tuitorial screen on dashboard----

Swipe Screen
    [Arguments]	${Detail}
    RUN KEYWORD IF    '${Detail}' == 'R2L'  Swipe By Percent	90	50	10	50	# Swipes screen from right to left.
    RUN KEYWORD IF    '${Detail}' == 'L2R'  Swipe By Percent	10	50	90	50	# Swipes screen from left to right.
    RUN KEYWORD IF    '${Detail}' == 'CalDown'  Swipe By Percent	50	30	50	80	# Swipes calendar down.
    RUN KEYWORD IF    '${Detail}' == 'CalUp'  Swipe By Percent	50	70	50	40	# Swipes calendar up.
    RUN KEYWORD IF    '${Detail}' != 'L2R' and '${Detail}' != 'R2L'  Log To Console  ........ 'Swipe Screen' keyword accept only 'R2L' or 'L2R' argument........

Click Tabbar icon
    [Arguments]	${Tabbar}
    Set Test Variable    ${Icon}  100
    Set Test Variable    ${Object}   NONE

    log to console    ........Set variable done........
    @{ObjectMapping}=  read csv file to list  ${RESOURCE DIR}${CsvTabbar}
	${length_dict}= 	Get Length  ${ObjectMapping}
	log to console    ........Retrieve CSV file done........
	:For    ${loop}  IN RANGE  1  ${length_dict}
#  	    \   Log To Console  Number of loop is ${loop}
	    \   Run Keyword If    '${APPNAME}' == '${ObjectMapping[${loop}][0]}' and '${ObjectMapping[${loop}][1]}' == 'Layout'  Set Test Variable  ${Object}  ${ObjectMapping[${loop}][2]}
        \   Run Keyword If    '${APPNAME}' == '${ObjectMapping[${loop}][0]}' and '${ObjectMapping[${loop}][1]}' == '${Tabbar}'  Set Test Variable  ${Icon}  ${ObjectMapping[${loop}][2]}
    Log To Console  -----Value of Object is "${Object}" Value of Icon is "${Icon}"-----
    log to console    .......Get Layout and index done........
    Run Keyword and Ignore Error  Click Web element  ${Object}  ${Icon}
    log to console    -----Click ${Tabbar} successfully-----

Click Web element
    [Arguments]	${element}  ${Index}
    log to console  -----Clicking element "${element}" @ index of "${Index}"-----
#    log to console  index is ${Index}
    @{Layout}=  get webelements  ${element}
#    log to console    Elemend of layout @{Layout}
    Click Element  @{Layout}[${Index}]

Logout of Application
    [Arguments]	${Confirmation}
    #Assign Objects and Language  ${LANGUAGE}  ${APPNAME}  ${LanguageColumn}  ${AppColumn}  ${CsvMore}
    Load Object and Language  More
    log to console  ........Click 'More' Tabbar........
    Click Tabbar icon  More
    log to console  ........Display More screen, Then click 'Logout' button........
    click element   ${MoreLogout}
    log to console  .......[]........
    wait until page contains element  android:id/message
    log to console  ........Native pop-up message display continue to clicking ........

    Run Keyword If	'${Confirmation}' == 'Yes'    Logout click Yes
    Run Keyword If	'${Confirmation}' == 'No'    Logout click No
    Run Keyword If	'${Confirmation}' != 'Yes' and '${Confirmation}' != 'No'  log to console  ..!!!!..'Logout of Application' keyword accept only 'Yes' or 'No' argument..!!!!..

Logout click Yes
    click Text   Yes
    wait until page contains element  ${LoginUserInput}
    log to console  ........ Logout successful !! ........

Logout click No
    click Text   No
    log to console  ..!!!!..Cancel Logout ..!!!!..
    wait until page contains element  ${MoreTitle}

