:Namespace BusinessLogic

⍝ Globals used in this namespace
⍝   OrderFile - Order file tie number
⍝   Menu - JSON structured menu
⍝   FoodItems - matrix of all food items [;1] id [;2] name [;3] cost
⍝   OrderFileDate - date Y M D for the current OrderFile
⍝   DataPath - path to the Data folder where the files are

⍝ Implements the business logic for Brian's Burger Bistro
    ∇ Init
      DataPath←#.Boot.ms.Config.AppRoot,'Data/'
     
      Menu←#.JSON.toAPL #.Files.GetText DataPath,'menu.json'
     
      FoodItems←0 3⍴'' '' 0
      FoodItems⍪←↑⊃,/Menu.burgers.(size bun toppings).(id name cost)
      FoodItems⍪←↑Menu.sides.(id name cost)
      FoodItems⍪←↑Menu.drinks.(id name cost)
     
      OrderFile←OpenOrderFile OrderFileDate←3↑⎕TS
    ∇

    ∇ OrderNo←PlaceOrder order;today;comp;cost
    ⍝ called when a customer places an order
      :Hold 'OrderUpdate'
          :If OrderFileDate≢today←3↑⎕TS ⍝ new day?
              ⎕FUNTIE OrderFile
              OrderFile←OpenOrderFile OrderFileDate←today
          :EndIf
          comp←order ⎕FAPPEND OrderFile
          cost←+/(⊃⍪/order)[;3]
          OrderNo←0 UpdateOrder comp,cost
      :EndHold
    ∇

    ∇ OrderNo←StartOrder orderno
    ⍝ called when the kitchen starts to cook an order
      :Hold 'OrderUpdate'
          OrderNo←1 UpdateOrder orderno
      :EndHold
    ∇

    ∇ OrderNo←CompleteOrder orderno
    ⍝ called when the kitchen starts to cook an order
      :Hold 'OrderUpdate'
          OrderNo←2 UpdateOrder orderno
      :EndHold
    ∇

    ∇ r←OpenOrderFile date
    ⍝ open (and optionally initialize) the order file for a date
      r←(DataPath,'Orders',⍕100⊥date)#.Files.Fopen 0
      ⎕FHOLD r
      :If =/2↑⎕FSIZE r ⍝ new file?
          (↑'1 - This description' '2 - order status matrix ' '3-5 - Reserved' '6+ Orders (one order per component)')⎕FAPPEND r
          (5 5⍴¯1)⎕FAPPEND r ⍝ initialize the order list (row index = component# = order#
          (3⍴⊂'')⎕FAPPEND¨r ⍝ pad out reserved components
      :EndIf
      ⎕FHOLD ⍬
    ∇

    ∇ r←action UpdateOrder OrderNo;orders;cost
    ⍝ action is 0 - place order, 1 - take order, 2 - complete order
    ⍝ OrderNo is the order number (component number in OrderFile)
      ⎕FHOLD OrderFile
      (OrderNo cost)←2↑OrderNo
      orders←⎕FREAD OrderFile,2
      orders←(OrderNo⌈⍬⍴⍴orders)↑orders
      orders[OrderNo;1,2+action]←action ⎕TS
      orders[OrderNo;5]←cost
      orders ⎕FREPLACE OrderFile,2
      r←OrderNo
      ⎕FHOLD ⍬
    ∇

    ∇ r←FormatOrder order;item;size;t;bun;toppings;inds;sidesDrinks;mask
      r←0 3⍴0 '' 0
      :For item :In order
          :If ∨/size←item[;1]∊Menu.burgers.size.id
              t←⊃size/item[;2]
              t,←' on ',⊃(bun←item[;1]∊Menu.burgers.bun.id)/item[;2]
              :If ∨/toppings←item[;1]∊Menu.burgers.toppings.id
                  t,←' with',1↓∊', '∘,¨toppings/item[;2]
              :EndIf
              r⍪←1 t(item[;3]+.×⊃∨/size bun toppings)
          :EndIf
      :EndFor
      order←⊃⍪/order
      inds←(sidesDrinks←⊃,/Menu.(sides drinks).id)⍳order[;1]
      :If ∨/mask←inds≤⍴sidesDrinks
          r⍪←1⌽{(⍺[3]1×⍬⍴⍴⍵),(⍺[2])}⌸(mask⌿order)[⍋mask/inds;]
      :EndIf
    ∇


    ∇ r←formatQueues
      orders←⎕FREAD OrderFile,2
    ∇

    ∇ r←GetOrdersData date;tn
      tn←OpenOrderFile date
      r←5↓⎕FREAD tn,2
      r,←#.Dates.DateToIDN¨r[;2 3 4]                             ⍝ convert timestamps to IDNs
      r,←⌽⌈0.001×0 60 60 1000∘⊥¨3↓¨#.Dates.IDNToDate¨2-/r[;8 7 6] ⍝ append differences (in seconds) ordered→taken→completed
      ⎕FUNTIE tn
    ∇

    ∇ r←buckets bucket data
      r←1⌈+/data∘.≥buckets
    ∇

    ∇ r←TwentyMinuteProfile data;steps;timeslots;profile
      steps←1|#.Dates.DateToIDN¨2016 4 1∘,¨,(9+⍳13)∘.,0 20 40
      timeslots←steps bucket 1|data[;6]
      r←{⍺((≢⍵),(+/data[⍵;5]),(5+⊂⍵))}⌸timeslots ⍝ [;1]timeslot [;2]#orders [;3]$total [;4]order numbers
    ∇
:EndNamespace