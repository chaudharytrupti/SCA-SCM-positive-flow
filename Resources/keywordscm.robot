
*** Settings ***
Library                         QForce
Documentation                   Example test case demonstrating proper library search order
Resource                        ../Resources/Common.robot
Suite Setup                     Open Browser                about:blank                 chrome
Suite Teardown                  Close All Browsers

*** Variables ***
${project}                      Trial - Salesforce Source Format
${team}                         Test
${developer}                    siri kavya
${Credential}                   Dev1-SFP
# ${Approval1}                  CustomTab
# ${Approval2}                  CustomField
# ${Approval3}                  Layout
# ${Approval4}                  CustomObject
${Approval1}                    Profile
${Approval2}                    SimpleAccountContactServiceTest
${Approval3}                    SimpleAccountContactService
${Approval4}                    CustomObject

${Exception1}                   PermissionSetGroup
${Exception2}                   Profile
${Exception3}                   RecordType
${Exception4}                   Layout

*** Keywords ***

Org Authentication
    Login
Shared Component Matrix Settings
    LaunchApp                   SCM Home
    VerifyAll                   Shared Component Matrix Settings,Metadata Types
    VerifyText                  Environments                Anchor=Available
    VerifyAll                   Shared Component Matrix Strategy,Approval Process
    VerifyAll                   Validity for Approval/Exception ,4 hours

Creating a Userstory   
    Clicktext                   User Stories
    ClickText                   New
    UseModal                    On
    ClickText                   User Story                  anchor=Select a record type
    ClickText                   Next                        delay=5
    UseModal                    On
    ${Title}=                   Generate Unique Name        SCMMetadataTest
    Set Suite Variable          ${Title}
    TypeText                    Title                       ${Title}                    delay=5
    ComboBox                    Search Projects...          ${project}
    ComboBox                    Search Teams...             ${team}
    ComboBox                    Search Credentials...       ${Credential}
    ComboBox                    Search People...            ${developer}
    ClickText                   Save                        partial_match=False
    Sleep                       10
    ${USERSTORY}                GetText                     US-
    Set Suite Variable          ${USERSTORY}
    Wait Until Keyword Succeeds                             3x                          200ms             Click Element               xpath=//button[.='Commit Changes']

Commit UserStory for Approval scenario
    VerifyText                  Commit Changes              delay=5
    VerifyText                  ${Credential}
    ClickText                   Select a date for Date
    ClickText                   Select a date for Date
    ClickText                   2                           partial_match=False
    ClickText                   Get Salesforce Changes
    Sleep                       5
    Clickelement                xpath=//lightning-base-formatted-text[text()='${Approval1}']/..//ancestor::lightning-primitive-cell-factory/../..//td//following-sibling::td//input
    Clickelement                xpath=//lightning-base-formatted-text[text()='${Approval2}']//ancestor::lightning-primitive-cell-factory//parent::td//preceding-sibling::td//following-sibling::td[@data-col-key-value='1-SELECTABLE_CHECKBOX-1']
    Clickelement                xpath=//lightning-base-formatted-text[text()='${Approval3}']//ancestor::lightning-primitive-cell-factory//parent::td//preceding-sibling::td//following-sibling::td[@data-col-key-value='1-SELECTABLE_CHECKBOX-1']
    Clickelement                xpath=//lightning-base-formatted-text[text()='${Approval4}']/..//ancestor::lightning-primitive-cell-factory/../..//td//following-sibling::td//input
    ClickElement                xpath=//button[text()='Cancel']//parent::lightning-button//following-sibling::lightning-button//button[text()='Commit Changes']    delay=5
    UseModal                    On
    VerifyText                  Commit Changes
    ClickElement                xpath=//button[text()='Commit']
    UseModal                    Off
    VerifyText                  SFDX Commit
    VerifyField                 Status                      In progress
    Wait Until Keyword Succeeds                             10 min                      10 sec            Verify Element              xpath=//b[text()='Job Execution Summary']/../..//following-sibling::lightning-layout-item//div/b[text()='Successful']
    VerifyText                  Successful
    VerifyField                 Status                      Complete

Commit UserStory for Exception scenario    
    VerifyText                  Commit Changes              delay=5
    VerifyText                  ${Credential}
    ClickText                   Select a date for Date
    ClickText                   Select a date for Date
    ClickText                   2                           partial_match=False
    ClickText                   Get Salesforce Changes
    Sleep                       5
    Clickelement                xpath=//lightning-base-formatted-text[text()='${Exception1}']/..//ancestor::lightning-primitive-cell-factory/../..//td//following-sibling::td//input[1]
    Clickelement                xpath=//lightning-base-formatted-text[text()='${Exception2}']/..//ancestor::lightning-primitive-cell-factory/../..//td//following-sibling::td//input
    Clickelement                xpath=//lightning-base-formatted-text[text()='${Exception3}']/..//ancestor::lightning-primitive-cell-factory/../..//td//following-sibling::td//input
    Clickelement                xpath=//lightning-base-formatted-text[text()='${Exception4}']/..//ancestor::lightning-primitive-cell-factory/../..//td//following-sibling::td//input
    ClickElement                xpath=//button[text()='Cancel']//parent::lightning-button//following-sibling::lightning-button//button[text()='Commit Changes']    delay=5
    UseModal                    On
    VerifyText                  Commit Changes
    ClickElement                xpath=//button[text()='Commit']
    UseModal                    Off
    VerifyText                  SFDX Commit
    VerifyField                 Status                      In progress
    Wait Until Keyword Succeeds                             10 min                      10 sec            Verify Element              xpath=//b[text()='Job Execution Summary']/../..//following-sibling::lightning-layout-item//div/b[text()='Successful']
    VerifyText                  Successful
    VerifyField                 Status                      Complete


Apex Code Coverage Configuration
    ClickFieldValue             User Story
    ClickText                   Deliver
    ClickText                   Edit                        partial_match=False
    UseModal                    On
    TypeText                    Apex Code Coverage          78
    ClickText                   Save                        partial_match=False
    UseModal                    Off

SC Matrix for Approval
    ClickText                   User Stories
    ClickText                   ${USERSTORY}
    ClickText                   SC Matrix
    ClickText                   Submit For Approval         anchor=Action
    UseModal                    On
    ClickText                   Submit for Approval         anchor=Cancel
    VerifyText                  Justification is Mandatory.
    ClickText                   Cancel
    ClickText                   Submit For Approval         anchor=Action
    TypeText                    Add Justification here...                               Test1_Approval
    ClickText                   Submit for Approval         anchor=Cancel
    SwitchWindow                NEW
    SwitchWindow                2
    ClickFieldValue             Requested User Story
    ClickText                   SC Matrix                   partial_match=False
    VerifyText                  Waiting for Approval
    LaunchApp                   SCM Home
    ClickText                   Take Action
    ClickText                   --None--                    parent=DIV
    ClickText                   Approved
    ClickText                   Submit
    VerifyText                  All required fields must be filled in.
    TypeText                    comments                    Approved1
    ClickText                   Submit
    ClickText                   User Stories
    ClickText                   ${USERSTORY}
    ClickText                   SC Matrix
    VerifyText                  Approved

SC Matrix for Exception
    ClickText                   User Stories
    ClickText                   ${USERSTORY}
    ClickText                   SC Matrix
    VerifyText                  SCM Exceptions Request
    ClickText                   SCM Exceptions Request
    UseModal                    On
    ClickText                   Submit Exception
    VerifyText                  Justification is Mandatory.
    TypeText                    Add Justification here...                               Test2_Exception
    ClickCheckbox               Select 1 item               on
    ClickText                   Submit Exception
    VerifyText                  SCM Exception Created successfully
    UseModal                    Off
    LaunchApp                   SCM Home
    ClickText                   Take Action
    ClickText                   --None--                    parent=DIV
    ClickText                   Approved
    TypeText                    comments                    ApprovedTest2
    ClickText                   Submit


Promote and Deploy
    Clicktext                   User Stories
    Clicktext                   ${USERSTORY}
    ClickText                   Deliver
    ClickText                   Edit Ready to Promote
    ClickCheckbox               Ready to Promote            on
    ClickCheckbox               Promote and Deploy          on
    ClickText                   Save    
    Clicktext                   User Story
    Sleep                       10
    RefreshPage
Checking Promotion record
    ClickText                   Deliver
    VerifyText                  User Story Promotions
    Wait Until Keyword Succeeds                             3x                          200ms             VerifyElement               xpath=xpath=//tbody//tr//th[@tabindex="0" and @data-label="Promoted User Story: Promoted User Story Name"]//following-sibling::td[1]//span[contains(text(),'P000')]
    ClickElement                xpath=//tbody//tr//th[@tabindex="0" and @data-label="Promoted User Story: Promoted User Story Name"]//following-sibling::td[1]//span[contains(text(),'P000')]
    VerifyField                 Status                      In Progress
    Wait Until Keyword Succeeds                             10 min                      10 sec            Verify Element              xpath=//b[text()='Job Execution Summary']/../..//following-sibling::lightning-layout-item//div/b[text()='Successful']
    VerifyField                 Status                      Completed
    VerifyAll                   SFDX Promote,SFDX Deploy,Successful
    Clicktext                   User Stories
    ClickText                   ${USERSTORY}
    VerifyText                  INT-SFP
    VerifyElement               //span[contains(.,"INT-SFP") and contains(.,"ahead") and contains(.,"behind")]
     
Checking for SCM Exception Provided
    Clicktext                   User Stories
    ClickText                   ${USERSTORY}
    Clicktext                   Build
    Verifyall                   SCM Exception Available,SCM Exception Provided
    VerifyElement               xpath=//span[text()='SCM Exception Provided']//parent::div//span[text()='True']
    VerifyElement               xpath=//span[text()='SCM Exception Available']//parent::div//span[text()='True']











