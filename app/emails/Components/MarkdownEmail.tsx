// @ts-nocheck
/** @jsxImportSource react */
import React from "react";

import { Html, Markdown, Tailwind } from "jsx-email";

export const Template = ({ markdown }) => {
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
          <div className="font-sans p-16 bg-white max-w-md mx-auto">
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
            >
              {markdown}
            </Markdown>
          </div>
        </div>
      </Tailwind>
    </Html>
  );
};

export default Template;
