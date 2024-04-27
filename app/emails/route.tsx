import { Hono } from "hono";
import { HTTPException } from "hono/http-exception";
import nodemailer from "nodemailer";
import { SESClient, SendRawEmailCommand } from "@aws-sdk/client-ses";
import "dotenv/config";
import { decrypt } from "../lib/crypto";
import pb from "../db";
import pbadmin from "../admin_db";
import { STATUS } from "../aws/aws";

const app = new Hono();

app.use(async (c, next) => {
  const aws_key_encrypted = c.get("aws_key");
  const aws_secret_encrypted = c.get("aws_secret");

  if (!aws_key_encrypted || !aws_secret_encrypted) {
    throw new HTTPException(401, { message: "AWS credentials missing." });
  }

  const aws_key = decrypt(aws_key_encrypted);
  const aws_secret = decrypt(aws_secret_encrypted);

  const ses = new SESClient({
    apiVersion: "2010-12-01",
    region: "us-east-1",
    credentials: {
      accessKeyId: aws_key,
      secretAccessKey: aws_secret,
    },
  });

  // create Nodemailer SES transporter
  let transporter = nodemailer.createTransport({
    SES: { ses, aws: { SendRawEmailCommand } },
  });

  // let transporter = nodemailer.createTransport({
  //   host: "smtp.ethereal.email",
  //   port: 587,
  //   secure: false, // true for 465, false for other ports
  //   auth: {
  //     user: "theresia.carroll22@ethereal.email", // generated ethereal user
  //     pass: "d8FugFKg1qf4G82Etf", // generated ethereal password
  //   },
  // });

  c.set("mail", transporter);
  await next();
});

app.post("/send", async (c) => {
  const user = c.get("user");

  const post = await c.req.json();
  let html = post.html;
  if (post.markdown) {
    html = await render(<Markdown markdown={post.markdown} />);
  }
  const mail = c.get("mail");

  try {
    const info = await mail.sendMail({
      from: post.from, // sender address
      to: post.to, // list of receivers
      subject: post.subject, // Subject line
      text: "Hello world?", // plain text body
      html: html, // html body
      ses: {
        // If using Amazon SNS, it needs this field
        ConfigurationSetName: "default",
      },
    });

    pbadmin.collection("emails").create({
      aws_message_id: info.response,
      from: post.from, // sender address
      to: Array.isArray(post.to) ? post.to.join(",") : post.to, // list of receivers
      sent_by: user,
      status: STATUS.Pending,
    });
  } catch (error) {
    throw new HTTPException(401, { message: error });
  }

  return c.json({ success: true });
});

export default app;
