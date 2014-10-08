module Bugreport where

suggestions = [markdown|
Nice!
-----

I like how

    main = asText z

gives me a list of suggestions

    Could not find variable 'z'.
    Close matches include: size, sizeOf, unzip, zip, zip3, zip4, zip5, zipWith, zipWith3, zipWith4, zipWith5
|]

pipeForward = [markdown|
Nice!
-----

THANK YOU for introducing F#'s pipe-forward |> operator (and friends), best thing ever (loved it when using Rx.net with F#).

On a related note, the [following tutorial](http://fsharpforfunandprofit.com/posts/recipe-part2/) is in F#, but it is personally one of my favorite tutorials of all times and was helpful in understanding Elm. I recommend linking to it for beginner Elm programmers too.

|]

funToUse = [markdown|
Nice!
-----

Overall, Elm is fun to use - making a game editor with Elm was an enjoyable experience. Good job!

|]

duplicate = [markdown|
Bug
---

The following code

    sum x x = x + x
    mySum = sum 1 2

Generates the error

    Uncaught SyntaxError: Strict mode function may not have duplicate parameter names

Which is good, except that the error message appears only in the console. Instead, the webpage only shows

    Cannot read property 'make' of undefined
        Open the developer console for more details.

Which makes debugging really confusing. I had something similar occur when trying to access a field of a record, but having a typo in the field although I can't seem to reproduce it.
|]

commentSymbol = [markdown|

Bug
---

In the code below, the characters --|>

    x = 1
        --|> somefunction

are registered by the parser as a variable rather than a comment. This does not seem to happen if --|> is not indented. This situation might happen if I have some code with a lot of |> pipes, and I use the text editor's block comment feature to comment lines.

|]


floatConversion = [markdown|
Suggestion
----------

The following :

    x : Int
    x = 2
    y : Float
    y = 2.0
    z = x * y


    x = 4 * 2.0

gives

    Type error on line 24, column 5 to 10:
           x * y

      Expected Type: Int
      Actual Type: Float

Which follows the semantics of the language. However, it is also very annoying. Integer values (e.g. length of a grid) are naturally written without a trailing .0 and many Elm library utilities return Ints (e.g. mouse position), but eventually need to become Floats (e.g. as coordinates of a Form inside a Collage). toFloat is very heavyweight (not only is it 7 characters, it requires parentheses, often). This conversion happens often and I don't think the type safety benefits it provides outweights the verbosity it brings, especially for people not used to strongly typed languages (most web devs).

Another argument for implicit conversion : I can write

    rgbSum = (245 + 121 + 0) / 3.0

because those intengers are actually of type 'number', but not

    {red, blue, green, alpha} = toRgb orange
    brightnessOfOrange = (red + blue + green) / 3.0

Which is better, because it is self-documenting (less magic numbers). It's a contrived example, but situations where we have an Int instead of a 'number' and we need to multiply with a Float aren't hard to imagine. I just found during the hackathon that I kept having to write toFloat when it really didn't feel necessary, and made my lines exceed 80 char.

|]

recordUpdate = [markdown|
Suggestion
----------

Updating records is apprently possible only if we update the record directly. For example,

    point = { x = 1, y = 2 }
    startingLocation = { me = point, enemy = point }
    myPos = startingLocation.me

    -- works
    myNextLocation = { myPos | x <- 2 }

    -- fails
    myNextLocationFail = { startingLocation.me | x <- 2 }

This seems like it should work. The workaround is to assign startingLocation.me to a temporary symbol (e.g. let binding) but that is less than ideal.

Since the { record | field <- value } syntax returns new structs and doesn't mutate anything, there should be any confusion that the failing example returns a point, not a record with two fields which are points right?

As an aside, while I haven't run into a situation where I needed this yet, it may be nice to have some syntactic sugar such as

    bothUpdated = { startingLocation | me.x <- 2, enemy.x <- 2 }

which would be equivalent to

    bothUpdated = { startingLocation |
                        me <- { startingLocation.me | x <- 2 |}
                        enemy <- { startingLocation.enemy | x <- 2} }

|]

processing = [markdown|

Suggestion
----------

Right now, the list of available Elm examples consist of a lot of drawing and animation (as opposted to a lot of UI such as buttons, tabs, sliders, etc). This gave me the impression that Elm is being developed to address the same use case as Processing addresses - easy tool for making "sketches". Is this intentional and if so, any thoughts on how to try to steal Processing's user base?

http://www.processing.org/

|]


multipleSignals = [markdown|

Suggestion
----------

Right now, it's not particularly obvious from the basic and intermediate examples how to write programs in Elm with a lot of input signals (I'm ignoring the advanced examples for now - most people won't dig through a large codebase to figure out how to do these things).

Examples such as [slide](http://elm-lang.org/edit/examples/Intermediate/Slide.elm) seem to suggest that the way to go is to merge multiple signals (wrap them in a ADT if needed) and have a main "Update" or "Step" function that selects what to do using pattern matching.

I think most people with an OOP background will have the reaction "wtf, this is terrible engineering". The reaction may or may not be warranted, but not particularly surprising.

Is there a better way to do it? If so, how could this be communicated better? If not, what are possible changes that could be made to the language or its libraries?

|]



mouseClicks = [markdown|

Could use more docs
-------------------

The examples on the website show how to use the mouse given a continuous signal (e.g. Mouse.position), which are easy to understand. On the other hand, it would not be obvious to a programmer coming from an OO background and used to callback how to "make something happen" upon a mouse click. The [clicks example](http://elm-lang.org/edit/examples/Reactive/CountClicks.elm) uses a function that's too high level to understand how it works (I imagine it's implemented as a foldp) and the [slide example](http://elm-lang.org/edit/examples/Intermediate/Slide.elm) is too complicated as it mixes signals.

I can imagine a web dev trying to make a custom button as their first project, and getting frustrated because they can't figure out how to make something, in their terms, "as simple as a button".

|]


fuzzySearch = [markdown|

Feature request
---------------

The library docs could use fuzzy search.

|]


directorySearch = [markdown|

Feature request
---------------

The search function of the library doc searches in the current subdirectory. It would be better if it searches the parent.

For example, I search for "Color" and navigate to Catalog/Elm/Color. Then I want to search for "Signal", but I have to navigate back first, which keeps tripping me up.

The ideal solution would be to have the search bar generates two sets of results : one for the subdirectory search, and one global search (or perhaps multiple sets of results for each level of directory up).

|]

functionSearch = [markdown|

Feature request
---------------

It would be nice to be able to search the docs by function type, with some tolerance for Int -> Int -> Int vs (Int -> Int) -> Int.

|]

scalingAxis = [markdown|

Feature request
---------------

    Graphics.collage.scale

takes one scale parameter and scales both axes. It would be nice to have a scale function that can scale two axes independently. Currently, I didn't find any way to mirror an image (scale x by -1).

|]

relativeClick = [markdown|

Feature request
---------------

There doesn't seem to be a way to give the position of a mouse click relative to a particular Form/Element. That would be very very very useful.

|]

otherText = [markdown|

Other
-----

There are some bugs that I can't seem to reproduce right now.

At some point I wrote a formula where the operator precendence did not work (* did not have higher precendence than +), although I am currently unable to reproduce it (I may have simply made a syntax mistake but didn't notice - unfortunatly, I didn't save the buggy line of code). The formula involved |toFloat|, negative signs and was used as the argument to the |move| function.)
|]

main = foldr above empty
             [asText """(I might work on some of the stuff below if I have time. Fyi, to give a bit of context, my personal background is that I know Racket, F#, Reactive Extensions, but not Haskell, almost no web development experience but plenty of native UI experience. Finally, as you might guess, some of my suggestions might be just that I don't get Elm - I'll leave it to the reader's discretion.)""",
              suggestions,
              pipeForward,
              funToUse,
              duplicate,
              commentSymbol,
              recordUpdate,
              processing,
              multipleSignals,
              floatConversion,
              mouseClicks,
              fuzzySearch,
              directorySearch,
              functionSearch,
              scalingAxis,
              relativeClick,
              otherText]