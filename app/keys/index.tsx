import { Hono } from "hono";
import pb from "../db";
import KeyForm from "./components/KeyForm";
import generate_key_and_hash from "../lib/generate_key";
import User from "./UserController";

const app = new Hono();

app.get("/", async (c) => {
  const user = pb.authStore?.model;

  const record = await User.get_key_entry({ user });
  const { key, hash } = generate_key_and_hash();

  if (record) {
    return c.render(<KeyForm hash={hash} edit={true} />);
  }

  return c.render(<KeyForm secret={key} hash={hash} />);
});

app.post("/", async (c) => {
  const { hash, aws_account_id }: { aws_account_id: string; hash: string } =
    await c.req.parseBody();

  const res = await User.create_key_entry({ aws_account_id, hash });
  if (res) {
    return c.redirect("/dashboard");
  }
  return c.json({ message: "Something went wrong check the DB logs." });
});

app.post("/edit", async (c) => {
  const { hash, aws_account_id }: { aws_account_id: string; hash: string } =
    await c.req.parseBody();
  const user = pb.authStore?.model;
  if (!user) {
    return c.json({ message: "Shouldn't be possible" });
  }
  const update_res = await User.update_key_entry({ aws_account_id, hash });

  if (update_res) {
    return c.redirect("/dashboard");
  }
  return c.json({ message: "Something went wrong check the DB logs." });
});

app.get("/new-key", async (c) => {
  return c.json(generate_key_and_hash());
});

export default app;
