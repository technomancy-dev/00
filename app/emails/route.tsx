import { Hono } from "hono";
import nodemailer from "nodemailer";
import { SESClient, SendRawEmailCommand } from "@aws-sdk/client-ses";
import "dotenv/config";

const app = new Hono();

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

app.post("/send", async (c) => {
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

export default app;
