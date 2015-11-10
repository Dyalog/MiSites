:Class SimpleSampleServer :MiServer

    ∇ make args
      :Access Public
      :Implements Constructor :Base args
    ∇

    ∇ onServerStart
      :Access public override
      ⍝ Create the sample "database"
      #.bl.Init
    ∇
:EndClass