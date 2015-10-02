# marvel-slack
Get Marvel character information in Slack

### What you will need
* A [Heroku](http://www.heroku.com) account
* A [Marvel](https://developer.marvel.com/account) comics developer account
* An [outgoing webhook token](https://api.slack.com/outgoing-webhooks) for your Slack team

### Setup
* Clone this repository locally
* Create a new Heroku app and follow the instructions to initialize the ```marvel-slack``` repository
* Use the [Marvel developer](https://developer.marvel.com/account) page to generate API credentials 
* Navigate to the settings page of the Heroku app and add the following config variables:
  * ```OUTGOING_WEBHOOK_TOKEN``` The token for your outgoing webhook integration in Slack (more on this in a bit)
  * ```BOT_USERNAME``` The name the bot will use when posting to Slack
  * ```BOT_ICON``` The emoji icon for the bot
  * ```MARVEL_PUBLIC_KEY``` The public key for your Marvel developer account
  * ```MARVEL_PRIVATE_KEY``` The private key for your Marvel developer account
* Navigate to the integrations page for your Slack team. Create an outgoing webhook, choose a trigger word (ex: ".marvel"), use the URL for your heroku app, and copy the webhook token to your ```OUTGOING_WEBHOOK_TOKEN``` config variable.
* Push the repository to the Heroku app
* Try a search (ex: ".marvel Black Widow"). You should get a character information back.

### Thanks
[Marvelite Ruby Gem](https://github.com/antillas21/marvelite)

[@gesteves](https://github.com/gesteves/) Who's code I am constantly referencing.
