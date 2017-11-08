:Class TeXPage : #.MiPage

    ∇ {r}←Wrap
      :Access Public
      Use'MathJax-TeX/LaTeX'
      'type=x-mathjax-config'Head.Insert _.Script ScriptFollows
⍝  MathJax.Hub.Config({
⍝    extensions: ["tex2jax.js"],
⍝    jax: ["input/TeX", "output/HTML-CSS"],
⍝    tex2jax: {
⍝      inlineMath: [ ['$','$'], ["\\(","\\)"] ],
⍝      displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
⍝      processEscapes: true
⍝    },
⍝    "HTML-CSS": { availableFonts: ["TeX"] }
⍝  });
      r←⎕BASE.Wrap
    ∇

:EndClass
