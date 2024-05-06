import { Hono } from "hono";
import { bearerAuth } from "hono/bearer-auth";

import pbadmin from "../admin_db";
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

      c.set("user", record.user);
      if (!record) {
        logger.error(
          "No record found. Check your Admin credentials, and ensure you are using a valid API key."
        );
      }

      if (!record?.key_hash) {
        return false;
      }

      return bcrypt.compareSync(pass, record.key_hash);
    },
  })(c, next);
});

app.route("/emails/", email);

export default app;
