// https://github.com/pocketbase/pocketbase/issues/3118#issuecomment-1701180778
// pb.js
import PocketBase from "pocketbase";

const pb = new PocketBase("http://127.0.0.1:8090");
import "dotenv";

// the email and password could be retrieved from env variables
await pb.admins.authWithPassword(
  process.env.ADMIN_EMAIL!,
  process.env.ADMIN_PASSWORD!,
  {
    autoRefreshThreshold: 30 * 60,
  }
);

export default pb;
