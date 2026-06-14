*** Settings ***
Documentation     Playground testing.
Library           SeleniumLibrary
Library           String

Suite Setup       Open Browser    ${URL}    ${BROWSER}
Test Setup        Test init
Suite Teardown    Close Browser

*** Variables ***
${URL}            https://playground.efibot.sk/index.php
${BROWSER}        Chrome


*** Keywords ***
Select Process
    [Arguments]    ${name}
    ${name}=    Replace String    ${name}    ${SPACE}    ${EMPTY}
    ${name}=    Convert To Lowercase    ${name}
    #Click Element    xpath=//li/a[contains(text(), '${name}')]
    ${locator}=    Set Variable    xpath=//li/a[contains(translate(normalize-space(.), 'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÄČĎÉÍĹĽŇÓÔŔŠŤÚÝŽ', 'abcdefghijklmnopqrstuvwxyzáäčďéíĺľňóôŕšťúýž'), '${name}')]
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Scroll Element Into View    ${locator}
    Click Element    ${locator}
Test init
    Set Window Size    1920    1080
    Select Process    ${TEST_NAME}

*** Test Cases ***
Cakanie na text
    [Documentation]    Verify that the text "Cakanie na zobrazenie textu" is present on the page.
    Page Should Contain    Cakanie na zobrazenie textu
    Page Should Contain    Som tu hned!
    Element Should Be Visible    xpath=//p[contains(text(), 'Text zobrazeny hned')]
    Wait Until Page Contains Element    xpath=//p[contains(text(), 'Som tu az po 5 sekundach')]    timeout=10s


Klikanie
    [Documentation]    Click on the button.
    #Click Element    xpath=//button[contains(text(), 'Klikaj')]
    FOR    ${index}    IN RANGE    10
        Click Element    xpath=//button[text()='Klikaj']
    END
    Element Should Contain    xpath=//span[@id='clickCounter']    10
    #Wait Until Page Contains Element    xpath=//p[contains(text(), 'Button clicked!')]    timeout=10s


Vyberanie
    [Documentation]    Select an option from the dropdown and verify the selection.
    #Open Browser    https://playground.efibot.sk/vyberanie.php   ${BROWSER}
    #Select From List By Index    id=chooseYourHero    1
    ${hero}=    Set Variable    Batman
    Select From List By Value    id=chooseYourHero    ${hero}
    Element Should Contain    xpath=//span[@id='heroName']    ${hero}


Vycitavanie
    [Documentation]    Input data into a form and submit it.
    #Open Browser    https://playground.efibot.sk/vycitavanie.php   ${BROWSER}
    ${city}=    Get Text        id=city
    Log to console    The city is: ${city}
    Input Text    id=cityCheck    ${city}
    Click Button    id=checkBtn
    Wait Until Element contains    xpath=//div[@id='successAlert']    Skvele! Vybral si spravne mesto.    timeout=10s

Tabulka
    [Documentation]    Process data from a table and verify the content.
    #Open Browser    https://playground.efibot.sk/tabulka.php   ${BROWSER}
    ${number_of_rows}=    Get Element Count    xpath=//tbody//tr[contains(.,'na sklade')]
    FOR    ${row}    IN RANGE  1  ${number_of_rows}+${1}
        ${name_of_product}=    Get text    xpath=(//tbody//tr[contains(., 'na sklade')])[${row}]//td[1]
        Log to console    Name of product: ${name_of_product}
        Select Checkbox    xpath=(//tbody//tr[contains(., 'na sklade')])[${row}]//td/input[@type='checkbox']
    END
    Click Element    xpath=//button[normalize-space()='Overit']
    Element Should Contain    xpath=//div[@role='alert']   Vsetko si oznacil spravne!

Rozhodovanie
    [Documentation]    Click on the correct label and verify the selection.
    #Open Browser        https://playground.efibot.sk/rozhodovanie.php   ${BROWSER}
    ${txt}=  Get Text    xpath=//p[contains(., 'robot') or contains(., 'clovek')]
    ${txt}=  Fetch From Right  ${txt}    ${SPACE}
    ${txt}=  Fetch From Left   ${txt}     !
    Log To Console    The text is: ${txt}
    IF    '${txt}' == 'robot'
        Click Element    xpath=//input[@id='${txt}']
    ELSE IF    '${txt}' == 'clovek'
        Click Element    xpath=//input[@id='${txt}']
    END
    Element Text Should Be    xpath=//div[@id='successAlert']    Vybral si spravne!
    #Element Text Should Not Be Visible    xpath=//div[@id='dangerAlert']    text=Chyba! Skus to este raz.
    #Element Should Be Selected    xpath=//input[@id='label2']
  

