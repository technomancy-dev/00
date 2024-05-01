import { Hono } from "hono";
import { getCookie } from "hono/cookie";
import { bearerAuth } from "hono/bearer-auth";

import pb from "../db";
import pbadmin from "../admin_db";
import generate_key_and_hash from "../lib/generate_key";
import email from "../emails/route";
import bcrypt from "bcrypt";

import "dotenv/config";
import logger from "../logger";

const app = new Hono();

app.use("/*", async (c, next) => {
  return bearerAuth({
    verifyToken: async (token, c) => {
      const id = token.split("_")[0];
      const pass = token.split("_")[1];

      const record = await pbadmin
        .collection("application_keys")
        .getFirstListItem(`key_id="${id}"`)
        .catch(logger.format_error);

      c.set("aws_key", record.aws_key);
      c.set("aws_secret", record.aws_secret);
      c.set("user", record.user);

      if (!record?.key_hash) {
        return false;
      }

      return bcrypt.compareSync(pass, record.key_hash);
    },
  })(c, next);
});

app.route("/emails/", email);

export default app;
