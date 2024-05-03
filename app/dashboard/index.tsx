import { Hono } from "hono";
import Dashboard from "./components/Dashboard";
import keys from "../keys";
import pb from "../db";
import logger from "../logger";

const dashboard = new Hono();

dashboard.use("/*", async (c, next) => {
  if (!pb.authStore.isValid) {
    return c.redirect("/");
  }
  await next();
});

dashboard.get("/", async (c) => {
  const { limit, offset } = c.req.query();
  let limitSafe = limit ? parseInt(limit) : 8;
  let offsetSafe = offset ? parseInt(offset) : 1;

  const {
    items: records,
    totalPages,
    page,
  } = await pb
    .collection("emails")
    .getList(offsetSafe, limitSafe, {
      fields: "status,to,from,created",
      sort: "-created",
    })
    .catch(logger.format_error);

  return c.render(
    <Dashboard
      records={records}
      firstPage={page === 1}
      lastPage={totalPages === page}
      limit={limitSafe}
      offset={offsetSafe}
    />
  );
});

dashboard.route("/keys", keys);

export default dashboard;
