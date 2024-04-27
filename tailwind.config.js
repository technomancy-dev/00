/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{html,js,jsx,tsx}"],
  theme: {
    extend: {},
  },
  daisyui: {
    themes: [
      "lofi",
      {
        black: {
          ...require("daisyui/src/theming/themes")["black"],
          warning: "#f4bf50",
          success: "#2cd4bf",
          error: "#fb6f85",
        },
      },
      "cmyk",
    ],
    darkTheme: "black",
  },
  plugins: [require("daisyui")],
};
