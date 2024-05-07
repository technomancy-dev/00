export type Info = string | null;

export type Email = {
  uuid?: string;
  status?: string;
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
