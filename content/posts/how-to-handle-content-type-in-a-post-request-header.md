---
title: "How to Handle \"Content-Type\" in a Post Request Header"
date: 2020-03-13T00:29:46-05:00
categories: ["javascript"]
---
| Value | Description |
| :--:  | :---------: |
| application/json | Indicates that the request body format is JSON. |
| application/xml | Indicates that the request body format is XML. |
| application/x-www-form-urlencoded | Indicates that the request body is URL encoded. |

In some scenarios, for example, when we are going to send POST requests from a shopify form, it doesn’t allowed to use any Content-Type other than the last one in the above table.  
Okay, then how can we configure the payload? You might be laughing, I had been stuck though. 😉  
If you already got an object to send via POST, set the body like this:
```js
//Content-Type: 'application/json'
body: JSON.stringify(obj)
//Content-Type: 'application/x-www-form-urlencoded'
body: `payload=${JSON.stringify(obj)}`
```
Yes, that’s exactly how it works! Check it now on the recipient server.  
```js
console.log(JSON.parse(request.body.payload))
```
It should show your submitted object exactly.  
Happy coding, gents! 🙂

