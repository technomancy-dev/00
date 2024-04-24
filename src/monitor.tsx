/** @jsxImportSource hono/jsx */

import { Hono } from "hono";
import Monitor from "./components/Monitor";
import pb from "./db";
const app = new Hono();

app.get("/", async (c) => {
  const user = pb.authStore?.model;

  return c.render(<Monitor user={user} />);
});

export default app;
