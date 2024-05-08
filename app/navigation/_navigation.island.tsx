// @ts-nocheck

export default function Navigation({ user }) {
  const initial = user?.name?.split("")[0] ?? "?";

  return (
    <div class="navbar bg-base-100">
      <div class="flex-1">
        <a href="/dashboard" class="btn btn-ghost text-xl">
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
            {!user && (
              <>
                <li class="justify-between w-full text-center">
                  <a href="/auth/sign-in" class="block w-full text-center">
                    Sign In
                    {/* <span class="badge">New</span> */}
                  </a>
                </li>
                <li>
                  <a href="/auth/sign-up" class="block w-full text-center">
                    Register
                  </a>
                </li>
              </>
            )}
            {user && (
              <>
                <li className="flex w-full items-center">
                  <a className="w-full btn text-center" href="/dashboard">
                    Home
                  </a>
                </li>
                <li className="flex w-full items-center">
                  <a className="w-full btn text-center" href="/dashboard/keys">
                    Edit Keys
                  </a>
                </li>
                <li>
                  <form
                    class="w-full flex h-full"
                    action="/auth/logout"
                    method="post"
                  >
                    <button class="w-full h-full" type="submit">
                      Logout
                    </button>
                  </form>
                </li>
              </>
            )}
          </ul>
        </div>
      </div>
    </div>
  );
}
