// mail-queue.js
import { MailTime, RedisQueue } from "mail-time";
import { createClient } from "redis";
import "dotenv/config";
import logger from "./logger";

let mailQueue;
try {
  mailQueue = new MailTime({
    type: "client",
    queue: new RedisQueue({
      client: await createClient({ url: process.env.REDIS_URL }).connect(),
    }),
  });
} catch (e) {
  mailQueue = {
    sendEmail: () =>
      logger.error(
        "The mail queue failed to connect on startup, so no emails are being queued"
      ),
  };
  logger.break();
  logger.error(
    "Failed to connect to Mail Queue. \nIs Redis running and have you added the REDIS_URL env variable?"
  );
  logger.break();
}

export { mailQueue };
