import crypto from "crypto";
import chalk from "chalk";

const key = crypto.randomBytes(16).toString("hex");
const iv = crypto.randomBytes(8).toString("hex");

console.log(chalk.greenBright("key", key));
console.log(chalk.greenBright("iv ", iv));
