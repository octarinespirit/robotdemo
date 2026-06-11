*** Settings ***
Library    Browser
Resource   ../../resources/keywords/ui.resource

*** Variables ***
${BASEURL}     https://mybank-8s6n.onrender.com
${EMAIL}       testuser@example.com
${PASSWORD}    secret123
${NAME}        Test User

*** Test Cases ***

Login With Valid Credentials
    New Browser    chromium    headless=True
    New Context
    New Page    ${BASEURL}

    Login    email=${EMAIL}    password=${PASSWORD}
    Wait For Elements State    css=.login-modal    hidden
    Wait For Elements State    input[id="email"]    hidden
    Wait For Elements State    text=Transaction History    visible

Login With Invalid Credentials
    New Browser    chromium    headless=True
    New Context
    New Page    ${BASEURL}

    Login    false@login.com    wrongpassword
    Wait For Elements State    input[id="email"]    visible
    Wait For Elements State    text=Invalid    visible