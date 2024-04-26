import crypto from "crypto";
import "dotenv/config";

const algorithm = "aes-256-cbc";
const key = process.env.CRYPTO_KEY!;
const iv = process.env.CRYPTO_IV!;

export const encrypt = (text) => {
  const cipher = crypto.createCipheriv(
    algorithm,
    Buffer.from(key),
    Buffer.from(iv)
  );
  let encrypted = cipher.update(text, "utf8", "hex");
  encrypted += cipher.final("hex");
  return encrypted;
};

export const decrypt = (encrypted) => {
  const decipher = crypto.createDecipheriv(
    algorithm,
    Buffer.from(key),
    Buffer.from(iv)
  );
  let decrypted = decipher.update(encrypted, "hex", "utf8");
  decrypted += decipher.final("utf8");
  return decrypted;
};

export default { encrypt, decrypt };
