export type Info = {
  response: string | null;
};

export type Email = {
  envelope: {
    to: string;
    from: string | string[];
    subject: string;
  };
  html: string;
  plaintext: string;
  info: Info;
};

export type SendEmail = ({ email }: { email: Email }) => Info;
