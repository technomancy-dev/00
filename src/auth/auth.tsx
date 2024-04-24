/** @jsxImportSource hono/jsx */
import { Hono } from "hono";
import Signup from "./components/Signup";
import pb from "../db";

import { getCookie, setCookie } from "hono/cookie";

const app = new Hono();

app.get("/signup", async (c) => {
  return c.render(<Signup />);
});

app.post("/signup", async (c) => {
  const { email, password, passwordConfirm, name } = await c.req.parseBody();

  const res = await pb
    .collection("users")
    .create({
      email,
      password,
      passwordConfirm,
      name,
    })
    .catch((error) => {
      console.error("Error:", error.originalError.data.data);
    });

  const login = await pb
    .collection("users")
    .authWithPassword(email as string, password as string);

  setCookie(c, "pb_auth", pb.authStore.exportToCookie());

  return c.redirect("/");
});

export default app;
