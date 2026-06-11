*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Keywords ***
Register User If Needed
    Create Session    bank    ${BASEURL}

    # 1️⃣ Create user payload
    ${register_body}=    Create Dictionary
    ...    email=${EMAIL}
    ...    password=${PASSWORD}
    ...    name=${NAME}

    # 2️⃣ Register (älä failaa 400:sta)
    ${register_response}=    POST On Session
    ...    bank
    ...    /register
    ...    json=${register_body}
    ...    expected_status=anything

    Log    Registration response: ${register_response.status_code} - ${register_response.text}

    ${status}=    Set Variable    ${register_response.status_code}

    IF    ${status} == 201
        Log    ✅ User created successfully

    ELSE IF    ${status} == 400
        ${json}=    Set Variable    ${register_response.json()}
        ${message}=    Get From Dictionary    ${json}    message

        IF    '${message}' == 'User already exists'
            Log    ℹ️ User already exists, continuing test
        ELSE
            Fail    ❌ Unexpected 400 response: ${register_response.text}
        END

    ELSE
        Fail    ❌ Unexpected status code: ${status} - ${register_response.text}
    END

Initialize Tests
    Register User If Needed


Delete Expense By ID
    [Arguments]    ${expense_id}    ${auth_headers}
    ${delete_response}=    DELETE On Session
    ...    bank
    ...    /expenses/${expense_id}
    ...    headers=${auth_headers}
    Status Should Be    200    ${delete_response}

Delete Multiple Expenses
    [Arguments]    ${auth_headers}
    ${start}=        Set Variable    1
    ${end}=      Evaluate    ${start} + 1

    FOR    ${i}    IN RANGE    ${start}    ${end}
        Delete Expense By ID    ${i}    ${auth_headers}
    END
