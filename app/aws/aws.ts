import { Hono } from "hono";
import Validator from "sns-payload-validator";
import pbadmin from "../admin_db";

const validator = new Validator();
const app = new Hono();

type Notification = {
  Message: string;
};

type SNS = {
  eventType: "Bounce" | "Complaint" | "Delivery";
  mail: {
    messageId: string;
  };
};

export enum STATUS {
  Bounced = "bounced",
  Complained = "complained",
  Delivered = "delivered",
  Pending = "pending",
}

export const EVENTS_TO_STATUS = {
  Bounce: STATUS.Bounced,
  Complaint: STATUS.Complained,
  Delivery: STATUS.Delivered,
  Send: STATUS.Pending,
};

app.post("/sns", async (c) => {
  const body = await c.req.json();
  try {
    const valid = await validator.validate(body);

    if (valid.Type === "SubscriptionConfirmation") {
      const subscribeUrl = valid.SubscribeURL!;
      fetch(subscribeUrl)
        .then((_) => console.log("Subscription confirmed"))
        .catch(console.error);
      return c.json({ success: true });
    }
    const sns = JSON.parse(valid.Message) as SNS;

    const update = { status: EVENTS_TO_STATUS[sns.eventType] };

    const record = await pbadmin
      .collection("emails")
      .getFirstListItem(`aws_message_id="${sns.mail.messageId}"`);

    await pbadmin.collection("emails").update(record.id, update);

    return c.json({ success: true });
  } catch (e) {
    console.error(e);
    return c.json({ success: false, error: e });
  }
});

export default app;
