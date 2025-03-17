# 🔔 Notification Proxy

Shopify allows you to call webhooks in case of a new order. To send a message on Slack you can pay for an app or something else.
This simple proxy does just that, for free.

## 🖥️ Deploy

Using the Docker image, set the following environment variables.

 - `SLACK_HOOK`
   Set this to the Slack webhook. Something like `https://hooks.slack.com/services/XXX/XXX`.
 - `SECRET_KEY_BASE`
   A random string length 64.

## ✅ Todo

 - The API does not verify any incoming requests, so anyone can send a request. This might lead to funny Slack messages if somebody sends a properly formed Shopify request, but that's about it for now.