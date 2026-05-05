*** Settings ***
Documentation                   Example test case demonstrating proper library search order
Library                         FakerLibrary
Resource                        ../Resources/Common.robot
Resource                        ../Resources/Keyword.robot
Suite Setup                     Open Browser                about:blank    chrome
Suite Teardown                  Close All Browsers


*** Test Cases ***
SCA E2E Flow
    CreateUserStory
    CommitUserStory
    Promote and Deploy the changes
    Creating SCA Exception
    Rejection of PMD
    PMD Exception Approval
    Approver of PMD
    Trying to Promote and Deploy
    Checking Promotion record

