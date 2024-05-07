// https://github.com/pocketbase/pocketbase/issues/3118#issuecomment-1701180778
import PocketBase from "pocketbase";
import logger from "./logger";
import "dotenv/config";

const pb = new PocketBase(
  import.meta.env.PROD ? process.env.PRODUCTION_DB_URL : "http://127.0.0.1:8090"
);

await pb.admins
  .authWithPassword(process.env.ADMIN_EMAIL!, process.env.ADMIN_PASSWORD!, {
    autoRefreshThreshold: 30 * 60,
  })
  .catch((e) => {
    logger.break();
    logger.error(
      "Admin Authentication failed. Have you created the system admin user yet? Is your database running and healthy?"
    );
    logger.error(`${e.name}: ${e.message}`);
    logger.break();
    logger.format_error(e);
  });

export default pb;
