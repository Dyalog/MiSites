:Namespace BusinessLogic
⍝ Implements the business logic for Brian's Burger Bistro
    ∇ Init
      Menu←#.JSON.toAPL #.Files.GetText #.Boot.ms.Config.AppRoot,'Data/menu.json'
      FoodItems←0 3⍴'' '' 0
      FoodItems⍪←↑⊃,/Menu.burgers.(size buns toppings).(id name cost)
      FoodItems⍪←↑Menu.sides.(id name cost)
      FoodItems⍪←↑Menu.drinks.(id name cost)
    ∇
:EndNamespace