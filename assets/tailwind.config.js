const colors = require('tailwindcss/colors');
module.exports = {
  content: ['./js/**/*.js', '../lib/*_web.ex', '../lib/*_web/**/*.*ex'],
  theme: {
    extend: {
      colors: {
        gold: '#C9B037',
        bronze: '#AD8A56',
        silver: '#9ca3af',
        primary: colors.yellow,
        secondary: colors.amber,
      },
    },
  },
  plugins: [require('@tailwindcss/forms')],
};
