:Class bbb : MiServer
 
    ∇ make arg
      :Access public
      :Implements constructor :base arg
    ∇

    ∇ onServerStart
      :Access public override
      #.BusinessLogic.Init
    ∇

:EndClass