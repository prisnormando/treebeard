
<p align="center">
  <img src="https://raw.githubusercontent.com/CenterForOpenScience/treebeard/master/demo/treebeard.png" alt="Treebeard Logo"/>
</p>

Develop: <img src="https://travis-ci.org/CenterForOpenScience/treebeard.svg?branch=develop" alt="Travis build fopr Develop"/>

Master: <img src="https://travis-ci.org/CenterForOpenScience/treebeard.svg?branch=master" alt="Travis build for Master"/>

<i style="text-align:center"> Logo designed by [fayetality](https://github.com/fayetality "fayetality")  </i>

treebeard
=========

Hierarchical data renderer built with Mithril


Using the library
-----------------

You can install Treebeard with bower. In your project simply run 

```bower install treebeard --save```

Remember to reference the required files through bower_components. 


You can also just take the files in `/dist` folder. You need the css and js files, either minified or in full and add them to your project page.

```html
<link rel="stylesheet" href="path/to/treebeard.css" type="text/css" />
<script src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
<script src="path/to/mithril.js"></script>
<script src="path/to/treebeard.js"></script>
```

### CommonJS

If you are using a CommonJS-compatible module loader (e.g. Webpack or Browserify), you can load treebeard like so:

```js
var Treebeard = require('treebeard');
```

**NOTE for Webpack users**: Loading Treebeard with Webpack will load its CSS as a module using the `style-loader` and `css-loader`. You should configure Webpack to use these loaders for `.css` files.

```
npm install style-loader css-loader --save
```

Add the following to your Webpack config.

```js
// webpack.config.js
// ...
  module: {
    loaders: [
      { test: /\.css$/, loader: 'style!css' },
    ],
  },
```

* * * 
Read more about using the library in the Wiki: https://github.com/CenterForOpenScience/treebeard/wiki

* * * 


Installation for Developers
---------------------------
If you are a developer and want to work on the source code use the guide below. 

Begin by cloning the project in any way that support your work flow, then go to the main project folder and  run the following commands to install dependencies

For NPM:

    npm install

for Bower 

    bower install

then run gulp like this 

    gulp 

Gulp will be watching for changes in the CSS, LESS and JS files so any time you change the distribution folder will be automatically regenerated. 


If you would like a simple server instance for this app you can install http-server
https://www.npmjs.org/package/http-server
Install with NPM:

    npm install http-server
