import { Hono } from "hono";
import { showRoutes } from "hono/dev";
import { createApp } from "honox/server";
import { getCookie } from "hono/cookie";

import pb from "./db";
import "dotenv/config";

const base = new Hono();

base.use("/*", async (c, next) => {
  const auth_cookie = getCookie(c, "pb_auth");
  pb.authStore.loadFromCookie(auth_cookie!);

  await next();
});

const app = createApp({ app: base });

showRoutes(app);

// serve(app, (info) => {
//   console.log(`Listening on http://localhost:${info.port}`); // Listening on http://localhost:3000
// });

export default app;
