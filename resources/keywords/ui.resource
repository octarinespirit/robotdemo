*** Keywords ***
Login
    [Arguments]    ${email}    ${password}
    Wait For Elements State    input[id="email"]    visible
    Fill Text    input[id="email"]    ${email}
    Fill Text    input[id="password"]    ${password}
    Click        text=Login
