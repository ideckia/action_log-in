# Action for [ideckia](https://ideckia.github.io/): log-in

## Description

Writes the given username and password for login (action ['action_keyboard'](http://github.com/ideckia/action_keyboard) required)

## Properties

| Name | Type | Description | Shared | Default | Possible values |
| ----- |----- | ----- | ----- | ----- | ----- |
| username | String | The user name | false | "admin" | null |
| password | String | The password | false | "1234" | null |
| key_after_user | String | Writes 'username'->key_after_user->'password'->'enter' | false | 'tab' | [tab,enter] |
| user_pass_delay | UInt | Milliseconds to wait between username and password | false | 0 | null |

## Example in layout file

```json
{
    "text": "log-in example",
    "bgColor": "00ff00",
    "actions": [
        {
            "name": "log-in",
            "props": {
                "username": "admin",
                "password": "1234",
                "key_after_user": "tab",
                "user_pass_delay": 0
            }
        }
    ]
}
```
