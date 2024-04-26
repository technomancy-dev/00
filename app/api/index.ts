import { Hono } from "hono";
import { getCookie } from "hono/cookie";
import { bearerAuth } from "hono/bearer-auth";
import { jwt } from "hono/jwt";
import { env } from "hono/adapter";

import pb from "../db";
import generate_key_and_hash from "../lib/generate_key";
import { env } from "hono/adapter";
import email from "../emails/route";
import bcrypt from "bcrypt";

import "dotenv/config";

const app = new Hono();

app.use("/*", async (c, next) => {
  const auth_cookie = getCookie(c, "pb_auth");
  pb.authStore.loadFromCookie(auth_cookie!);

  // If they have a valid JWT just use that.
  if (pb.authStore.isValid) {
    return await next();
  }

  return bearerAuth({
    verifyToken: async (token, c) => {
      const id = token.split("_")[0];
      const pass = token.split("_")[1];

      const record = await pbadmin
        .collection("application_keys")
        .getFirstListItem(`key_id="${id}"`, {})
        .catch(console.log);

      if (!record?.key_hash) {
        return false;
      }

      return bcrypt.compareSync(pass, record.key_hash);
    },
  })(c, next);
});

app.get("/new-key", async (c) => {
  return c.json(generate_key_and_hash());
});

app.route("/emails/", email);

export default app;
