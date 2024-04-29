/** @jsxImportSource hono/jsx */
import { Hono } from "hono";
import { deleteCookie, setCookie } from "hono/cookie";
import { map } from "ramda";

import pb from "../db";

import { z } from "zod";

import Signup from "./components/Signup";
import Signin from "./components/Signin";

const flatten_db_errors = (error) => {
  return map((item) => [item.message], error?.originalError?.data?.data);
};

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

const SigninSchema = z.object({
  email: z.string().email(),
  password: z
    .string()
    .min(10, { message: "Must be 10 or more characters long" }),
});

const app = new Hono();

app.post("/logout", async (c) => {
  pb.authStore.clear();
  deleteCookie(c, "pb_auth");
  return c.redirect("/");
});

app.get("/sign-up", async (c) => {
  if (pb.authStore.isValid) {
    return c.redirect("/dashboard");
  }
  return c.render(<Signup />);
});

app.get("/sign-in", async (c) => {
  if (pb.authStore.isValid) {
    return c.redirect("/dashboard");
  }
  return c.render(<Signin />);
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
    return c.redirect("/dashboard/keys");
  }

  return c.redirect("/");
});

app.post("/sign-in", async (c) => {
  const { email, password } = await c.req.parseBody();
  const { data, success, error } = SigninSchema.safeParse({
    email,
    password,
  });

  if (success === false) {
    const errors = error.flatten().fieldErrors;
    return c.render(<Signin errors={errors} />);
  }

  const login = await pb
    .collection("users")
    .authWithPassword(email as string, password as string)
    .catch((error) => {
      const errors = {
        ...flatten_db_errors(error),
      };
      return { errors };
    });

  if (login.errors) {
    return c.render(<Signup errors={login.errors} />);
  }

  if (pb.authStore.isValid) {
    setCookie(c, "pb_auth", pb.authStore.exportToCookie());
    return c.redirect("/dashboard");
  }

  return c.redirect("/");
});

export default app;
