import { createFactory } from "hono/factory";
import email_controller from "./Controller";
import "dotenv/config";

const factory = createFactory();

const send = factory.createHandlers(async (c) => {
  const user = await c.get("user");
  const json = await c.req.json();

  const email = await email_controller.render_email(json);
  const queue_response = await email_controller.send({ email });
  await email_controller.save_admin({
    email: queue_response,
    user,
  });

  return c.json({ success: true });
});

const get = factory.createHandlers(async (c) => {
  const body = await c.req.json();
  const record = email_controller.get(body.id);
  return c.json({ success: true, email: record });
});

export default { send };
