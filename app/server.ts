import { Hono } from "hono";
import { showRoutes } from "hono/dev";
import { createApp } from "honox/server";
import { env } from "hono/adapter";
import { bearerAuth } from "hono/bearer-auth";
import bcrypt from "bcrypt";
import { getCookie } from "hono/cookie";

import pb from "./db";
import "dotenv/config";

// ROUTES
import auth from "../app/auth/auth";
import keys from "../app/keys";

const base = new Hono();

base.use("/*", async (c, next) => {
  const auth_cookie = getCookie(c, "pb_auth");
  pb.authStore.loadFromCookie(auth_cookie!);

  await next();
});

base.use("/api/*", (c, next) => {
  const { SECRET_SKELETON_KEY } = env(c);
  return bearerAuth({
    verifyToken: async (token, c) => {
      const pass = token.split("_")[1];
      const hash = (SECRET_SKELETON_KEY || "").split("_")[1];

      return bcrypt.compareSync(pass, hash);
    },
  })(c, next);
});

const app = createApp({ app: base });
const dashboard = createApp();

dashboard.route("/auth", auth);
dashboard.route("/keys", keys);

app.route("/dashboard", dashboard);

// app.route("/monitor", monitor);

// app.route("/api", api);

showRoutes(app);

export default app;
