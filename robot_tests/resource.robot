*** Settings ***
Documentation  Reusable keywords and variables for the StoryMap server.
Library        Selenium2Library
Library        XvfbRobot
Library        Process
Library        OperatingSystem

*** Variables ***
${SERVER}      http://localhost:5000
${DELAY}       0
${ROOT URL}    ${SERVER}/select/

*** Keywords ***
Start Test Server
    Start Process  source env.sh && TEST_MODE\=on fab serve  shell=yes stdout=server.log  stderr=server.log  alias=test_server
    Sleep  3s

Stop Test Server
    Terminate Process  test_server
    Close Browser

Open Browser To Authoring Tool
    ${use xvfb} =  Get Environment Variable  USE_XVFB  False
    Run Keyword If  ${use xvfb}  Start Virtual Display    1920    1080

    Open Browser  ${ROOT URL}
    Maximize Browser Window
    Set Selenium Speed  ${DELAY}
    Authoring Tool Should Be Open

Authoring Tool Should Be Open
    Title Should Be  StoryMap JS

Create StoryMap
    [Arguments]  ${name}
    Create StoryMap Should Be Visible
    Input Text  css=input.entry-create-title  ${name}
    Click Link  id=entry_create
    Wait Until Loaded
    StoryMap Should Be Open  ${name}

Create StoryMap Should Be Visible
    Page Should Contain  Let's make a StoryMap.

StoryMap Should Be Open
    [Arguments]  ${name}
    Title Should Be  ${name} (Editing)

Wait Until Loaded
    Wait Until Element Is Not Visible  css=.icon-spinner
