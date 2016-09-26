*** Settings ***
Documentation   Suite of tests for creating, updating and deleting new storymaps.
Suite Setup     Start Test Server
Suite Teardown  Stop Test Server
Resource        resource.robot

*** Test Cases ***
Create StoryMap
    Go To Authoring Tool
    Create StoryMap  Test

Delete StoryMap
    Go To Authoring Tool
    Wait Until Loaded
    Delete StoryMap  test
    StoryMap Should Not Exist  Test
    StoryMap Should Not Exist ID  test

Create And Delete Multiple StoryMaps
    Go To Authoring Tool
    Create StoryMap  Test1
    Create Another StoryMap  Test2
    Create Another StoryMap  SomeOtherVeryDifferentName
    Go To  ${SERVER}/select
    Sleep  2sec
    Delete StoryMap  test2
    StoryMap Should Exist  Test1
    StoryMap Should Exist  SomeOtherVeryDifferentName
    Delete StoryMap  someotherverydifferentname
    StoryMap Should Exist  Test1
    Delete StoryMap  test1
    StoryMap Should Not Exist  Test1
    StoryMap Should Not Exist  Test2
    StoryMap Should Not Exist  SomeOtherVeryDifferentName

Rename A StoryMap
    Go To Authoring Tool
    Create StoryMap  Test1
    StoryMap Should Exist  Test1
    Rename StoryMap  Test1  Test2
    StoryMap Should Not Exist  Test1
    StoryMap Should Exist  Test2
    #The ID doesn't change when we rename
    Delete StoryMap  test1

Copy A StoryMap
    Go To Authoring Tool
    Create StoryMap  Test1
    StoryMap Should Exist  Test1
    Copy StoryMap  Test1  Test2
    StoryMap Should Exist  Test1
    StoryMap Should Exist  Test2
    Delete StoryMap  test1
    Delete StoryMap  test2

Edit A StoryMap
    Open Browser To Authoring Tool
    Create StoryMap  Test
    StoryMap Should Exist  Test
    Edit StoryMap  Test
    Create New StoryMap Slide
    Edit StoryMap Fields  Location slide  Body Text
    Edit StoryMap Slide Location  Victora University of Wellington, New Zealand
    Click Preview Button
    Click Back To Beginning
    Page Should Contain  Test
    Click Next Slide
    Page Should Contain  slide
    Page Should Contain  Body Text
    Go To  ${SERVER}/select
    Delete StoryMap  Test
