import { Hono } from "hono";
import { getCookie } from "hono/cookie";
import { bearerAuth } from "hono/bearer-auth";
import { jwt } from "hono/jwt";

import pb from "../db";
import generate_key_and_hash from "../lib/generate_key";
import { env } from "hono/adapter";

import "dotenv/config";

const app = new Hono();

app.use("/*", async (c, next) => {
  const { SECRET_SKELETON_KEY } = env(c);
  const auth_cookie = getCookie(c, "pb_auth");
  pb.authStore.loadFromCookie(auth_cookie!);

  // If they have a valid JWT
  if (pb.authStore.isValid) {
    return await next();
  }

  return bearerAuth({
    verifyToken: async (token, c) => {
      const pass = token.split("_")[1];
      const hash = (SECRET_SKELETON_KEY || "").split("_")[1];

      return bcrypt.compareSync(pass, hash);
    },
  })(c, next);
});

app.get("/new-key", async (c) => {
  return c.json(generate_key_and_hash());
});

export default app;
