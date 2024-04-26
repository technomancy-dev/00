// @ts-nocheck
import ClickToCopy from "./_clickToCopy.island";
import Regenerate from "./_regenerateApiKey.island";

const KeyForm = ({ secret, hash, aws_key, aws_secret, edit }) => {
  return (
    <div className="h-full grid place-items-center">
      <div className="w-full max-w-md">
        <h1 className="text-center -mb-2 text-6xl m-6 font-black bg-gradient-to-t from-base-100 to-base-content text-transparent bg-clip-text">
          Top Secret
        </h1>
        {!edit && (
          <div>
            <p className="text-center text-xl font-black">API Auth Key.</p>
            <p className="text-center text-sm">
              Copy this key and keep it somewhere safe. We won't show it again.
            </p>
            <div className="bg-neutral text-neutral-content p-2 my-2">
              <span className="text-center">
                <ClickToCopy clipboard={secret}>{secret}</ClickToCopy>
              </span>
            </div>
          </div>
        )}
        <form
          action={edit ? "keys/edit" : ""}
          method="post"
          className="flex bg-base-300 flex-col w-full max-w-md mx-auto p-10 shadow gap-2"
        >
          {edit && <Regenerate />}
          {!edit && (
            <label class="form-control hidden w-full">
              <div class="label">
                <span class="label-text">Access Hash</span>
              </div>
              <input
                type="text"
                value={hash}
                name="hash"
                class="input input-bordered w-full"
              />
            </label>
          )}
          <label class="form-control w-full">
            <div class="label">
              <span class="label-text">What is your aws access key?</span>
            </div>
            <input
              value={aws_key}
              type="password"
              name="aws_key"
              class="input input-bordered w-full"
            />
            {edit && (
              <div class="label">
                <span class="label-text-alt text-base-content/50">
                  This will overwrite your saved key.
                </span>
              </div>
            )}
          </label>
          <label class="form-control w-full">
            <div class="label">
              <span class="label-text">What is your aws access secret?</span>
            </div>
            <input
              value={aws_secret}
              type="password"
              name="aws_secret"
              class="input input-bordered w-full"
            />
            {edit && (
              <div class="label">
                <span class="label-text-alt text-base-content/50">
                  This will overwrite your saved key.
                </span>
              </div>
            )}
          </label>

          <button class="btn btn-primary mt-4">
            {edit ? "Overwrite" : "Save"}
          </button>
        </form>
      </div>
    </div>
  );
};

export default KeyForm;
