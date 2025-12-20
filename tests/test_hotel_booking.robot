*** Settings ***
Documentation     Comprehensive test suite for verifying Self-Healing capabilities with diverse locator types
...               on a hotel booking page.
Resource          ../resources/common.robot

*** Variables ***
${MOCK_PAGE_URL}      https://bookhotel-cuyo.onrender.com/
${PAGE_NAME}        hotel_booking_page

*** Test Cases ***
Verify Check Availability Functionality
    [Documentation]    Verify that the check availability component works correctly.
    Setup Driver
    Go To    ${MOCK_PAGE_URL}
    Maximize Browser Window
    Sleep    5s    # Wait for page to fully load
    Smart Input Text    ${PAGE_NAME}    checkin         2024-12-01
    Smart Input Text    ${PAGE_NAME}    checkout        2024-12-05
    Smart Select From List By Label    ${PAGE_NAME}    guests    2
    Smart Click    ${PAGE_NAME}    search-button
    Sleep    3s
    Title Should Be    Availability Results
    [Teardown]      Close Browser
