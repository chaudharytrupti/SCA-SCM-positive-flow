*** Settings ***
Documentation                   Example test case demonstrating proper library search order
Library                         FakerLibrary
Resource                        ../Resources/Common.robot
Resource                        ../Resources/Keyword.robot
Suite Setup                     Open Browser                about:blank    chrome
Suite Teardown                  Close All Browsers


*** Test Cases *** 
SCM E2E Flow for Aprroval
    Sleep       5
#    Org Authentication
#    Shared Component Matrix Settings
#    Creating a Userstory   
#    Commit UserStory for Approval scenario
#    Apex Code Coverage Configuration
#    SC Matrix for Approval
#    Promote and Deploy
#    Checking Promotion record

SCM E2E Flow for Exception.
   Org Authentication
   Creating a Userstory   
   Commit UserStory for Exception scenario    
   SC Matrix for Exception
   Checking for SCM Exception Provided
   Promote and Deploy
   Checking Promotion record
