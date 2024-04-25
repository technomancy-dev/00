import bcrypt from "bcrypt";
import { customAlphabet } from "nanoid";

const nanoid = customAlphabet(
  "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
);

const generate_key_and_hash = () => {
  const id = nanoid(6);
  const password = nanoid(36);
  const hash = bcrypt.hashSync(password, 10);
  const pair = { key: `${id}_${password}`, hash: `${id}_${hash}` };
  return pair;
};

export default generate_key_and_hash;
