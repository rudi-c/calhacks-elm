Elm.Editor = Elm.Editor || {};
Elm.Editor.make = function (_elm) {
   "use strict";
   _elm.Editor = _elm.Editor || {};
   if (_elm.Editor.values)
   return _elm.Editor.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Editor",
   $Array = Elm.Array.make(_elm),
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $CommonDisplay = Elm.CommonDisplay.make(_elm),
   $Constants = Elm.Constants.make(_elm),
   $Dict = Elm.Dict.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $Graphics$Input = Elm.Graphics.Input.make(_elm),
   $List = Elm.List.make(_elm),
   $Model = Elm.Model.make(_elm);
   var borderRectElement = F4(function (w,
   h,
   color,
   thickness) {
      return function () {
         var thinLine = $Graphics$Collage.solid(color);
         var thickLine = _U.replace([["width"
                                     ,thickness]],
         thinLine);
         return A3($Graphics$Collage.collage,
         w,
         h,
         _L.fromArray([A2($Graphics$Collage.outlined,
         thickLine,
         A2($Graphics$Collage.rect,
         $Basics.toFloat(w),
         $Basics.toFloat(h)))]));
      }();
   });
   var wrapBox = F2(function (size,
   elem) {
      return A2($Graphics$Element.flow,
      $Graphics$Element.outward,
      _L.fromArray([A4($Graphics$Element.container,
                   size,
                   size,
                   $Graphics$Element.topLeft,
                   elem)
                   ,A4(borderRectElement,
                   size,
                   size,
                   $Color.black,
                   8.0)
                   ,A4(borderRectElement,
                   size,
                   size,
                   $Color.white,
                   6.0)
                   ,A4(borderRectElement,
                   size,
                   size,
                   $Color.black,
                   2.0)]));
   });
   var brushesList = function (selectedBrush) {
      return $List.map(function (_v0) {
         return function () {
            switch (_v0.ctor)
            {case "_Tuple2":
               return A2($Graphics$Input.clickable,
                 $Model.brushChooser.handle,
                 _v0._0)(_U.eq(selectedBrush,
                 _v0._0) ? A2(wrapBox,
                 $Constants.tileSize,
                 A3($Graphics$Element.image,
                 $Constants.tileSize,
                 $Constants.tileSize,
                 _v0._1)) : A3($Graphics$Element.image,
                 $Constants.tileSize,
                 $Constants.tileSize,
                 _v0._1));}
            _E.Case($moduleName,
            "between lines 65 and 69");
         }();
      })($Dict.toList($Constants.graphicsTiles));
   };
   var renderBrushes = function (editor) {
      return A2($Graphics$Element.flow,
      $Graphics$Element.right,
      brushesList(editor.selectedBrush));
   };
   var renderEditorView = function (editor) {
      return A3($List.foldr,
      $Graphics$Element.below,
      $Graphics$Element.empty,
      _L.fromArray([A3($Graphics$Input.button,
                   $Model.buttonClick.handle,
                   $Model.GoToGame,
                   "Go To Game")
                   ,A2($Graphics$Element.spacer,
                   30,
                   30)
                   ,renderBrushes(editor)
                   ,A2($Graphics$Element.spacer,
                   50,
                   50)
                   ,$CommonDisplay.renderFromForms($CommonDisplay.tilesForWorld(editor.world))]));
   };
   var brushClick = F2(function (editor,
   brushId) {
      return _U.replace([["selectedBrush"
                         ,brushId]],
      editor);
   });
   var stepAnyClick = F2(function (editor,
   _v4) {
      return function () {
         switch (_v4.ctor)
         {case "_Tuple2":
            return function () {
                 var i = A2($Model.toIndex,
                 _v4._0,
                 _v4._1);
                 return $Constants.inGrid({ctor: "_Tuple2"
                                          ,_0: _v4._0
                                          ,_1: _v4._1}) ? function () {
                    var editorWorld = editor.world;
                    var newLevel = A3($Array.set,
                    i,
                    editor.selectedBrush,
                    editor.world.level1);
                    var newWorld = _U.replace([["level1"
                                               ,newLevel]],
                    editorWorld);
                    return _U.replace([["world"
                                       ,newWorld]],
                    editor);
                 }() : editor;
              }();}
         _E.Case($moduleName,
         "between lines 23 and 30");
      }();
   });
   var stepEditor = F2(function (input,
   editor) {
      return function () {
         switch (input.ctor)
         {case "BrushClick":
            return A2(brushClick,
              editor,
              input._0);
            case "HitTile":
            switch (input._0.ctor)
              {case "_Tuple2":
                 return A2(stepAnyClick,
                   editor,
                   $Constants.hoveredTile({ctor: "_Tuple2"
                                          ,_0: input._0._0
                                          ,_1: input._0._1}));}
              break;}
         return editor;
      }();
   });
   _elm.Editor.values = {_op: _op
                        ,stepAnyClick: stepAnyClick
                        ,brushClick: brushClick
                        ,stepEditor: stepEditor
                        ,borderRectElement: borderRectElement
                        ,wrapBox: wrapBox
                        ,brushesList: brushesList
                        ,renderBrushes: renderBrushes
                        ,renderEditorView: renderEditorView};
   return _elm.Editor.values;
};Elm.CommonDisplay = Elm.CommonDisplay || {};
Elm.CommonDisplay.make = function (_elm) {
   "use strict";
   _elm.CommonDisplay = _elm.CommonDisplay || {};
   if (_elm.CommonDisplay.values)
   return _elm.CommonDisplay.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "CommonDisplay",
   $Array = Elm.Array.make(_elm),
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Constants = Elm.Constants.make(_elm),
   $Dict = Elm.Dict.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Model = Elm.Model.make(_elm),
   $Utils = Elm.Utils.make(_elm);
   var renderFromForms = function (forms) {
      return A3($Graphics$Collage.collage,
      $Constants.viewSize,
      $Constants.viewSize,
      forms);
   };
   var tile = F2(function (index,
   val) {
      return $Constants.gridOffsetMove($Utils.moveInt({ctor: "_Tuple2"
                                                      ,_0: $Constants.tileSize * $Model.colFromIndex(index)
                                                      ,_1: $Constants.tileSize * $Model.rowFromIndex(index)})($Graphics$Collage.toForm(A3($Graphics$Element.image,
      $Constants.tileSize,
      $Constants.tileSize,
      A2($Dict.getOrFail,
      val,
      $Constants.graphicsTiles)))));
   });
   var tilesForWorld = function (_v0) {
      return function () {
         return _L.append(_L.fromArray([$Graphics$Collage.filled($Color.lightBlue)($Graphics$Collage.square($Basics.toFloat($Constants.viewSize)))]),
         _L.append($Array.toList(A2($Array.indexedMap,
         tile,
         _v0.level1)),
         $Array.toList(A2($Array.indexedMap,
         tile,
         _v0.level2))));
      }();
   };
   _elm.CommonDisplay.values = {_op: _op
                               ,tile: tile
                               ,tilesForWorld: tilesForWorld
                               ,renderFromForms: renderFromForms};
   return _elm.CommonDisplay.values;
};Elm.Model = Elm.Model || {};
Elm.Model.make = function (_elm) {
   "use strict";
   _elm.Model = _elm.Model || {};
   if (_elm.Model.values)
   return _elm.Model.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Model",
   $Array = Elm.Array.make(_elm),
   $Basics = Elm.Basics.make(_elm),
   $Constants = Elm.Constants.make(_elm),
   $Graphics$Input = Elm.Graphics.Input.make(_elm);
   var toIndex = F2(function (x,
   y) {
      return x + y * $Constants.gridSize;
   });
   var rowFromIndex = function (index) {
      return index / $Constants.gridSize | 0;
   };
   var colFromIndex = function (index) {
      return A2($Basics._op["%"],
      index,
      $Constants.gridSize);
   };
   var initialWorld = {_: {}
                      ,level1: A2($Array.initialize,
                      $Constants.gridSize * $Constants.gridSize,
                      $Basics.always(0))
                      ,level2: A2($Array.initialize,
                      $Constants.gridSize * $Constants.gridSize,
                      $Basics.always(0))};
   var State = F3(function (a,
   b,
   c) {
      return {_: {}
             ,editor: a
             ,game: b
             ,playing: c};
   });
   var Game = function (a) {
      return {_: {},alien: a};
   };
   var Alien = F5(function (a,
   b,
   c,
   d,
   e) {
      return {_: {}
             ,dir: a
             ,vx: d
             ,vy: e
             ,x: b
             ,y: c};
   });
   var Editor = F3(function (a,
   b,
   c) {
      return {_: {}
             ,layer: a
             ,selectedBrush: b
             ,world: c};
   });
   var World = F2(function (a,b) {
      return {_: {}
             ,level1: a
             ,level2: b};
   });
   var Right = {ctor: "Right"};
   var initialAlien = {_: {}
                      ,dir: Right
                      ,vx: 0.0
                      ,vy: 0.0
                      ,x: 0.0
                      ,y: $Basics.toFloat($Constants.tileSize)};
   var initialGame = {_: {}
                     ,alien: initialAlien};
   var Left = {ctor: "Left"};
   var Level2 = {ctor: "Level2"};
   var Level1 = {ctor: "Level1"};
   var initialEditor = {_: {}
                       ,layer: Level1
                       ,selectedBrush: 0
                       ,world: initialWorld};
   var initialState = {_: {}
                      ,editor: initialEditor
                      ,game: initialGame
                      ,playing: false};
   var brushChooser = $Graphics$Input.input(0);
   var GameDelta = function (a) {
      return {ctor: "GameDelta"
             ,_0: a};
   };
   var ButtonClick = function (a) {
      return {ctor: "ButtonClick"
             ,_0: a};
   };
   var BrushClick = function (a) {
      return {ctor: "BrushClick"
             ,_0: a};
   };
   var HitTile = function (a) {
      return {ctor: "HitTile"
             ,_0: a};
   };
   var GoToEditor = {ctor: "GoToEditor"};
   var GoToGame = {ctor: "GoToGame"};
   var buttonClick = $Graphics$Input.input(GoToGame);
   _elm.Model.values = {_op: _op
                       ,GoToGame: GoToGame
                       ,GoToEditor: GoToEditor
                       ,buttonClick: buttonClick
                       ,HitTile: HitTile
                       ,BrushClick: BrushClick
                       ,ButtonClick: ButtonClick
                       ,GameDelta: GameDelta
                       ,brushChooser: brushChooser
                       ,Level1: Level1
                       ,Level2: Level2
                       ,Left: Left
                       ,Right: Right
                       ,World: World
                       ,Editor: Editor
                       ,Alien: Alien
                       ,Game: Game
                       ,State: State
                       ,initialWorld: initialWorld
                       ,initialEditor: initialEditor
                       ,initialAlien: initialAlien
                       ,initialGame: initialGame
                       ,initialState: initialState
                       ,colFromIndex: colFromIndex
                       ,rowFromIndex: rowFromIndex
                       ,toIndex: toIndex};
   return _elm.Model.values;
};Elm.Constants = Elm.Constants || {};
Elm.Constants.make = function (_elm) {
   "use strict";
   _elm.Constants = _elm.Constants || {};
   if (_elm.Constants.values)
   return _elm.Constants.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Constants",
   $Basics = Elm.Basics.make(_elm),
   $Dict = Elm.Dict.make(_elm),
   $List = Elm.List.make(_elm),
   $String = Elm.String.make(_elm),
   $Utils = Elm.Utils.make(_elm);
   var graphicsNames = A2($List.map,
   $String.append("graphics/Base pack/Tiles/"),
   _L.fromArray(["empty.png"
                ,"sandCenter.png"
                ,"grassLeft.png"
                ,"grassMid.png"
                ,"grassRight.png"
                ,"box.png"]));
   var graphicsTiles = $Dict.fromList(A2($List.zip,
   _L.range(0,
   $List.length(graphicsNames) - 1),
   graphicsNames));
   var gridSize = 8;
   var inGrid = function (_v0) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return _U.cmp(0,
              _v0._0) < 1 && (_U.cmp(_v0._0,
              gridSize) < 0 && (_U.cmp(0,
              _v0._1) < 1 && _U.cmp(_v0._1,
              gridSize) < 0));}
         _E.Case($moduleName,
         "on line 37, column 17 to 65");
      }();
   };
   var tileSize = 70;
   var viewSize = gridSize * tileSize;
   var gridOffset = ((0 - viewSize) / 2 | 0) + (tileSize / 2 | 0);
   var gridOffsetMove = function (obj) {
      return A2($Utils.moveInt,
      {ctor: "_Tuple2"
      ,_0: gridOffset
      ,_1: gridOffset},
      obj);
   };
   var hoveredTile = function (_v4) {
      return function () {
         switch (_v4.ctor)
         {case "_Tuple2":
            return {ctor: "_Tuple2"
                   ,_0: (_v4._0 - (viewSize / 2 | 0) - gridOffset + (tileSize / 2 | 0)) / tileSize | 0
                   ,_1: ((viewSize / 2 | 0) - _v4._1 - gridOffset + (tileSize / 2 | 0)) / tileSize | 0};}
         _E.Case($moduleName,
         "between lines 33 and 34");
      }();
   };
   _elm.Constants.values = {_op: _op
                           ,tileSize: tileSize
                           ,gridSize: gridSize
                           ,graphicsNames: graphicsNames
                           ,graphicsTiles: graphicsTiles
                           ,viewSize: viewSize
                           ,gridOffset: gridOffset
                           ,gridOffsetMove: gridOffsetMove
                           ,hoveredTile: hoveredTile
                           ,inGrid: inGrid};
   return _elm.Constants.values;
};Elm.Utils = Elm.Utils || {};
Elm.Utils.make = function (_elm) {
   "use strict";
   _elm.Utils = _elm.Utils || {};
   if (_elm.Utils.values)
   return _elm.Utils.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "Utils",
   $Basics = Elm.Basics.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm);
   var moveInt = F2(function (_v0,
   obj) {
      return function () {
         switch (_v0.ctor)
         {case "_Tuple2":
            return A2($Graphics$Collage.move,
              {ctor: "_Tuple2"
              ,_0: $Basics.toFloat(_v0._0)
              ,_1: $Basics.toFloat(_v0._1)},
              obj);}
         _E.Case($moduleName,
         "on line 6, column 22 to 53");
      }();
   });
   _elm.Utils.values = {_op: _op
                       ,moveInt: moveInt};
   return _elm.Utils.values;
};