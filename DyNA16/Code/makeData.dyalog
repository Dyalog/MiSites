 makeData date;tn;i;hourdist;hours;slot;order;burgers;buns;drinks;sides;mintime;j;toppings;which;howmanysides;mask;k;slots;n;howmanydrinks;Order;Orders;minutes;seconds;milliseconds;numOrders;burgerorders;starts;takes;completes;l;cost
 hourdist←3 7 13 9 8 4 8 12 17 10 5 3 1
 hours←10 11 12 13 14 15 16 17 18 19 20 21 22
 burgers←50 30 20
 buns←35 30 25 10
 drinks←20 40 40
 sides←35 20 25 20
 howmanysides←50 30 10 5
 howmanydrinks←60 30 5
 toppings←25 35 30 75 60 10 15 40 15
 which←{⍵≥?(≢⍵)⍴100}
 slot←{(+\0,¯1↓⍵)+.<?+/⍵}
 Orders←⍬
 n←200+?100
 burgerorders←n⍴0
 cost←n⍴0
 :For i :In ⍳n
     mintime←0
     Order←⍬
     :For j :In ⍳slot 50 20 20 10 20  ⍝ how many suborders?
         order←0 3⍴'' '' 0
         :If 60≥?100 ⍝ order a burger?
             burgerorders[i]←1
             order⍪←#.BusinessLogic.Menu.burgers.size[slot burgers].(id name cost)
             order⍪←#.BusinessLogic.Menu.burgers.bun[slot buns].(id name cost)
             order⍪←↑(which toppings)/#.BusinessLogic.Menu.burgers.toppings.(id name cost)
             :If 70≥?100 ⍝ if they order a burger, they're 70% likely to order a side
                 slots←sides
                 :For k :In ⍳slot howmanysides
                     order⍪←#.BusinessLogic.Menu.sides[l←slot slots].(id name cost)
                     slots[l]←0
                 :EndFor
             :EndIf
         :ElseIf 50≥?100 ⍝ if no burger, they're 50% likely to order a side
             slots←sides
             :For k :In ⍳slot howmanysides
                 order⍪←#.BusinessLogic.Menu.sides[l←slot slots].(id name cost)
                 slots[l]←0
             :EndFor
         :EndIf
         slots←drinks
         :For k :In ⍳slot howmanydrinks
             order⍪←#.BusinessLogic.Menu.drinks[l←slot slots].(id name cost)
             slots[l]←0
         :EndFor
         cost[i]+←+/order[;3]
         Order,←⊂order
     :EndFor
     Orders,←⊂Order
 :EndFor
 hours←hours[slot¨n⍴⊂hourdist]
 minutes←?n⍴60
 seconds←?n⍴60
 milliseconds←?n⍴1000
 starts←0 60 60 1000⊥⍉hours,minutes,seconds,⍪milliseconds
 starts←starts[⍋starts]
 takes←starts+1000×?n⍴120
 completes←takes+(burgerorders×180000)+120000+n?120000
 (starts takes completes)←{↓(n 3⍴date),⍉0 60 60 1000⊤⍵}¨starts takes completes
 {⎕FDROP ⍵,-/2↑⎕FSIZE ⍵}#.BusinessLogic.OpenOrderFile date
 tn←#.BusinessLogic.OpenOrderFile date
 ((5 5⍴¯1)⍪2,starts,takes,completes,⍪cost)⎕FREPLACE tn,2
 Orders ⎕FAPPEND¨tn
 ⎕FUNTIE tn