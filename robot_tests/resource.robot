*** Settings ***
Documentation  Reusable keywords and variables for the StoryMap server.
Library        Selenium2Library  timeout=5  implicit_wait=30
Library        Process
Library        String

*** Variables ***
${PORT}        5001
${SERVER}      http://localhost:${PORT}
${BROWSER}     Firefox
${DELAY}       0
${ROOT URL}    ${SERVER}/select/

*** Keywords ***
Start Test Server
    Start Process  bash -c "source env.sh && TEST_MODE\=on fab serve:port\=${PORT}"  shell=yes stdout=server.log  stderr=server.log  alias=test_server
    Sleep  3s

Stop Test Server
    Terminate Process  test_server
    Close Browser

Open Browser To Authoring Tool
    Open Browser  ${SERVER}/select/
    Maximize Browser Window
    Set Selenium Speed  ${DELAY}
    Authoring Tool Should Be Open

Authoring Tool Should Be Open
    Title Should Be  StoryMap JS

Create StoryMap
    [Arguments]  ${name}
    Sleep  2sec
    Create StoryMap Should Be Visible
    Input Text  css=input.entry-create-title  ${name}
    Click Link  id=entry_create
    Sleep  2sec
    Wait Until Loaded
    Go To  ${SERVER}/select
    Sleep  2sec
    StoryMap Should Exist  ${name}

Create StoryMap Should Be Visible
    Page Should Contain  Let's make a StoryMap.

Create Another StoryMap
    [Arguments]  ${name}
    Go To  ${SERVER}/select
    Sleep  2sec
    Click Link  css=#new_storymap
    Create StoryMap  ${name}

StoryMap Should Be Open
    [Arguments]  ${name}
    Sleep  5sec
    Title Should Be  ${name} (Editing)

StoryMap Should Exist
    [Arguments]  ${name}
    Element Should Contain  css=#entry_modal .modal-body  ${name}

StoryMap Should Exist ID
    [Arguments]  ${id}
    Page Should Contain Element  css=tr[storymap-data="${id}"]

StoryMap Should Not Exist
    [Arguments]  ${name}
    Element Should Not Contain  css=#entry_modal .modal-body  ${name}

StoryMap Should Not Exist ID
    [Arguments]  ${id}
    Page Should Not Contain Element  css=tr[storymap-data="${id}"]

Delete StoryMap
    [Arguments]  ${id}
    StoryMap Should Exist ID  ${id}
    Click Link  css=tr[storymap-data="${id}"] td div div a
    #use jquery to click the delete button incase it's off the bottom of the screen
    Execute Javascript  $(".dropdown.open a.list-item-delete").click()
    Click Button  css=.modal-confirm button.btn-primary
    Sleep  2sec
    StoryMap Should Not Exist ID  ${id}

Rename StoryMap
    [Arguments]  ${oldName}  ${newName}
    StoryMap Should Exist  ${oldName}
    ${id} =  Convert To Lowercase  ${oldName}
    Click Link  css=tr[storymap-data="${id}"] td div div a
    #use jquery to click the rename button incase it's off the bottom of the screen
    Execute Javascript  $(".dropdown.open a.list-item-rename").click()
    Input Text  css=.entry-rename-title  ${newName}
    Click Link  css=#entry_rename
    Sleep  2sec

Copy StoryMap
    [Arguments]  ${oldName}  ${newName}
    StoryMap Should Exist  ${oldName}
    ${id} =  Convert To Lowercase  ${oldName}
    Click Link  css=tr[storymap-data="${id}"] td div div a
    #use jquery to click the copy button incase it's off the bottom of the screen
    Execute Javascript  $(".dropdown.open a.list-item-copy").click()
    Input Text  css=.entry-copy-title  ${newName}
    Click Link  css=#entry_copy
    Sleep  2sec

Edit StoryMap
    [Arguments]  ${name}
    ${id} =  Convert To Lowercase  ${name}
    Click Link  css=tr[storymap-data="${id}"] td a.title
    Edit StoryMap Fields  ${name}  Test title slide

Create New StoryMap Slide
    Click Element  css=div#storymap_add_slide.slides-add

Edit StoryMap Fields
    [Arguments]  ${headline}  ${body}
    Wait Until Loaded
    Input Text  css=#headline  ${headline}
    Select Frame  css=#edit iframe
    Input Text  css=.wysihtml5-editor  ${body}
    Unselect Frame

Edit StoryMap Slide Location
    [Arguments]  ${location}
    Sleep  2sec
    Input Text  css=#map_search_input  ${location}
    #\\13 is the code for the enter key
    Press Key  css=#map_search_input  \\13

Click Back To Beginning
    Click Element  xpath=//*[@id="preview_embed"]/div[1]/span[2]

Click Preview Button
    Click Element  xpath=//*[@id="tabs"]/li[2]/a

Click Next Slide
    Click Element  css=.vco-slidenav-next div div.vco-slidenav-icon

Wait Until Loaded
    Wait Until Element Is Not Visible  css=.icon-spinner
