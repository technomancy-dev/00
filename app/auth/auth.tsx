/** @jsxImportSource hono/jsx */
import { Hono } from "hono";
import { setCookie } from "hono/cookie";
import { map } from "ramda";

import pb from "../db";
import { z } from "zod";

import Signup from "./components/Signup";

const User = z.object({
  name: z.string().min(2, { message: "Must be at least 2 characters." }),
  email: z.string().email(),
  password: z
    .string()
    .min(10, { message: "Must be 10 or more characters long" }),
  passwordConfirm: z
    .string()
    .min(10, { message: "Must be 10 or more characters long" }),
});

const app = new Hono();

app.get("/sign-up", async (c) => {
  return c.render(<Signup />);
});

app.post("/sign-up", async (c) => {
  const { email, password, passwordConfirm, name } = await c.req.parseBody();
  const { data, success, error } = User.safeParse({
    email,
    password,
    passwordConfirm,
    name,
  });

  if (success === false) {
    const errors = error.flatten().fieldErrors;
    return c.render(<Signup errors={errors} />);
  }

  const flatten_db_errors = (error) => {
    return map((item) => [item.message], error.originalError.data.data);
  };

  const res = await pb
    .collection("users")
    .create({
      email,
      password,
      passwordConfirm,
      name,
    })
    .catch((error) => {
      const errors = {
        ...flatten_db_errors(error),
      };
      return { errors };
    });

  if (res.errors) {
    return c.render(<Signup errors={res.errors} />);
  }

  const login = await pb
    .collection("users")
    .authWithPassword(email as string, password as string);

  if (pb.authStore.isValid) {
    setCookie(c, "pb_auth", pb.authStore.exportToCookie());
    return c.redirect("/keys");
  }

  return c.redirect("/");
});

export default app;
