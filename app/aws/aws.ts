import { Hono } from "hono";
import Validator from "sns-payload-validator";
import pbadmin from "../admin_db";
import logger from "../logger";
import Email from "../emails/Controller";

const validator = new Validator();
const app = new Hono();

type Notification = {
  Message: string;
};

type SNS = {
  eventType: "Bounce" | "Complaint" | "Delivery" | "Send";
  mail: {
    messageId: string;
    commonHeaders: any;
  };
};

export enum STATUS {
  Bounced = "bounced",
  Complained = "complained",
  Delivered = "delivered",
  Pending = "pending",
  Sent = "sent",
}

export const EVENTS_TO_STATUS = {
  Bounce: STATUS.Bounced,
  Complaint: STATUS.Complained,
  Delivery: STATUS.Delivered,
  Send: STATUS.Sent,
  Pending: STATUS.Pending,
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

    if (sns.eventType === "Send") {
      // 1 Get email
      const record = await pbadmin
        .collection("emails")
        .getFirstListItem(`aws_message_id="${sns.mail.messageId}"`)
        .catch(logger.format_error);

      // If exists, update status.
      if (record) {
        const update = { status: EVENTS_TO_STATUS[sns.eventType] };

        await pbadmin
          .collection("emails")
          .update(record.id, update)
          .catch(logger.format_error);

        return c.json({ success: true });
      }

      // If doesn't exist, create (will need to use AWS account ID for this. ).
      const from = sns.mail.commonHeaders.from[0];
      const to = sns.mail.commonHeaders.to;
      const subject = sns.mail.commonHeaders.subject;

      const keys = await pbadmin
        .collection("application_keys")
        .getFirstListItem(`aws_account_id="${sns.mail.sendingAccountId}"`)
        .catch(logger.format_error);

      const info = sns.mail.messageId;

      const email = {
        envelope: { to, from },
        info,
        status: EVENTS_TO_STATUS[sns.eventType],
      };

      Email.create_aws({ email, user: keys.user });
      return c.json({ success: true });
    }
    const update = { status: EVENTS_TO_STATUS[sns.eventType] };

    const record = await pbadmin
      .collection("emails")
      .getFirstListItem(`aws_message_id="${sns.mail.messageId}"`)
      .catch(logger.format_error);

    if (record) {
      await pbadmin
        .collection("emails")
        .update(record.id, update)
        .catch(logger.format_error);

      return c.json({ success: true });
    }

    return c.json({ success: false });
  } catch (e) {
    console.error(e);
    return c.json({ success: false, error: e });
  }
});

export default app;
