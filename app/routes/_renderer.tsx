// @ts-nocheck
import { Style } from "hono/css";
import { jsxRenderer } from "hono/jsx-renderer";
import { Script } from "honox/server";
import Navigation from "../navigation/_navigation.island";

import pb from "../db";

export default jsxRenderer(({ children, title }) => {
  const user = pb.authStore?.model;

  return (
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        {import.meta.env.PROD ? (
          <link href="/static/assets/styles.css" rel="stylesheet" />
        ) : (
          <link href="/output.css" rel="stylesheet" />
        )}
        <title>{title}</title>
        <Script src="/app/client.ts" async />
        <Style />
      </head>
      <body>
        <Navigation user={user} />
        {children}
      </body>
    </html>
  );
});
