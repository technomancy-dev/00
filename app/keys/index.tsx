/** @jsxImportSource hono/jsx */
import { Hono } from "hono";
import { reject, anyPass, isEmpty, isNil } from "ramda";
import pb from "../db";
import KeyForm from "./components/KeyForm";
import generate_key_and_hash from "../lib/generate_key";
import crypto from "../lib/crypto";

const app = new Hono();

const omitNullable = reject(anyPass([isEmpty, isNil]));

app.get("/", async (c) => {
  const user = pb.authStore?.model;

  const record = await pb
    .collection("application_keys")
    .getFirstListItem(`user="${user?.id}"`)
    .catch(console.error);

  const { key, hash } = generate_key_and_hash();
  if (record) {
    return c.render(<KeyForm hash={hash} edit={true} />);
  }

  return c.render(<KeyForm secret={key} hash={hash} />);
});

app.post("/", async (c) => {
  const { hash, aws_secret, aws_key } = await c.req.parseBody();
  const user = pb.authStore?.model;

  if (!user) {
    return c.json({ message: "Shouldn't be possible" });
  }
  const [key_id, key_hash] = hash.split("_");

  const aws_key_encrypted = crypto.encrypt(aws_key);
  const aws_secret_encrypted = crypto.encrypt(aws_secret);

  const res = await pb
    .collection("application_keys")
    .create({
      user: user.id,
      key_hash,
      key_id,
      aws_secret: aws_secret_encrypted,
      aws_key: aws_key_encrypted,
    })
    .catch(console.error);

  if (res) {
    return c.redirect("/dashboard");
  }
  return c.json({ message: "Something went wrong check the DB logs." });
});

app.post("/edit", async (c) => {
  const { hash, aws_secret, aws_key } = await c.req.parseBody();
  const user = pb.authStore?.model;

  if (!user) {
    return c.json({ message: "Shouldn't be possible" });
  }

  const res = await pb
    .collection("application_keys")
    .getFirstListItem("")
    .catch(console.error);

  const [key_id, key_hash] = hash?.split("_") ?? [];

  const aws_key_encrypted = aws_key ? crypto.encrypt(aws_key) : null;
  const aws_secret_encrypted = aws_secret ? crypto.encrypt(aws_secret) : null;

  const update = omitNullable({
    aws_key: aws_key_encrypted,
    aws_secret: aws_secret_encrypted,
    key_id,
    key_hash,
  });

  const update_res = await pb
    .collection("application_keys")
    .update(res.id, update);

  if (update_res) {
    return c.redirect("/dashboard");
  }

  return c.json({ message: "Something went wrong check the DB logs." });
});

export default app;
