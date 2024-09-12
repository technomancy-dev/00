# 00 is a self hostable SES dashboard for sending and monitoring emails with AWS.

SES is an incredibly affordable way to build an email heavy application.

However monitoring the emails is a bit of a nightmare, and often requires custom infrastructure. Even setting up the SES -> SNS -> SQS pipeline is a headache for developers unfamiliar with AWS. And when that is done your still left with hooking in or building custom some dashboard for viewing bounces and all the vital information you care about.

00 provides an SST configuration step to set up the SES -> SNS -> SQS pipeline,
so you can just run a command and let SST do the rest.

If you would also like to deploy the container with SST follow this [guide](https://github.com/technomancy-dev/00/wiki/Hosting-on-AWS-with-SST).

Then 00 provides you that dashboard for viewing the information you care about.

![Dashboard displaying emails](00-messages.png)

Some key features include:

- Run SST to configure AWS for you.
- The ability to send emails by sending a `POST` request to `/api/emails`.
- Monitor email status (with multi-recipient tracking).
- Search emails and messages (a message is created for every recipient).
- View email body.
- Log tracking for requests and queue.

## Getting started

If you like video walkthroughs [Web Dev Cody](https://www.youtube.com/watch?v=d9JrOgLE8DE) made a fantastic one.

### Configure AWS
The quickest way to get started is to clone this repo and run `sst deploy` in it. Make sure to set the `EMAIL_IDENTITY` env variable first, this will be the email or domain you wish to send from.

Using SST is easy, and you can find the steps to do so [here](https://ion.sst.dev/docs/reference/cli) and learn how to configure your credentials [here](https://docs.sst.dev/advanced/iam-credentials#loading-from-a-file)

If you would like to avoid using SST you must manually configure AWS.
You need to set up a configuration set to write to an SQS queue via SNS. You can configure it however you want, but the more events you send to the queue the more 00 will be able to track (obviously).

If you know what you are doing and you want to configiure AWS manually, you can follow [this guide](https://github.com/technomancy-dev/00/wiki/Setting-up-AWS-without-SST).


Either option will give you an SQS url which we need, along with several other environment variables.

Currently SST does NOT deploy the container for you. It just sets up the needed SES pipeline.

In the near future you will pass a variable to SST to tell it wether it should host the container for you.

### Setup the Docker Container

We publish a docker image to the [registery](https://hub.docker.com/r/liltechnomancer/double-zero)

Simply run `docker pull liltechnomancer/double-zero`

Then run your docker container with the following environment variables set. Exposing port 4000.

Example `docker run -it --env-file .env -p 4000:4000 "liltechnomancer/double-zero"`

```
AWS_SECRET_ACCESS_KEY=
AWS_ACCESS_KEY_ID=
AWS_REGION= # Ex: us-east-1
SQS_URL=  # Ex: https://sqs.us-east-1.amazonaws.com/${id}

SYSTEM_EMAIL= # For sending stuff like password resets. Ex: test@example.com should be able to send from SES.

SECRET_KEY_BASE= # A long secret. at least 64 characters. Can be made with mix phx.gen.secret or however you generate safe keys.

DATABASE_PATH= # Path to SQLite database Ex: 00.db
PHX_HOST= #  URL or IP of where this service is running. Ex: example.com
```

Now visit your url (whatever you set PHX_HOST to) and register your user.

### Verify your Domain
After you have configured SES, with sst or manually, you have to verify that you own your domain.

1. Log into the AWS management Console
2. Navigate to your [SES Identities](https://us-east-1.console.aws.amazon.com/ses/home?region=us-east-1#/identities) in the region you setup SES.
3. Select the Domain you want to verify
4. Scroll down to **DomainKeys Identified Mail (DKIM)** and open the **Publish DNS records** dropdown.
5. You will see three DNS records
6. Head over to your domain provider and add these DNS records to your Domain.

After you published these DNS records to you domain it can take up to 72h to verify your domain according to AWS. But realisticly it will be verified in less than 12h.


## Send an EMail

### Register an API Key  

1. Log into your double-zero instance.
2. Navigate to **Settings**
3. Enter a unique name into the **Token Name** field
4. Click on **Create New API Token**`
5. You will now be shown the API-Key. Save it and treat it like a password, you can´t view this key anymore after closing the pop-up.

### Make an API Request
You can now make requests to your double-zero instance.
To send an email you have to hit the endpoint  on `yourdomain.com/api/emails`.

Use you favorite libary in your preferred language that can do https requests.

1. Set the `Authorization` Header to `Bearer yourapikeyhere`
2. Add a json body representing your email
3. Send a `POST` request to the endpoint

The response of an successful request looks like this.
```json
{
    "data": {
        "id": "51c2df38-0e3d-458b-9aff-3bf872868695", //This id is unique for every request
        "message": "Your email has successfully been queued.",
        "success": true
    }
}
```

### Body parameters
The request body has to be json with these parameters

| Param | Type | Required | Notes | Example |
|-------|------|----------|-------|---------|
|markdown|string|no|For the email body. <br> Either `markdown` or `html` can be used.|`{"markdown":"Some Text"}`|
|html|string|no|For the email body. <br> Either `markdown` or `html` can be used.|`{"html":"<h1>Some HTML</h1>"}`|
|subject|string|no|The email`s subject field|`{"subject":"Some Subject"}`|
|from|string|yes|The email address from which the email is sent.<br>Must be something@yourdomain.com.<br> The the domain has to be added to SES and be verified.|`{"from":"noreply@yourdomain.com"}`|
|to|string/string[]|yes|The emails recipient(s)|`{"to":"joe@somedomain.com"}` or `{"to": ["joe@somedomain.com", "jane@somedomain.com"]}`|
|cc|string|no|"The email address to which a copy of the email will be sent.".|`{"cc":"cc_address@yourdomain.com"}`|
|reply_to|string|no|The email address from which the reply will be sent.|`{"reply_to":"reply@yourdomain.com"}`|
|headers|object|no|An object containing key/value pairs of headers|`{"headers": {"X-Entity-Ref-ID": "00"}}`|
|provider_options|object|no|An object containing key/value pairs of provider options|`{"provider_options": {"tags": [{"name": "tag-name", "value": "some-value"}]}}`|
|attachments|array|no|An array containing attachments|`{"attachments": [{"filename": "invoice.txt", "content": "pewp", "content_type": "text/plain"}]}`|

### Example

```json
{
  "html": "<h1>Hello world!</h1>",
  "subject": "Can your email service track multiple recipients?",
  "from": "levi@fidoforms.com",
  "to": ["levi@technomancy.dev", "complaint@simulator.amazonses.com"]
}
```


## Support
Stuck? Tell me about it on [Discord](https://discord.gg/6r7Qtf754K) and lets unstick you!

## Pro + support open source.

If you are eager to support this project you can pre-order a [pro version](https://buy.stripe.com/5kA3dV5W1aBgaUo28e?prefilled_promo_code=EARLYBIRD) for you to self host.

Planned pro features include

* Multiple Users
* Teams
* Advanced Analytics
* Track email history
* Possibly more, we will see.
