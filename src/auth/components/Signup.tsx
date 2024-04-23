/** @jsxImportSource hono/jsx */

const Signup = () => {
  return (
    <div className="h-full grid place-items-center">
      <div className="w-full max-w-md">
        <h1 className="text-center text-6xl m-6 font-black bg-gradient-to-t from-base-100 to-base-content text-transparent bg-clip-text">
          00
        </h1>
        <form
          action=""
          method="post"
          className="flex bg-base-300 flex-col w-full max-w-md mx-auto p-10 shadow gap-2"
        >
          <label class="form-control w-full">
            <div class="label">
              <span class="label-text">What is your name?</span>
            </div>
            <input
              type="text"
              placeholder="Bruce Wayne"
              name="name"
              class="input input-bordered w-full"
            />
          </label>
          <label class="form-control w-full">
            <div class="label">
              <span class="label-text">What is your email?</span>
            </div>
            <input
              type="text"
              placeholder="b4t@waynecorp.com"
              name="email"
              class="input input-bordered w-full"
            />
          </label>
          <label class="form-control w-full">
            <div class="label">
              <span class="label-text">Select a password</span>
            </div>
            <input
              type="password"
              name="password"
              class="input input-bordered w-full"
            />
          </label>
          <label class="form-control w-full">
            <div class="label">
              <span class="label-text">Confirm your password</span>
            </div>
            <input
              type="password"
              name="passwordConfirm"
              class="input input-bordered w-full"
            />
          </label>
          <button class="btn btn-primary mt-4">Register</button>
        </form>
      </div>
    </div>
  );
};

export default Signup;
