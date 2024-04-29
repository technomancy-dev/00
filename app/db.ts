import PocketBase from "pocketbase";
import "dotenv";

const pb = new PocketBase(
  import.meta.env.PROD ? process.env.PRODUCTION_DB_URL : "http://127.0.0.1:8090"
);

export default pb;
