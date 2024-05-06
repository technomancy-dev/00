// mail-queue.js
import { MailTime, RedisQueue } from "mail-time";
import { createClient } from "redis";
import "dotenv/config";

const mailQueue = new MailTime({
  type: "client",
  queue: new RedisQueue({
    client: await createClient({ url: process.env.REDIS_URL }).connect(),
  }),
});

export { mailQueue };
