*** Settings ***
Documentation     REST API testing.
Library           RequestsLibrary
Library           ../../resources/Converter.py
Library            JSONLibrary

*** Variables ***
${URL}    https://jsonplaceholder.typicode.com


*** Test Cases ***
GET Request All Posts
    ${cislo}=    Set Variable  2
    ${cislo}=  convert  ${cislo}
    [Documentation]    Send a GET request to retrieve all posts and verify the response.
    ${response}=    GET    url=${URL}/posts/${cislo}    expected_status=200
    Log To Console  ID: ${response.json()['id']} | Titul ${response.json()['title']}
    # FOR    ${item}    IN    @{response.json()}
    #     Log To Console  ID: ${item['id']} | Titul ${item['title']}
    # END
    #Should Be Equal As Integers    ${response.status_code}    200

Filter Data With GET Request
    [Documentation]    Send a GET request to retrieve posts filtered by userId and verify the response.
    ${response}=    GET    url=${URL}/posts/1   expected_status=200
    Log To Console  ID: ${response.json()['id']} | Titul ${response.json()['title']}

    &{params}=    Create Dictionary    id=1
    ${response}=    GET    url=${URL}/posts    params=${params}    expected_status=200
    FOR    ${item}    IN    @{response.json()}
        Log To Console  ID: ${item['id']} | Titul ${item['title']}
    END

PUT Request
    [Documentation]    Send a PUT request to update a post and verify the response.
    &{headers}=    Create Dictionary    Content-Type=application/json    charset=UTF-8
    &{data}=    Create Dictionary    id=1    title=Updated Title    body=Updated Body    userId=1
    ${response}=    PUT    url=${URL}/posts/1    headers=${headers}    json=${data}    expected_status=200
    Log To Console  ${response.json()}

    ${json_data}=    Load Json From File    ${CURDIR}/update.json
    ${response}=    PUT    url=${URL}/posts/1    headers=${headers}    json=${json_data}    expected_status=200
    Log To Console  ${response.json()}