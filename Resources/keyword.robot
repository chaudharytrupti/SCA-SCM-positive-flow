*** Settings ***
Library                         QWeb
Documentation                   Example test case demonstrating proper library search order
Resource                        ../Resources/Common.robot
Suite Setup                     Open Browser                about:blank                 chrome
Suite Teardown                  Close All Browsers

*** Variables ***
${project}                      Trial - Salesforce Source Format
${team}                         Test
${developer}                    Hanuchand Koppineni
${Credential}                   Dev1-SFP
${Apex1}                        VulnerableController
${Apex2}                        VulnerableControllerTest
${Apex3}                        SimpleAccountContactService
${Apex4}                        SimpleAccountContactServiceTest

*** Keywords ***
CreateUserStory
    [Documentation]             Create User stories
    Login
    LaunchApp                   User Stories
    ClickText                   New
    UseModal                    On
    ClickText                   User Story                  anchor=Select a record type
    ClickText                   Next                        delay=5
    UseModal                    On
    ${Title}=                   Generate Unique Name        MetadataTest
    Set Suite Variable          ${Title}
    TypeText                    Title                       ${Title}                    delay=5
    ComboBox                    Search Projects...          ${project}
    ComboBox                    Search Teams...             ${team}
    ComboBox                    Search Credentials...       ${Credential}
    ComboBox                    Search People...            ${developer}
    ClickText                   Save                        partial_match=False
    ${USERSTORY}                GetText                     US-
    Set Suite Variable          ${USERSTORY}
    Wait Until Keyword Succeeds                             3x                          200ms            Click Element               xpath=//button[.='Commit Changes']

CommitUserStory
    VerifyText                  Commit Changes              delay=5
    VerifyText                  ${Credential}
    ClickElement                xpath=//*[@placeholder="All metadata types"]//cds-icon[@shape="ArrowsCaretDown"]
    ClickText                   ApexClass
    ClickText                   Get Changes
    Wait Until Keyword Succeeds                             2 min                       5 sec            VerifyElement               xpath=//span[text()=' Add ']
    Verifyall                   ${Apex1},${Apex2},${Apex3},${Apex4}
    Clickelement                xpath=//label[@aria-label="Select row ApexClass:${Apex1}"]//input
    Clickelement                xpath=//label[@aria-label="Select row ApexClass:${Apex2}"]//input
    Clickelement                xpath=//label[@aria-label="Select row ApexClass:${Apex3}"]//input
    Clickelement                xpath=//label[@aria-label="Select row ApexClass:${Apex4}"]//input

    ClickText                   Commit Changes              anchor=Destination
    Verifyall                   ${Apex1},${Apex2},${Apex3},${Apex4}
    ClickText                   Start Commit
    Wait Until Keyword Succeeds                             3 min                       10 sec           VerifyElement               xpath=//span[text()='SFDX Commit']
    VerifyField                 Status                      In progress
    VerifyText                  SFDX Commit
    Wait Until Keyword Succeeds                             30 min                      10 sec           VerifyElement               xpath=//b[text()='Quality Checks']/../../following-sibling::lightning-layout-item//span[text()='Successful']
    VerifyText                  Quality Check
    VerifyText                  Successful
    ClickFieldValue             User Story
    Sleep                       5
    ClickText                   Project Management
    ClickText                   Test                        anchor=Build
    VerifyText                  Highest Priority Violation
    ${Violation_Rate}           GetFieldValue               Highest Priority Violation

Promote and Deploy the changes    
    ClickText                   Deliver
    ClickText                   Edit Ready to Promote
    ClickCheckbox               Ready to Promote            on
    ClickCheckbox               Promote and Deploy          on
    ClickText                   Save
    VerifyText                  Review the errors on this page.
    ClickText                   Cancel
    Sleep                       5
    RefreshPage
    ClickText                   Show more actions
    ClickText                   PMD Exception Request
    UseModal                    On
    ClickText                   Submit Exception
    VerifyText                  Justification and atleast one Reviewer is mandatory.

Creating SCA Exception
    TypeText                    Justification               Test
    TypeText                    Search by name or email     ${developer}
    ClickCheckbox               Select 1 item               on
    ClickText                   Submit Exception
    UseModal                    Off
    ClickText                   Deliver
    ClickText                   Edit Ready to Promote
    ClickCheckbox               Ready to Promote            on
    ClickCheckbox               Promote and Deploy          on
    ClickText                   Save
    VerifyText                  This User Story does not meet the required Apex coverage threshold to be promoted.
    ClickText                   Cancel
    ClickText                   Home
    ClickText                   Take an Action              anchor=Perform Action
    ClickText                   Submit
    VerifyText                  Please select an action before submitting.
Rejection of PMD    
    ClickText                   --None--                    anchor=Action
    ClickText                   Rejected                    anchor=Skip to Navigation
    TypeText                    Comments                    Rejected
    ClickText                   Submit

PMD Exception Approval
    ClickText                   User Stories
    ClickText                   ${USERSTORY}
    ClickText                   Deliver
    ClickText                   Show more actions
    ClickText                   PMD Exception Request
    UseModal                    On
    TypeText                    Justification               Retest
    TypeText                    Search by name or email     ${developer}
    ClickCheckbox               Select 1 item               on
    ClickText                   Submit Exception
    UseModal                    Off

Approver of PMD    
    LaunchApp                   Copado Developer
    ClickText                   Home
    RefreshPage
    ClickText                   Take an Action              anchor=Perform Action
    ClickText                   --None--                    anchor=Action
    ClickText                   Approved                    anchor=Skip to Navigation
    ClickText                   Submit
    VerifyText                  Please fill all the details.
    TypeText                    Comments                    approved
    ClickText                   Submit

Trying to Promote and Deploy
    ClickText                   User Stories
    ClickText                   ${USERSTORY}
    ClickText                   Deliver
    ClickText                   Edit Ready to Promote
    ClickCheckbox               Ready to Promote            on
    ClickCheckbox               Promote and Deploy          on
    ClickText                   Save
    VerifyText                  This User Story does not meet the required Apex coverage threshold to be promoted.
    ClickText                   Cancel
    ClickText                   Show more actions
    ClickText                   Edit                        anchor=Clone
    UseModal                    On
    TypeText                    Apex Code Coverage          78
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    RefreshPage
    ClickText                   Deliver
    ClickText                   Edit Ready to Promote
    ClickCheckbox               Ready to Promote            on
    ClickCheckbox               Promote and Deploy          on
    ClickText                   Save
    Sleep                       10
    RefreshPage

Checking Promotion record
    ClickText                   Deliver
    VerifyText                  User Story Promotions
    Wait Until Keyword Succeeds                             3x                          200ms            VerifyElement               xpath=xpath=//tbody//tr//th[@tabindex="0" and @data-label="Promoted User Story: Promoted User Story Name"]//following-sibling::td[1]//span[contains(text(),'P000')]
    ClickElement                xpath=//tbody//tr//th[@tabindex="0" and @data-label="Promoted User Story: Promoted User Story Name"]//following-sibling::td[1]//span[contains(text(),'P000')]
    VerifyField                 Status                      In Progress
    Wait Until Keyword Succeeds                             3min                        20sec            VerifyElement               xpath=//span[text()='Status']//parent::div//following-sibling::div//lightning-formatted-text[normalize-space(.)='Completed']
    ClickText                   User Stories                anchor=Details
    VerifyAll                   SFDX Promote,SFDX Deploy,Successful
    ClickText                   ${USERSTORY}
    SwitchWindow                2
    VerifyText                  INT-SFP
    VerifyElement               //span[contains(.,"INT-SFP") and contains(.,"ahead") and contains(.,"behind")]







