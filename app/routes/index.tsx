/** @jsxImportSource react */
// app/routes/about/index.ts
import { Hono } from "hono";
// ROUTES
import aws from "../aws/aws";
import api from "../api";
import dashboard from "../dashboard";
import auth from "../auth/auth";
import { render } from "jsx-email";
import Template from "../emails/Components/WelcomeEmail";

const app = new Hono();

app.get("/", async (c) => {
  const html = await render(<Template />);
  return c.html(html);
});

// ROUTES
app.route("/aws", aws);
app.route("/api", api);
app.route("/dashboard", dashboard);
app.route("/auth", auth);

export default app;
