*** Settings ***
Library    SeleniumLibrary
Library    ../libraries/GenAIRescuer.py

*** Variables ***
${HEALENIUM_PROXY_URL}    http://localhost:8085
${BROWSER}                chrome
${USE_HEALENIUM}          False

*** Keywords ***
Setup Driver
    [Documentation]    Opens browser via Healenium Proxy if enabled, otherwise local.
    ...                For Healenium, we use RemoteWebDriver.
    Run Keyword If    '${USE_HEALENIUM}' == 'True'    Open Browser Via Proxy    ELSE    Open Browser    about:blank    ${BROWSER}

Open Browser Via Proxy
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    # Healenium capability to enable/disable healing
    # Call Method    ${options}    set_capability    healenium:options    {'heal-enabled': True}
    
    Open Browser    url=about:blank    browser=${BROWSER}    remote_url=${HEALENIUM_PROXY_URL}    options=${options}

Smart Click
    [Arguments]    ${page_name}    ${element_name}
    [Documentation]    Tries to click. If fails, asks GenAI for help, verifies candidates, and clicks the winner.
    
    # New logic: The Python library handles the "Try -> Fail -> Heal -> Verify" loop entirely.
    ${element}=    Get WebElement With Healing    ${page_name}    ${element_name}
    Click Element    ${element}

Smart Input Text
    [Arguments]    ${page_name}    ${element_name}    ${text}
    [Documentation]    Tries to input text. If fails, asks GenAI for help, verifies candidates, and inputs to the winner.
    
    ${element}=    Get WebElement With Healing    ${page_name}    ${element_name}
    Input Text    ${element}    ${text}
