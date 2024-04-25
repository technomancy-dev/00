// @ts-nocheck
/** @jsxImportSource react */
import React from "react";

import { Html, Markdown, Tailwind, Button } from "jsx-email";

export const Template = () => {
  return (
    <Html lang="en" dir="ltr">
      <Tailwind
        config={{
          theme: {
            colors: {
              brand: "#007291",
            },
          },
        }}
      >
        <div className="bg-white text-slate-700">
          <div className="font-sans pt-0 p-16 bg-white max-w-lg mx-auto">
            <Button
              href="/dashboard/auth/sign-in"
              className="border-solid rounded py-1 px-2 border-black text-black hover:bg-black hover:text-white"
            >
              Sign in
            </Button>
            <Markdown
              markdownCustomStyles={{
                h1: { fontWeight: "bold" },
                table: {
                  borderCollapse: "collapse",
                },
                td: {
                  paddingTop: "10px",
                  paddingBottom: "10px",
                  paddingRight: "40px",
                },
                tr: { textAlign: "left", borderBottom: "1px solid #cbd5e1" },
              }}
              markdownContainerStyles={{
                padding: "12px",
              }}
            >{`
from: liltechnomancer 

--- 

# 00

Hey, 

I just wanted to tell you about **double-zero**.  

An open source self hosted *email micro-service*. 


If you want to host your own email micro service
to wrap Amazon SES, this is your new best friend. 

Get started on [Github](https://github.com)

| Provider    | Inital Cost | 100,000 email cost | 1 million email cost   |
| --------    | -------     | -------            | -------                |
| 00          | $5/mo       | $15/mo             | $115/mo                |
| 00 hosted   | $5/mo       | $30/mo             | $300/mo                |
| Resend      | $0/mo       | $35/mo             | $400/mo                |
| Plunk       | $0/mo       | $500/mo            | $5000/mo               |

If you are interested in using our hosted offer [contact me](mailto:levi@technomancy.dev)

## Write emails with markdown. 

Markdown is pretty great, it powers this page, and it should power your emails. 

> I think that markdown is pretty cool. - Levi

You can send your emails in markdown and they will look just like this. 


Sponsored by [Fido](https://google.com) which is the reason this library/micro-service exists. 

One of many.  
Made by the [technomancer](https://technomancy.dev)
          `}</Markdown>
          </div>
        </div>
        {/* OR */}
      </Tailwind>
    </Html>
  );
};

export default Template;
