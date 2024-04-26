import { Hono } from "hono";
import { showRoutes } from "hono/dev";
import { createApp } from "honox/server";
import { getCookie } from "hono/cookie";

import pb from "./db";
import "dotenv/config";

// ROUTES
import api from "./api";
import dashboard from "./dashboard";
import auth from "./auth/auth";

const base = new Hono();

base.use("/*", async (c, next) => {
  const auth_cookie = getCookie(c, "pb_auth");
  pb.authStore.loadFromCookie(auth_cookie!);

  await next();
});

const app = createApp({ app: base });

// ROUTES
app.route("/api", api);
app.route("/dashboard", dashboard);
app.route("/auth", auth);

showRoutes(app);

export default app;
