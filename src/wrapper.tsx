/** @jsxImportSource hono/jsx */
import { Hono } from "hono";
import { getCookie } from "hono/cookie";
import { jsxRenderer } from "hono/jsx-renderer";
import { serveStatic } from "@hono/node-server/serve-static";

import pb from "./db";

const app = new Hono();

app.use(async (c, next) => {
  const auth_cookie = getCookie(c, "pb_auth");
  pb.authStore.loadFromCookie(auth_cookie!);
  await next();
});

app.get(
  "/public/*",
  serveStatic({
    root: "./",
  })
);

app.get(
  "/*",
  jsxRenderer(({ children }) => {
    return (
      <html className="h-full">
        <head>
          <link href="/public/output.css" rel="stylesheet"></link>
        </head>
        <body className="h-full">{children}</body>
      </html>
    );
  })
);

export default app;
