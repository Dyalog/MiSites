:Class bbbPage : MiPage
⍝ This is a MiPage template implements the look and feel for the Brian's Burger Bistro sample MiSite presented at DYNA16

⍝ All templates need a public method named "Wrap"

    ∇ Wrap;lang
      :Access Public
     
    ⍝ we use JQuery to set up the handler, so we tell the page to include JQuery resources
      Use'JQuery' ⍝ "JQuery" is a resource defined in Config/Resources.xml
     
    ⍝ set the title display in the browser to the name of the application defined in Config/Server.xml
      Add _.title _Request.Server.Config.Name
     
    ⍝ add tab/window icon
      (Add _.link).Set'href="/Styles/Images/favicon.ico" rel="icon" type="image/x-icon"'
     
    ⍝ add a link to our CSS stylesheet
      Add _.StyleSheet'/Styles/style.css'
     
    ⍝ set a meta tag to make it explicitly UTF-8
      (Add _.meta).Set'http-equiv="content-type" content="text/html;charset=UTF-8"'
     
⍝↓↓↓ This section implements the feature to toggle the display between the HTML page and the page's APL source code
    ⍝ wrap the content of the <body> element in a div
      'contentblock'Body.Push _.div
     
    ⍝ add a hidden division to the body containing the APL source code
      (Add _.div(#.HTMLInput.APLToHTML ⎕SRC⊃⊃⎕CLASS ⎕THIS)).Set'id="codeblock" style="display: none;"'
     
    ⍝ add a JQuery event handler to toggle the web page/APL source code
      Add _.Script'$(function(){$("#bannerimage").on("click", function(evt){$("#contentblock,#codeblock").toggle();});});'
⍝↑↑↑
     
    ⍝ add the footer to the bottom of the page
      Add #.Files.GetText _Request.Server.Config.Root,'Styles\footer.txt'
     
    ⍝ add the header to the top of the page
      Body.Push #.Files.GetText _Request.Server.Config.Root,'Styles\banner.txt'
     
    ⍝ enclose the page content in a div with id="wrapper"
      'wrapper'Body.Push _.div
     
⍝↓↓↓ your page must call the base class Wrap function
      ⎕BASE.Wrap
    ∇

:EndClass
