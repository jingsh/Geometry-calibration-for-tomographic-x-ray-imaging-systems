<script type="text/javascript">
// ==UserScript==
// @name           Run MathJax in Github
// @namespace      http://www.mathjax.org/
// @description    Runs MathJax on any page in github.com
// @include        http://github.com/*
// @include        https://github.com/*
// ==/UserScript==

/*****************************************************************/

(function () {

  function LoadMathJax() {
    if (!window.MathJax) {
      if (document.body.innerHTML.match(/$|\\\[|\\\(|<([a-z]+:)math/)) {
        var script = document.createElement("script");
        script.type = "text/javascript";
        script.src = "https://c328740.ssl.cf1.rackcdn.com/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML";
        script.text = [
          "MathJax.Hub.Config({",
          "  tex2jax: {inlineMath: [['$','$'],['\\\\\(','\\\\\)']]}",
          "});"
        ].join("\n");
        var parent = (document.head || document.body || document.documentElement);
        parent.appendChild(script);
      }
    }
  };

  var script = document.createElement("script");
  script.type = "text/javascript";
  script.text = "(" + LoadMathJax + ")()";
  var parent = (document.head || document.body || document.documentElement);
  setTimeout(function () {
    parent.appendChild(script);
    parent.removeChild(script);
  },0);

})();</script>

# Geometry-calibration-for-tomographic-x-ray-imaging-systems
An Matlab implementation for geometry calibration of an x-ray imaging system. 

The methods and algorithm are inspired by Li, Xinhua, Da Zhang, and Bob Liu. ["A generic geometric calibration method for tomographic imaging systems with flat-panel detectors—A detailed implementation guide."](http://scitation.aip.org/content/aapm/journal/medphys/37/7/10.1118/1.3431996) Medical physics 37, 7 (2010): 3844-3854.

## How to install?
Drag the function file into your project and/or add it to your matlab function search path. 

## How to use?
The function will output three values corresponding to the x-ray focal spot positions $$x$$, $$y$$, and $$z$$ in the detector coordinate system.


