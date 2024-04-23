/** @jsxImportSource hono/jsx */

import { Hono } from "hono";
import Monitor from "./components/Monitor";

const app = new Hono();

app.get("/", async (c) => {
  return c.render(<Monitor />);
});

export default app;
