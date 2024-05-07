import { HTTPException } from "hono/http-exception";

import { STATUS } from "../aws/aws";
import pbadmin from "../admin_db";

// @ts-ignore
import { mailQueue } from "../mail-queue";
import { Email } from "./lib/types";

import pb from "../db";
import { render_email } from "./lib/render";
import create_mailer from "./lib/create_mailer";
import logger from "../logger";

export type User = {};

const get = (id: string) => {
  return pb.collection("emails").getOne(id).catch(console.error);
};

const save_admin = ({ email, user }: { email: Email; user: User }) => {
  return pbadmin
    .collection("emails")
    .create({
      email_id: email.info,
      from: email.envelope.from, // sender address
      to: Array.isArray(email.envelope.to)
        ? email.envelope.to.join(",")
        : email.envelope.to, // list of receivers
      sent_by: user,
      status: STATUS.Pending,
    })
    .catch(console.error);
};

const create_email_with_aws_id = ({
  email,
  user,
}: {
  email: Email;
  user: User;
}) => {
  return pbadmin
    .collection("emails")
    .create({
      email_id: email.info,
      aws_message_id: email.info,
      from: email.envelope.from, // sender address
      to: Array.isArray(email.envelope.to)
        ? email.envelope.to.join(",")
        : email.envelope.to, // list of receivers
      sent_by: user,
      status: email.status,
    })
    .catch(console.error);
};

const link_email_to_aws = async ({
  email,
  aws_message_id,
}: {
  email: Email;
  aws_message_id: string;
}) => {
  const update = { aws_message_id };

  const record = await pbadmin
    .collection("emails")
    .getFirstListItem(`email_id="${email.uuid}"`)
    .catch(logger.format_error);

  if (record) {
    await pbadmin
      .collection("emails")
      .update(record.id, update)
      .catch(logger.format_error);
  }
};

const send = async ({ email }: { email: Email }) => {
  try {
    //  @ts-ignore
    const info = await mailQueue.sendMail({
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
  link_email_to_aws,
  create_email_with_aws_id,
};

export default Email;
