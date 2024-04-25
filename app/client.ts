import { createClient } from "honox/client";

createClient({
  island_root: "./",
  ISLAND_FILES: {
    ...import.meta.glob("/app/islands/**/[a-zA-Z0-9[-]+.(tsx|ts)"),
    ...import.meta.glob("/app/**/_[a-zA-Z0-9[-]+.island.(tsx|ts)"),
  },
});
