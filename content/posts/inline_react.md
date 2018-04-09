{
   "categories": [
      "Development",
      "Web Development"
   ],
   "date": "2017-12-13",
   "description": "Send everything in 1 GET response",
   "tags": [
      "js",
      "npm",
      "web",
      "frontend",
      "gui",
      "react",
      "materialui"
   ],
   "title": "Inlining a React/Material-UI web app"
}
# Inlining a React/Material-UI web app

This guide was originally [posted on Medium](https://medium.com/front-end-hacking/inlining-a-react-material-ui-web-app-using-npm-scripts-5ffd955d05b2).
I am reposting here to test the features of my new [Hugo](https://gohugo.io/) website.

---

**Node package manager (npm)**

npm is used to download packages and run build commands, it can be downloaded as part of nodejs:

https://nodejs.org/en/download/

---

**Creating a new project**

Make a project folder and initialize npm inside of it:
```
$ mkdir ReactCalculator
$ cd ReactCalculator/
$ npm init
```

You can safely press enter through most/all questions. This is my resulting package.json:
```
{
  "name": "reactcalculator",
  "version": "0.1.0",
  "description": "An example application",
  "main": "index.html",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "olehermanse",
  "license": "MIT"
}
```

Note the scripts field; this is where we will add build commands later.

---

**Installing packages**

Use npm to install dependencies:
```
$ npm install --save material-ui react react-dom
$ npm install --save-dev babel-core babel-loader babelify browserify
$ npm install --save-dev babel-preset-env babel-preset-react babel-preset-stage-0
$ npm install --save-dev express inline-source inline-source-cli uglify
```

*Tip: The--save flags add the packages to package.json , if you’re using the example project you can install them by running npm install.*

---

**A simple HTML skeleton**

Our app will consist of HTML, CSS, and JavaScript files.
The build system will compile all of these into a single file, `index.html`, using the `inline-source` package.
Let’s create some empty files:
```
$ mkdir src
$ touch src/main.html src/main.css src/main.jsx
```

Let’s add some content to src/main.html:
```
<!doctype html>
<html>
<head>
  <link inline rel="stylesheet" type="text/css" href="main.css" />
</head>
<body>
  <div id=body_main class=body_main>
  </div>
  <script inline src="main.js"></script>
</body>
</html>
```
Note the inline keyword in both `<link>` and `<script>` tags.
`inline-source` will replace these tags with the contents of the referenced files.
The `body_main` div content will be controlled by JavaScript(React).


---

**Content to inline**

To see the effects of inlining, we should add some simple content to the JavaScript and CSS files:
```
$ echo '* { background-color: #CCCCCC; }' > src/main.css
$ echo 'document.getElementById("body_main").innerHTML = "Hello, JavaScript";' > src/main.jsx
```

---

A simple build system using inline-source
In package.json we can add build commands in the scripts section:
```
"scripts": {
  "prebuild": "mkdir -p ./build",
  "build:css": "cp ./src/main.css ./build/main.css",
  "build:js": "cp ./src/main.jsx ./build/main.js",
  "build:inline": "inline-source --root ./build ./src/main.html > build/index.html",
  "build": "npm run build:js && npm run build:css && npm run build:inline"
}
```
`prebuild` runs before `build`, making sure the build folder exists.
`build:js` and `build:css` copy the files into the build folder.
They are then inlined using the `inline-source` command.

Now, build:
```
$ npm run build
```

That’s it. build/index.html now contains both HTML, CSS, and JavaScript:
```
<!doctype html>
<html>
<head>
  <style type="text/css">* { background-color: #CCCCCC; }
</style>
</head>
<body>
  <div id=body_main class=body_main>
  </div>
  <script>document.getElementById("body_main").innerHTML = "Hello, JavaScript";
</script>
</body>
</html>
```

You don't need a development server, you can just open build/index.html in your browser of choice.
The background color should be grey, and the text should say “Hello, JavaScript”.

*Tip: Inlining is not limited to JavaScript and CSS. The inline-source package can also inline images. There are more packages for inlining other data, like JSON.*

---

**React, babel, JSX, browserify and uglify**

When writing React apps and components, JSX is preferred over plain JavaScript.
`babel` can be used to transpile JSX to javascript.
It also translates newer syntax (ES6) to old syntax equivalents.
Another piece of magic is `browserify`, which bundles dependencies.
You can `require('modules')` and it just works.
The final part of our javascript build command will be `uglifyjs` which reduces the size of the javascript file before inlining.

The `build:js` command in package.json should look something like this:
```
browserify -t [ babelify  --presets [ env stage-0 react ] ] src/main.jsx | uglifyjs -mc > build/main.js
```

Run the build command again, `npm run build`, to make sure you haven't introduced any errors.
The resulting `index.html` should look identical, we haven’t made any changes to the content, but the build system is now ready to build a React app written in JSX and ES6.

---

**React app with Material-UI components**

I’ve created a simple example project to show how this build system works with JSX and Material-UI code.
Feel free to [download from GitHub](https://github.com/olehermanse/ReactCalculator) and experiment yourself.
Teaching React or Material-UI is outside the scope of this tutorial.
Excellent documentation is available for both, see the links below.

---

**Learn more**

Example app available on GitHub: https://github.com/olehermanse/ReactCalculator

Inline-source documentation: https://github.com/popeindustries/inline-source

Material-UI documentation: https://material-ui.com/#/get-started/usage

React (and JSX) documentation: https://reactjs.org

An overview of JavaScript build systems: https://ponyfoo.com/articles/choose-grunt-gulp-or-npm

More information on npm scripts: https://medium.freecodecamp.org/why-i-left-gulp-and-grunt-for-npm-scripts-3d6853dd22b8
