/** @jsxImportSource hono/jsx */
import { Hono } from "hono";
import { jsxRenderer } from "hono/jsx-renderer";
import { serveStatic } from "@hono/node-server/serve-static";

const app = new Hono();

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
