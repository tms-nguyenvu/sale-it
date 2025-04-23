module.exports = {
  content: [
    "./app/views/**/*.{html,erb}",
    "./app/components/**/*.{html,erb,rb}",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#3bb4b8"
      }
    },
  },
  plugins: [require('daisyui')],
  daisyui: {
    themes: ["light"],
  },
}
