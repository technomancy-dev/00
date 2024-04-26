import { Hono } from "hono";
import { showRoutes } from "hono/dev";
import { createApp } from "honox/server";
import { env } from "hono/adapter";
import { bearerAuth } from "hono/bearer-auth";
import bcrypt from "bcrypt";
import { getCookie } from "hono/cookie";
import { jwt } from "hono/jwt";

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

// base.use("/api/*", (c, next) => {
//   const { SECRET_SKELETON_KEY } = env(c);
//   return bearerAuth({
//     verifyToken: async (token, c) => {
//       const pass = token.split("_")[1];
//       const hash = (SECRET_SKELETON_KEY || "").split("_")[1];

//       return bcrypt.compareSync(pass, hash);
//     },
//   })(c, next);
// });

const app = createApp({ app: base });

app.route("/api", api);
app.route("/dashboard", dashboard);
app.route("/auth", auth);

showRoutes(app);

export default app;
