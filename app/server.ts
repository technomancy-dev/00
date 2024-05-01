import { Hono } from "hono";
import { showRoutes } from "hono/dev";
import { createApp } from "honox/server";
import { getCookie, setCookie } from "hono/cookie";

import pb from "./db";
import "dotenv/config";
import logger from "./logger";

const base = new Hono();

base.use("/*", async (c, next) => {
  const auth_cookie = getCookie(c, "pb_auth");
  if (auth_cookie) {
    pb.authStore.loadFromCookie(auth_cookie!);
    const authData = await pb
      .collection("users")
      .authRefresh()
      .catch(logger.format_error);

    setCookie(c, "pb_auth", pb.authStore.exportToCookie());
  } else {
    pb.authStore.clear();
  }
  await next();
});

const app = createApp({ app: base });

showRoutes(app);

export default app;
