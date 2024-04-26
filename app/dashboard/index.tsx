import { Hono } from "hono";
import Dashboard from "./components/Dashboard";
import keys from "../keys";
import pb from "../db";

const dashboard = new Hono();

dashboard.use("*", async (c) => {
  if (!pb.authStore.isValid) {
    return c.redirect("/");
  }
});

dashboard.get("/", async (c) => {
  const records = [];
  return c.render(<Dashboard records={[]} />);
});
dashboard.route("/keys", keys);

export default dashboard;
