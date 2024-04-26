/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{html,js,jsx,tsx}"],
  theme: {
    extend: {},
  },
  daisyui: {
    themes: ["lofi", "black", "cmyk"],
    darkTheme: "black",
  },
  plugins: [require("daisyui")],
};
