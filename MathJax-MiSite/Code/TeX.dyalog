:Class TeX : #._html.script
    :Field public inline←¯1
    :Field public displayed←¯1

    ∇ Make0
      :Access public
      :Implements constructor
    ∇

    ∇ Make1 params
      :Access public
      :Implements constructor :base params
    ∇

    ∇ r←Render
      :Access public
      :If UNDEF≡type
          type←'math/tex'
          :If (inline=0)∨displayed=1
              type,←'; mode=display'
          :EndIf
      :EndIf
      r←⎕BASE.Render
    ∇

:EndClass
