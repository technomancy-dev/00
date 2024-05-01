import { HTTPException } from "hono/http-exception";

import { STATUS } from "../aws/aws";
import pbadmin from "../admin_db";
import { Email } from "./lib/types";

import pb from "../db";
import { render_email, render_html, render_markdown } from "./lib/render";
import create_mailer from "./lib/create_mailer";

export type User = {};

const get = (id: string) => {
  return pb.collection("emails").getOne(id).catch(console.error);
};

const save_admin = ({ email, user }: { email: Email; user: User }) => {
  return pbadmin.collection("emails").create({
    aws_message_id: email.info.response,
    from: email.envelope.from, // sender address
    to: Array.isArray(email.envelope.to)
      ? email.envelope.to.join(",")
      : email.envelope.to, // list of receivers
    sent_by: user,
    status: STATUS.Pending,
  });
};

const send = async ({ mailer, email }: { mailer: any; email: Email }) => {
  try {
    const info = await mailer.sendMail({
      from: email.envelope.from, // sender address
      to: email.envelope.to, // list of receivers
      subject: email.envelope.subject, // Subject line
      text: email.plaintext, // plain text body
      html: email.html, // html body
      ses: {
        // If using Amazon SNS, it needs this field
        ConfigurationSetName: "default",
      },
    });
    return { ...email, info };
  } catch (error: any) {
    throw new HTTPException(401, { message: error || "No error supplied" });
  }
};

const Email = {
  save_admin,
  send,
  get,
  create_mailer,
  render_email,
};

export default Email;
