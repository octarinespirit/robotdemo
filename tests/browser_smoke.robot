*** Settings ***
Library    Browser

*** Test Cases ***
Open Browser Example
    New Browser    chromium
    New Context
    New Page    https://www.example.com
    Get Title    ==    Example Domain

