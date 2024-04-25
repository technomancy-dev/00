/** @jsxImportSource hono/jsx */
import { Hono } from "hono";
import pb from "../db";
import KeyForm from "./components/KeyForm";
import generate_key_and_hash from "../lib/generate_key";

const app = new Hono();

app.get("/", async (c) => {
  const user = pb.authStore?.model;

  // const record = await pb
  //   .collection("application_keys")
  //   .getFirstListItem(`user="${user?.id}"`)
  //   .catch(console.error);

  const { key, hash } = generate_key_and_hash();
  // if (record) {
  //   return c.render(
  //     <KeyForm
  //       hash={hash}
  //       aws_secret={record.aws_secret}
  //       edit={true}
  //       aws_key={record.aws_key}
  //     />
  //   );
  // }

  return c.render(<KeyForm secret={key} hash={hash} />);
});

app.post("/", async (c) => {
  const { hash, aws_secret, aws_key } = await c.req.parseBody();
  const user = pb.authStore?.model;

  // const res = await pb
  //   .collection("application_keys")
  //   .create({ user: user.id, key: hash, aws_secret, aws_key })
  //   .catch(console.error);

  // if (res) {
  //   return c.redirect("/monitor");
  // }
  return c.json({ message: "Something went wrong check the DB logs." });
});

export default app;
