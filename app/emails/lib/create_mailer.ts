import { SESClient, SendRawEmailCommand } from "@aws-sdk/client-ses";
import nodemailer from "nodemailer";

export const create_mailer = (
  aws_key_encrypted: string,
  aws_secret_encrypted: string,
  region: string
) => {
  const aws_key = aws_key_encrypted;
  const aws_secret = aws_secret_encrypted;

  const ses = new SESClient({
    apiVersion: "2010-12-01",
    region: region,
    credentials: {
      accessKeyId: aws_key,
      secretAccessKey: aws_secret,
    },
  });

  let transporter = nodemailer.createTransport({
    SES: { ses, aws: { SendRawEmailCommand } },
  });

  return transporter;
};

export default create_mailer;
