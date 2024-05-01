import chalk from "chalk";

const horizontal_rule = (color: string = "red", length: number = 80) => {
  //  @ts-ignore
  console.log(chalk[color]("-".repeat(length)));
};

export const format_error = (e: Error) => {
  horizontal_rule("red", e.message.length);
  console.error(chalk.redBright(e.message));
  console.log("     ");
  // @ts-ignore
  console.error(chalk.bgRed(e?.originalError.cause));
  console.log("     ");
  // @ts-ignore
  console.error(e?.originalError.cause);
  horizontal_rule("red", e.message.length);
  console.error(e);
};

const error = (e: string) => console.error(chalk.redBright(e));

export default {
  format_error,
  error,
  break: horizontal_rule,
};
