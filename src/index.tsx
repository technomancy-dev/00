import { serve } from "@hono/node-server";
import { Hono } from "hono";
import { bearerAuth } from "hono/bearer-auth";
import { render } from "jsx-email";
import { env } from "hono/adapter";

import { Template } from "./emails/WelcomeEmail";
import { Template as Markdown } from "./emails/MarkdownEmail";
import React from "react";
import { customAlphabet } from "nanoid";
import nodemailer from "nodemailer";
import { SESClient, SendRawEmailCommand } from "@aws-sdk/client-ses";
import bcrypt from "bcrypt";
import "dotenv/config";

import monitor from "./monitor";
import auth from "./auth/auth";
import app from "./wrapper";

// app.use("/public/*", serveStatic({ root: "./" }));

const ses = new SESClient({
  apiVersion: "2010-12-01",
  region: "us-east-1",
  credentials: {
    accessKeyId: process.env.SECRET_AWS_ACCESS_KEY!,
    secretAccessKey: process.env.SECRET_AWS_SECRET_ACCESS_KEY!,
  },
});

// create Nodemailer SES transporter
let transporter = nodemailer.createTransport({
  SES: { ses, aws: { SendRawEmailCommand } },
});

const nanoid = customAlphabet(
  "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
);

// const app = new Hono();

app.get("/", async (c) => {
  const html = await render(<Template />);
  return c.html(html);
});

app.route("/monitor", monitor);
app.route("/auth", auth);

app.use("/api/*", (c, next) => {
  const { SECRET_SKELETON_KEY } = env(c);
  return bearerAuth({
    verifyToken: async (token, c) => {
      const pass = token.split("_")[1];
      const hash = SECRET_SKELETON_KEY.split("_")[1];
      return bcrypt.compareSync(pass, hash);
    },
  })(c, next);
});

app.post("/api/send", async (c) => {
  const post = await c.req.json();
  let html = post.html;
  if (post.markdown) {
    html = await render(<Markdown markdown={post.markdown} />);
  }
  const info = await transporter.sendMail({
    from: post.from, // sender address
    to: post.to, // list of receivers
    subject: post.subject, // Subject line
    text: "Hello world?", // plain text body
    html: html, // html body
  });

  return c.html(html);
});

app.get("/api-key", async (c) => {
  const id = nanoid(6);
  const password = nanoid(36);
  const hash = bcrypt.hashSync(password, 10);
  console.warn(
    "You will only ever see this once. Keep this version for requests."
  );
  console.log(`${id}_${password}`);
  console.log("This is the version we will store");
  console.log(`${id}_${hash}`);
  return c.json({ key: `${id}_${password}`, hash: `${id}_${hash}` });
});

const port = 3000;
console.log(`⛵  localhost:${port}`);

serve({
  fetch: app.fetch,
  port,
});
