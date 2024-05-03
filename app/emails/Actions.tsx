import "dotenv/config";

import { createFactory } from "hono/factory";
import email_controller from "./Controller";

const factory = createFactory();

const send = factory.createHandlers(async (c) => {
  const user = c.get("user");
  const aws_key_encrypted = c.get("aws_key");
  const aws_secret_encrypted = c.get("aws_secret");
  const json = await c.req.json();

  const mailer = email_controller.create_mailer(
    aws_key_encrypted,
    aws_secret_encrypted
  );

  const email = await email_controller.render_email(json);
  const info = await email_controller.send({ mailer, email });

  const db_response = email_controller
    .save_admin({ email: info, user })
    .catch(console.error);

  return c.json({ success: true });
});

const get = factory.createHandlers(async (c) => {
  const body = await c.req.json();
  const record = email_controller.get(body.id);
  return c.json({ success: true, email: record });
});

export default { send };
