/** @jsxImportSource react */
import React from "react";
import { render } from "jsx-email";
import Markdown from "../Components/MarkdownEmail";
import HTMLToPlainText from "../Components/HTMLToPlainText";

export const render_html = async (html: string) => {
  return {
    html: html,
    // @ts-ignore
    plaintext: await render(<HTMLToPlainText markdown={markdown} />, {
      plainText: true,
    }),
  };
};

export const render_markdown = async (markdown: string) => {
  return {
    // @ts-ignore
    html: await render(<Markdown markdown={markdown} />),
    // @ts-ignore
    plaintext: await render(<Markdown markdown={markdown} />, {
      plainText: true,
    }),
  };
};

export const render_email = async (request: any) => {
  const { html, plaintext } = request.markdown
    ? await render_markdown(request.markdown)
    : await render_html(request.html);

  return {
    envelope: {
      to: request.to,
      from: request.from,
      subject: request.subject,
    },
    html,
    plaintext,
    info: "",
  };
};
