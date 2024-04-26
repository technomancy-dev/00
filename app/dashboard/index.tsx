import { Hono } from "hono";
import Dashboard from "./components/Dashboard";
import keys from "../keys";

const dashboard = new Hono();

dashboard.get("/", async (c) => {
  const records = [];
  return c.render(<Dashboard records={[]} />);
});

dashboard.route("/keys", keys);

export default dashboard;
