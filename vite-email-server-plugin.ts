import { builtinModules } from "module";
import type { Plugin, UserConfig } from "vite";

export const nodeServerPlugin = (): Plugin => {
  return {
    name: "@hono/vite-email-server",
    config: async (): Promise<UserConfig> => {
      return {
        ssr: {
          external: [],
          noExternal: true,
        },
        build: {
          target: "esnext",
          outDir: "./dist",
          emptyOutDir: false,
          minify: true,
          ssr: true,
          rollupOptions: {
            external: [...builtinModules, /^node:/],
            input: "./app/mail-job.ts",
            output: {
              entryFileNames: "mail.mjs",
            },
          },
        },
      };
    },
  };
};

export default nodeServerPlugin;
