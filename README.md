If you are eager to support this project you can pre-order a [pro version](https://buy.stripe.com/5kA3dV5W1aBgaUo28e?prefilled_promo_code=KOOKIES) for you to self host.

Planned pro features include

* Teams
* Advanced Analytics
* Track email history
* Possibly more, we will see.

# Double Zero is an email monitoring micro-service for the people!

Amazon SES is a cost effective way to send a lot of emails, but it has a horrible user experience for most applications.

Sending could be a simple API endpoint to send html or markdown to, and a simple dashboard for monitoring email status.

Instead you need to send through an SMTP setup, and monitoring in the AWS dashboard is horrible, and arguably not even really possible resulting in you needing to make an endpoint and dashboard for SNS events.

That is what 00 was made to solve. 00 is that dashboard, complete with an endpoint for sending your markdown or HTML emails.

## Getting started

We publish a docker image to the [registery](https://hub.docker.com/r/liltechnomancer/double-zero)

Simply run `docker pull liltechnomancer/double-zero`

Then run your docker container with the following environment variables set.

```
export AWS_SECRET_ACCESS_KEY=""
export AWS_ACCESS_KEY_ID=""
export AWS_REGION="" # Ex: us-east-1

export SYSTEM_EMAIL="" # For sending stuff like password resets. Ex: test@example.com should be able to send from SES.

export SECRET_KEY_BASE="" # A long secret. at least 64 characters. Can be made with mix phx.gen.secret or however you generate safe keys.
export DATABASE_PATH="" # Path to SQLite database Ex: 00.db

export PHX_HOST="" #  URL or IP of where this service is running. Ex: example.com
```

# Phoenix00

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
