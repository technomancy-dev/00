// @ts-nocheck
import { useState } from "hono/jsx";
import ClickToCopy from "./_clickToCopy.island";

const RegenerateApiKey = ({ children, clipboard }) => {
  const [regenerated, set_regenerated] = useState(false);
  const [new_key, set_new_key] = useState(null);

  const regenerate = async () => {
    const response = await fetch("/api/new-key").catch(console.log);
    const key_and_hash = await response.json();
    set_new_key(key_and_hash);
  };

  return (
    <div class="pt-6">
      <p class="text-center text-xl font-black">Regenerate API Auth Key.</p>
      <button
        type="button"
        onClick={regenerate}
        class="w-full btn btn-ghost mt-6"
      >
        Regenerate
      </button>
      {new_key && (
        <>
          <label class="form-control hidden w-full">
            <div class="label">
              <span class="label-text">Access Hash</span>
            </div>
            <input
              type="text"
              value={new_key.hash}
              name="hash"
              class="input input-bordered w-full"
            />
          </label>
          <p class="text-center text-sm">
            Copy this key and keep it somewhere safe. We won't show it again.
          </p>
          <div class="bg-neutral text-neutral-content p-2 my-2">
            <span class="text-center text-xs">
              <ClickToCopy clipboard={new_key.key}>{new_key.key}</ClickToCopy>
            </span>
          </div>
        </>
      )}
    </div>
  );
};

export default RegenerateApiKey;
