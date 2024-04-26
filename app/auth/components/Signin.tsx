// @ts-nocheck

const Signin = ({ errors }) => {
  return (
    <div className="h-full grid place-items-center">
      <div className="w-full max-w-md">
        <h1 className="text-center text-6xl m-6 font-black">00</h1>
        <form
          method="post"
          className="flex bg-base-300 flex-col w-full max-w-md mx-auto p-10 shadow gap-2"
        >
          {errors?.form && (
            <p>
              There was an error submitting your form. <br /> {errors.form}
            </p>
          )}
          <label class="form-control w-full">
            <div class="label">
              <span class="label-text">What is your email?</span>
              {errors?.email && (
                <span class="label-text-alt text-error">
                  {errors.email.join(" ")}
                </span>
              )}
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
              {errors?.password && (
                <span class="label-text-alt text-error">
                  {errors.password.join(" ")}
                </span>
              )}
            </div>
            <input
              type="password"
              name="password"
              class="input input-bordered w-full"
            />
          </label>
          <button class="btn btn-primary mt-4">Sign In</button>
        </form>
        <a href="sign-up" class="btn btn-ghost w-full btn-secondary mt-4">
          Register
        </a>
      </div>
    </div>
  );
};

export default Signin;
