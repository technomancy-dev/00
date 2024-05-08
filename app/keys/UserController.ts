import { HTTPException } from "hono/http-exception";
import pb from "../db";
import logger from "../logger";
import { reject, anyPass, isEmpty, isNil } from "ramda";

const omitNullable = reject(anyPass([isEmpty, isNil]));

const get_key_entry = ({ user }) => {
  return pb
    .collection("application_keys")
    .getFirstListItem(`user="${user?.id}"`)
    .catch(logger.format_error);
};

const create_key_entry = ({
  aws_account_id,
  hash,
}: {
  aws_account_id: string;
  hash: string;
}) => {
  const user = pb.authStore?.model!;
  const [key_id, key_hash] = hash.split("_");

  return pb
    .collection("application_keys")
    .create({
      user: user.id,
      key_hash,
      key_id,
      aws_account_id,
    })
    .catch(logger.format_error);
};

const update_key_entry = async ({
  aws_account_id,
  hash,
}: {
  aws_account_id: string;
  hash: string;
}) => {
  const res = await pb
    .collection("application_keys")
    .getFirstListItem("")
    .catch(logger.format_error);

  if (!res) {
    throw new HTTPException(401, {
      message:
        "No record found to edit. Please refresh the page and create a key.",
    });
  }
  const [key_id, key_hash] = hash?.split("_") ?? [];

  const update = omitNullable({
    aws_account_id,
    key_id,
    key_hash,
  });

  return pb
    .collection("application_keys")
    .update(res.id, update)
    .catch(logger.format_error);
};

export default {
  get_key_entry,
  create_key_entry,
  update_key_entry,
};
