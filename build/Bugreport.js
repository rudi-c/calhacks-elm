Elm.Bugreport = Elm.Bugreport || {};
Elm.Bugreport.make = function (_elm) {
   "use strict";
   _elm.Bugreport = _elm.Bugreport || {};
   if (_elm.Bugreport.values)
   return _elm.Bugreport.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Bugreport",
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Text = Elm.Text.make(_elm);
   var otherText = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Other</h2>\n<p>There are some bugs that I can&#39;t seem to reproduce right now.</p>\n<p>At some point I wrote a formula where the operator precendence did not work (* did not have higher precendence than +), although I am currently unable to reproduce it (I may have simply made a syntax mistake but didn&#39;t notice - unfortunatly, I didn&#39;t save the buggy line of code). The formula involved |toFloat|, negative signs and was used as the argument to the |move| function.)</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "234:13");
   var relativeClick = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Feature request</h2>\n<p>There doesn&#39;t seem to be a way to give the position of a mouse click relative to a particular Form/Element. That would be very very very useful.</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "225:17");
   var scalingAxis = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Feature request</h2>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">Graphics.collage.scale</code></pre>\n<p>takes one scale parameter and scales both axes. It would be nice to have a scale function that can scale two axes independently. Currently, I didn&#39;t find any way to mirror an image (scale x by -1).</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "214:15");
   var functionSearch = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Feature request</h2>\n<p>It would be nice to be able to search the docs by function type, with some tolerance for Int -&gt; Int -&gt; Int vs (Int -&gt; Int) -&gt; Int.</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "205:18");
   var directorySearch = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Feature request</h2>\n<p>The search function of the library doc searches in the current subdirectory. It would be better if it searches the parent.</p>\n<p>For example, I search for &quot;Color&quot; and navigate to Catalog/Elm/Color. Then I want to search for &quot;Signal&quot;, but I have to navigate back first, which keeps tripping me up.</p>\n<p>The ideal solution would be to have the search bar generates two sets of results : one for the subdirectory search, and one global search (or perhaps multiple sets of results for each level of directory up).</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "192:19");
   var fuzzySearch = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Feature request</h2>\n<p>The library docs could use fuzzy search.</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "182:15");
   var mouseClicks = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Could use more docs</h2>\n<p>The examples on the website show how to use the mouse given a continuous signal (e.g. Mouse.position), which are easy to understand. On the other hand, it would not be obvious to a programmer coming from an OO background and used to callback how to &quot;make something happen&quot; upon a mouse click. The <a href=\"http://elm-lang.org/edit/examples/Reactive/CountClicks.elm\">clicks example</a> uses a function that&#39;s too high level to understand how it works (I imagine it&#39;s implemented as a foldp) and the <a href=\"http://elm-lang.org/edit/examples/Intermediate/Slide.elm\">slide example</a> is too complicated as it mixes signals.</p>\n<p>I can imagine a web dev trying to make a custom button as their first project, and getting frustrated because they can&#39;t figure out how to make something, in their terms, &quot;as simple as a button&quot;.</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "170:15");
   var multipleSignals = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Suggestion</h2>\n<p>Right now, it&#39;s not particularly obvious from the basic and intermediate examples how to write programs in Elm with a lot of input signals (I&#39;m ignoring the advanced examples for now - most people won&#39;t dig through a large codebase to figure out how to do these things).</p>\n<p>Examples such as <a href=\"http://elm-lang.org/edit/examples/Intermediate/Slide.elm\">slide</a> seem to suggest that the way to go is to merge multiple signals (wrap them in a ADT if needed) and have a main &quot;Update&quot; or &quot;Step&quot; function that selects what to do using pattern matching.</p>\n<p>I think most people with an OOP background will have the reaction &quot;wtf, this is terrible engineering&quot;. The reaction may or may not be warranted, but not particularly surprising.</p>\n<p>Is there a better way to do it? If so, how could this be communicated better? If not, what are possible changes that could be made to the language or its libraries?</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "153:19");
   var processing = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Suggestion</h2>\n<p>Right now, the list of available Elm examples consist of a lot of drawing and animation (as opposted to a lot of UI such as buttons, tabs, sliders, etc). This gave me the impression that Elm is being developed to address the same use case as Processing addresses - easy tool for making &quot;sketches&quot;. Is this intentional and if so, any thoughts on how to try to steal Processing&#39;s user base?</p>\n<p><a href=\"http://www.processing.org/\">http://www.processing.org/</a></p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "141:14");
   var recordUpdate = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Suggestion</h2>\n<p>Updating records is apprently possible only if we update the record directly. For example,</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">point = { x = 1, y = 2 }\nstartingLocation = { me = point, enemy = point }\nmyPos = startingLocation.me\n\n-- works\nmyNextLocation = { myPos | x &lt;- 2 }\n\n-- fails\nmyNextLocationFail = { startingLocation.me | x &lt;- 2 }</code></pre>\n<p>This seems like it should work. The workaround is to assign startingLocation.me to a temporary symbol (e.g. let binding) but that is less than ideal.</p>\n<p>Since the { record | field &lt;- value } syntax returns new structs and doesn&#39;t mutate anything, there should be any confusion that the failing example returns a point, not a record with two fields which are points right?</p>\n<p>As an aside, while I haven&#39;t run into a situation where I needed this yet, it may be nice to have some syntactic sugar such as</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">bothUpdated = { startingLocation | me.x &lt;- 2, enemy.x &lt;- 2 }</code></pre>\n<p>which would be equivalent to</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">bothUpdated = { startingLocation |\n                    me &lt;- { startingLocation.me | x &lt;- 2 |}\n                    enemy &lt;- { startingLocation.enemy | x &lt;- 2} }</code></pre>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "109:16");
   var floatConversion = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Suggestion</h2>\n<p>The following :</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">x : Int\nx = 2\ny : Float\ny = 2.0\nz = x * y\n\n\nx = 4 * 2.0</code></pre>\n<p>gives</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">Type error on line 24, column 5 to 10:\n       x * y\n\n  Expected Type: Int\n  Actual Type: Float</code></pre>\n<p>Which follows the semantics of the language. However, it is also very annoying. Integer values (e.g. length of a grid) are naturally written without a trailing .0 and many Elm library utilities return Ints (e.g. mouse position), but eventually need to become Floats (e.g. as coordinates of a Form inside a Collage). toFloat is very heavyweight (not only is it 7 characters, it requires parentheses, often). This conversion happens often and I don&#39;t think the type safety benefits it provides outweights the verbosity it brings, especially for people not used to strongly typed languages (most web devs).</p>\n<p>Another argument for implicit conversion : I can write</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">rgbSum = (245 + 121 + 0) / 3.0</code></pre>\n<p>because those intengers are actually of type &#39;number&#39;, but not</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">{red, blue, green, alpha} = toRgb orange\nbrightnessOfOrange = (red + blue + green) / 3.0</code></pre>\n<p>Which is better, because it is self-documenting (less magic numbers). It&#39;s a contrived example, but situations where we have an Int instead of a &#39;number&#39; and we need to multiply with a Float aren&#39;t hard to imagine. I just found during the hackathon that I kept having to write toFloat when it really didn&#39;t feel necessary, and made my lines exceed 80 char.</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "71:19");
   var commentSymbol = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Bug</h2>\n<p>In the code below, the characters --|&gt;</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">x = 1\n    --|&gt; somefunction</code></pre>\n<p>are registered by the parser as a variable rather than a comment. This does not seem to happen if --|&gt; is not indented. This situation might happen if I have some code with a lot of |&gt; pipes, and I use the text editor&#39;s block comment feature to comment lines.</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "56:17");
   var duplicate = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Bug</h2>\n<p>The following code</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">sum x x = x + x\nmySum = sum 1 2</code></pre>\n<p>Generates the error</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">Uncaught SyntaxError: Strict mode function may not have duplicate parameter names</code></pre>\n<p>Which is good, except that the error message appears only in the console. Instead, the webpage only shows</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">Cannot read property &#39;make&#39; of undefined\n    Open the developer console for more details.</code></pre>\n<p>Which makes debugging really confusing. I had something similar occur when trying to access a field of a record, but having a typo in the field although I can&#39;t seem to reproduce it.</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "35:13");
   var funToUse = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Nice!</h2>\n<p>Overall, Elm is fun to use - making a game editor with Elm was an enjoyable experience. Good job!</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "27:12");
   var pipeForward = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Nice!</h2>\n<p>THANK YOU for introducing F#&#39;s pipe-forward |&gt; operator (and friends), best thing ever (loved it when using Rx.net with F#).</p>\n<p>On a related note, the <a href=\"http://fsharpforfunandprofit.com/posts/recipe-part2/\">following tutorial</a> is in F#, but it is personally one of my favorite tutorials of all times. I recommend linking to it for beginner Elm programmers too.</p>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "17:15");
   var suggestions = $Text.markdown("<div style=\"height:0;width:0;\">&nbsp;</div><h2>Nice!</h2>\n<p>I like how</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">main = asText z</code></pre>\n<p>gives me a list of suggestions</p>\n<pre class=\"sourceCode\"><code class=\"sourceCode\">Could not find variable &#39;z&#39;.\nClose matches include: size, sizeOf, unzip, zip, zip3, zip4, zip5, zipWith, zipWith3, zipWith4, zipWith5</code></pre>\n<div style=\"height:0;width:0;\">&nbsp;</div>",
   "3:15");
   var main = A3($List.foldr,
   $Graphics$Element.above,
   $Graphics$Element.empty,
   _L.fromArray([$Text.asText("(I might work on some of the stuff below if I have time. Fyi, to give a bit of context, my personal background is that I know Racket, F#, Reactive Extensions, but not Haskell, almost no web development experience but plenty of native UI experience. Finally, as you might guess, some of my suggestions might be just that I don\'t get Elm - I\'ll leave it to the reader\'s discretion.)")
                ,suggestions
                ,pipeForward
                ,funToUse
                ,duplicate
                ,commentSymbol
                ,recordUpdate
                ,processing
                ,multipleSignals
                ,floatConversion
                ,mouseClicks
                ,fuzzySearch
                ,directorySearch
                ,functionSearch
                ,scalingAxis
                ,relativeClick
                ,otherText]));
   _elm.Bugreport.values = {_op: _op
                           ,suggestions: suggestions
                           ,pipeForward: pipeForward
                           ,funToUse: funToUse
                           ,duplicate: duplicate
                           ,commentSymbol: commentSymbol
                           ,floatConversion: floatConversion
                           ,recordUpdate: recordUpdate
                           ,processing: processing
                           ,multipleSignals: multipleSignals
                           ,mouseClicks: mouseClicks
                           ,fuzzySearch: fuzzySearch
                           ,directorySearch: directorySearch
                           ,functionSearch: functionSearch
                           ,scalingAxis: scalingAxis
                           ,relativeClick: relativeClick
                           ,otherText: otherText
                           ,main: main};
   return _elm.Bugreport.values;
};