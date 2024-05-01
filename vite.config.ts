import path from "path";
import honox from "honox/vite";
import client from "honox/vite/client";
import { defineConfig } from "vite";
import { resolve } from "path";
import nodeServerPlugin from "./vite-node-server-plugin";

const root = "./";

export default defineConfig(({ mode }) => {
  if (mode === "client") {
    return {
      build: {
        manifest: true,
        rollupOptions: {
          input: {
            styles: "/output.css",
            client: "/app/client.ts",
          },
          output: {
            entryFileNames: "static/[name].[hash].js",
            chunkFileNames: "static/chunks/[name].[hash].js",
            assetFileNames: "static/assets/[name].[ext]",
          },
        },
      },
    };
  } else {
    return {
      build: {
        target: "esnext",
      },
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
          "pino",
          "pino-pretty",
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
        nodeServerPlugin(),
      ],
    };
  }
});
