*** Settings ***
Documentation     A demo suite for Self-Healing (Healenium + GenAI).
Resource          ../resources/common.robot
Suite Setup       Setup Driver
Suite Teardown    Close All Browsers

*** Variables ***
${MOCK_APP_PATH}    ${CURDIR}/mock_app.html
# Use file:// protocol for local file
${URL}              file:///${MOCK_APP_PATH}

*** Test Cases ***
Test Self Healing On Button Click
    [Documentation]    Tests that the framework can heal a changed ID.
    Go To    ${URL}
    Maximize Browser Window
    
    # Check initial state
    Wait Until Page Contains Element    id:submit-btn    timeout=5s
    Log    Found initial button. Waiting for mutation...
    
    # Wait for the JS to change the ID (5 seconds)
    Sleep    6s
    
    # This locator is intentionally broken in locators/SelfHealingDemoPage.json
    # It points to 'submit-btn', but the page has 'submit-v3-btn' (or v2)
    Smart Click    SelfHealingDemoPage    submit_btn
    
    # Verify the click happened (Alert or UI change) - For demo we assume no error is success enough, 
    # but strictly we should handle the alert if the mock app calls alert().
    # The mock app does alert('Clicked!'). handle it.
    Alert Should Be Present    Clicked!    action=ACCEPT
    Log    Test Passed! Healing successful.
