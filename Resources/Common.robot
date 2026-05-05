*** Settings ***
Documentation                   New test suite
Library                         QForce
Library                         QWeb
Library                         OperatingSystem
Suite Setup                     Open Browser                about:blank                 chrome
Suite Teardown                  Close All Browsers

*** Variables ***
${BROWSER}                      chrome
${home_url}                     ${login_url}/lightning/page/home
${login_url}                    https://login.salesforce.com/
${Username}                     santhoshkpasam@gmail.com.scaqa
${password}                     CFCloud@12345
${secret}                       NY3BXP26R5POOBKAQHQ7LPJNEHBFS6M7

*** Keywords ***
Setup Browser   
    Set Library Search Order    QWeb                        QForce
    Open Browser                about:blank                 ${BROWSER}
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    SetConfig                   DefaultTimeout              45s                         #sometimes salesforce is slow
    SetConfig                   Delay                       0.3
End Suite
    Close All Browsers

Login
    [Documentation]             Login to Salesforce instance
    GoTo                        ${login_url}
    TypeText                    Username                    ${username}                 delay=1
    sleep                       2
    TypeText                    Password                    ${password}
    ClickText                   Log In
   ${mfa_code}=                GetOTP                      ${username}                 ${secret}
   TypeText                    Verification Code           ${mfa_code}
    ClickText                   Verify

Home
    [Documentation]             Navigate to homepage, login if needed
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.           2
    Run Keyword If              ${login_status}             Login
    ClickText                   Home
    VerifyTitle                 Home | Salesforce

Wait
    [Documentation]             It will pause the test case for perticular secend
    Sleep                       15

Generate Unique Name
    [Arguments]                 ${base_name}
    ${ts}=                      Get Time                    epoch
    ${unique}=                  Catenate                    _                           ${base_name}                ${ts}
    [Return]                    ${unique}
