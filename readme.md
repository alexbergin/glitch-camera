## Frontend Setup

If you've already setup `Node`, `Compass`, `Grunt` and `Bower` from a previous project, here's the quick setup guide to get you started.

1. Edit `package.json` to manage Node modules required for Grunt tasks
2. Run `npm install` and `bower install` to install/update third party scripts used in the project
3. Run `grunt start` to compile markup, css, watch for changes, and open a window with BrowserSync to start developing

## Notes

The source files that compile into html/css/js can be found in `src`.

- `src/coffee` -> `app/scripts`
- `src/mustache` -> `app/index.html`
- `src/sass` -> `app/styles/main.css`