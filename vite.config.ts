import path from "path";
import pages from "@hono/vite-cloudflare-pages";
import honox from "honox/vite";
import client from "honox/vite/client";
import { defineConfig } from "vite";

const root = "./";

export default defineConfig(({ mode }) => {
  if (mode === "client") {
    return {
      plugins: [client()],
    };
  } else {
    return {
      ssr: {
        external: [
          "react",
          "react-dom",
          "jsx-email",
          "bcrypt",
          "dotenv",
          "nodemailer",
          "@aws-sdk/client-ses",
          "sns-payload-validator",
        ],
      },
      plugins: [
        honox({
          islandComponents: {
            isIsland: (id) => {
              const resolvedPath = path.resolve(root).replace(/\\/g, "\\\\");
              const regexp = new RegExp(
                `${resolvedPath}[\\\\/]app[^\\\\/]*[\\\\/]islands[\\\\/].+\.tsx?$|${resolvedPath}[\\\\/]app[^\\\\/]*.+\.island\.tsx?$`
              );

              return regexp.test(path.resolve(id));
            },
          },
        }),
        pages(),
      ],
    };
  }
});
