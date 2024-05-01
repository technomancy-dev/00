import { Hono } from "hono";
import Emails from "./Actions";

const app = new Hono();

app.post("/send", ...Emails.send);

export default app;
