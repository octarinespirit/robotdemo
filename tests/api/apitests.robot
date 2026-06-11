*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    ../../libraries/generators.py
Library    ../../libraries/validators.py
Resource    ../../resources/keywords/api.resource

Suite Setup    Initialize Tests


*** Variables ***
${BASEURL}     https://mybank-8s6n.onrender.com
${EMAIL}       testuser@example.com
${PASSWORD}    secret123
${NAME}        Test User


*** Test Cases ***
API Test 1
    # Login and get token
    Create Session    bank    ${BASEURL}
    # 2️⃣ Login
    ${login_body}=    Create Dictionary
    ...    email=${EMAIL}
    ...    password=${PASSWORD}

    ${login_response}=    POST On Session
    ...    bank
    ...    /login
    ...    json=${login_body}
    Status Should Be    200    ${login_response}

    ${login_json}=    Set Variable    ${login_response.json()}
    ${token}=    Get From Dictionary    ${login_json}    token
    ${auth_headers}=    Create Dictionary    Authorization=Bearer ${token}

    # 3️⃣ Get account summary
    ${account_response}=    GET On Session
    ...    bank
    ...    /account
    ...    headers=${auth_headers}
    Status Should Be    200    ${account_response}
    Validate Account Response    ${account_response.json()}
    Log    Account summary: ${account_response.json()}

    # 4️⃣ Create random expense
    ${expense}=    Generate Random Expense
    ${expense_response}=    POST On Session
    ...    bank
    ...    /expenses
    ...    json=${expense}
    ...    headers=${auth_headers}
    Status Should Be    200    ${expense_response}
    ${expense_json}=    Set Variable    ${expense_response.json()}
    Validate Expense Response    ${expense_json}
    Log    Created expense: ${expense_json}

    # 5️⃣ List expenses
    ${list_response}=    GET On Session
    ...    bank
    ...    /expenses
    ...    headers=${auth_headers}
    Status Should Be    200    ${list_response}
    ${expenses}=    Set Variable    ${list_response.json()}
    Log    Expenses: ${expenses}

    #Delete Multiple Expenses    ${auth_headers}


    # # 6️⃣ Delete expense
    # ${expense_id}=    Get From Dictionary    ${expense_json}    id
    # ${delete_response}=    DELETE On Session
    # ...    bank
    # ...    /expenses/${expense_id}
    # ...    headers=${auth_headers}
    # Status Should Be    200    ${delete_response}