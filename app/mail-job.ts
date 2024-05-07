import { create_mailer } from "./emails/lib/create_mailer.js";
import { MailTime, RedisQueue } from "mail-time";
import Email from "./emails/Controller.js";
import { createClient } from "redis";
import "dotenv/config";

let aws_key = process.env.AWS_ACCESS_KEY!;
let aws_secret = process.env.AWS_SECRET_KEY!;
let aws_region = process.env.AWS_REGION!;
const mailer = create_mailer(aws_key, aws_secret, aws_region);

mailer.options = {
  direct: true,
};

const redisClient = await createClient({
  url: process.env.REDIS_URL,
}).connect();

export const mailQueue = new MailTime({
  retries: 1,
  retryDelay: 100,
  queue: new RedisQueue({
    client: redisClient,
  }),
  josk: {
    adapter: {
      type: "redis",
      client: redisClient,
    },
  },
  template: MailTime.Template,
  transports: [mailer],
  onError(error, email, details) {
    console.log(
      `Email "${email.mailOptions[0].subject}" wasn't sent to ${email.mailOptions[0].to}`,
      error,
      details
    );
  },
  async onSent(email, details) {
    await Email.link_email_to_aws({
      email: email,
      aws_message_id: details.response,
    });
    console.log(
      `Email "${email.mailOptions[0].subject}" successfully sent to ${email.mailOptions[0].to}`
    );
  },
});

console.log("STARTING MAIL SERVER PROCESS");

export default { mailQueue };
