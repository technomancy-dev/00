// https://github.com/pocketbase/pocketbase/issues/3118#issuecomment-1701180778
import PocketBase from "pocketbase";
import chalk from "chalk";
import "dotenv/config";
import logger from "./logger";

const pb = new PocketBase(
  import.meta.env.PROD ? process.env.PRODUCTION_DB_URL : "http://127.0.0.1:8090"
);

await pb.admins
  .authWithPassword("poop", process.env.ADMIN_PASSWORD!, {
    autoRefreshThreshold: 30 * 60,
  })
  .catch((e) => {
    logger.break();
    logger.error(
      "Admin Authentication failed. Have you created the system admin user yet?"
    );
    logger.error(`${e.name}: ${e.message}`);
    logger.break();
  });

export default pb;
