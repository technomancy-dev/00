// @ts-nocheck
import { useState } from "hono/jsx";

export default function Navigation({ user }) {
  const initial = user?.name?.split("")[0] ?? "?";

  return (
    <div class="navbar bg-base-100">
      <div class="flex-1">
        <a href="/" class="btn btn-ghost text-xl">
          Double Zero
        </a>
      </div>
      <div class="flex-none gap-2">
        <div class="dropdown dropdown-end">
          <div
            tabindex="0"
            role="button"
            class="btn btn-ghost btn-circle grid place-items-center avatar"
          >
            <p class="font-black capitalize text-2xl">{initial}</p>
          </div>
          <ul
            tabindex="0"
            class="mt-3 z-[1] p-2 shadow menu menu-sm dropdown-content bg-base-100 rounded-box w-52"
          >
            {/* <li>
              <a class="justify-between">
                Profile
                <span class="badge">New</span>
              </a>
            </li>
            <li>
              <a>Settings</a>
            </li> */}
            <li>
              <form
                className="w-full flex h-full"
                action="/auth/logout"
                method="post"
              >
                <button className="w-full h-full" type="submit">
                  Logout
                </button>
              </form>
            </li>
          </ul>
        </div>
      </div>
    </div>
  );
}
