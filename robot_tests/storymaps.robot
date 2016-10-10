*** Settings ***
Documentation   Suite of tests for creating, updating and deleting new storymaps.
Suite Setup     Start Test Server
Suite Teardown  Run Keywords  Stop Test Server  Close All Browsers
Resource        resource.robot

*** Test Cases ***
Create StoryMap
    Open Browser To Authoring Tool
    Create StoryMap  Test

Delete StoryMap
    Open Browser To Authoring Tool
    Wait Until Loaded
    Delete StoryMap  Test

Create And Delete Multiple StoryMaps
    Open Browser To Authoring Tool
    Wait Until Loaded
    Create StoryMap  Test1
    Create Another StoryMap  Test2
    Create Another StoryMap  SomeOtherVeryDifferentName
    Go To  ${SERVER}/select
    Delete StoryMap  Test2
    StoryMap Should Exist  Test1
    StoryMap Should Exist  SomeOtherVeryDifferentName
    Delete StoryMap  SomeOtherVeryDifferentName
    StoryMap Should Exist  Test1
    Delete StoryMap  Test1
    StoryMap Should Not Exist  Test1
    StoryMap Should Not Exist  Test2
    StoryMap Should Not Exist  SomeOtherVeryDifferentName
    
Change To Slide
	[Attributes] ${slide}
	Select From List By Index css=ol#slides ${slide}
	
Open Custom Marker For Slide
	[Attributes] ${slide}
	StoryMap Should Be Open
	Change To Slide ${slide}
	Click Element css=#marker_opt_modal
	Page Should Contain Element css=#marker_opt_modal
	Element Should Contain css=#marker_opt_modal input#marker_url
	
Close Custom Marker Window
	StoryMap Should Be Open
	Page Should Contain Element css=#marker_opt_modal
	Element Should Contain css=#marker_opt_modal input#marker_url
	Click Link xpath=//div#marker_opt_modal/.btn-primary
	Page Should Not Contain Element css=#marker_opt_modal
	
Upload Custom Marker To Slide
	[Attributes] ${url} ${slide}
	Change To Slide ${slide}
	Open Custom Marker Window
	Input Text css=input#marker_url ${url}
	Close Custom Marker Window
	Element Should Contain css=#map css=img[href=${url} message=The chosen custom marker could not be found
	
Remove Custom Marker
	[Attributes] ${slide}
	Change To Slide ${slide}
	Open Custom Marker Window
	Input Text css=input#marker_url 
	Close Custom Marker Window
	Element Should Not Contain css=#map css=img[href=${url} message=The map marker should not be visible
