:Namespace bl ⍝ Business Logic

    ∇ Init
    ⍝ Initialize the "database"
    ⍝ Customers table [;1] id [;2] name
      Customers←{(100×⍳⍴⍵),⍪⍵}'Adam' 'Brian' 'Charles' 'Daniel' 'Edmund' 'Frank' 'George' 'Harry' 'Isaac' 'John' 'Kevin' 'Larry' 'Morten'
    ⍝ Products table [;1] id [;2] name
      Products←{(10×⍳⍴⍵),⍪⍵}'Apple' 'Ball' 'Cart' 'Donut' 'Eggplant' 'Farkle' 'Genie' 'Hula Hoop'
    ⍝ Orders table [;1] order number [;2] customer id [;3] date
      Orders←{(⍳⍵),Customers[?⍵⍴⍴Customers;1],⍪{3↑2 ⎕NQ'.' 'IDNToDate'⍵}¨(2 ⎕NQ'.' 'DateToIDN'⎕TS)-{(⊂⍒⍵)⌷⍵}?⍵⍴30}15
    ⍝ Order Details table [;1] order number [;2] product id [;3] qty
      Details←{⍵,?(⊃⍴⍵)⍴10}⊃⍪/Orders[;1],[1.1]¨10×(?(⊃⍴Orders)⍴4)?¨⊃⍴Products
      LastCustomerNumber←⌈/Customers[;1]
    ∇

    lookup←{⍺{(⍵/⍳⍴⍵),⍵⌿⍺}⍺[;⍺⍺]∊#.Strings.tonum ⍵} ⍝ return [;1] row index [;2...] table data
    getCustomer←{Customers (1 lookup) ⍵}
    getOrder←{Orders(1 lookup) ⍵}
    getCustomerOrders←{Orders(2 lookup)⍵}
    getProduct←{Products (1 lookup) ⍵}
    getOrderDetails←{({⍵,0 2↓⍵[;3]{⍵[⍵[;2]⍳⍺;]}getProduct ⍵[;3]}Details (1 lookup) ⍵)[;2 4 3 5]}
    getOrderProducts←{{⍵,0 1↓getProducts ⍵[;3]}getOrderDetails ⍵}
      remove←{a←⍺
          a⌿⍨~a[;⍺⍺]∊⍵}
      getCustomerOrder←{
          0∊⍴d←getOrderDetails ⍵:⍬
          ~(#.Strings.tonum ⍺)∊(o←getOrder ⍵)[;3]:⍬
          0 1∘↓¨o d
      }


    ∇ r←AddCustomer name;order;id
      :Hold 'bl'
          LastCustomerNumber←id←100+LastCustomerNumber
          r←Customers⍪←id name
      :EndHold
    ∇

    ∇ r←GetCustomer custid;cust
      :If 0∊⍴custid ⋄ r←Customers
      :Else ⋄ r←0 1↓cust←getCustomer custid
      :EndIf
    ∇

    ∇ r←id UpdateCustomer name;cust
      r←⍬
      :Hold 'bl'
          :If ~0∊⍴cust←getCustomer id
              Customers[⊃cust;2]←⊂name
              r←1↓,getCustomer id
          :EndIf
      :EndHold
    ∇

    ∇ r←DeleteCustomer id;cust;orders;details
      r←⍬
      :Hold 'bl'
          :If ~0∊⍴cust←1↓,getCustomer id
              orders←details←⍬
              Customers←Customers(1 remove)cust[1]
              :If ~0∊⍴orders←0 1↓getCustomerOrders cust[1]
                  Orders←Orders(1 remove)orders[;1]
                  :If ~0∊⍴details←getOrderDetails orders[;1]
                      Details←Details(1 remove)details[;1]
                  :EndIf
              :EndIf
              r←cust orders details
          :EndIf
      :EndHold
    ∇

    ∇ r←GetCustomerOrders custid
      r←0 1↓getCustomerOrders custid
    ∇

    ∇ r←Show
      r←(⍪'Customers'('id' 'name'⍪Customers))(⍪'Orders'('id' 'custid' 'date'⍪Orders))(⍪'Details'('order' 'product' 'qty'⍪Details))(⍪'Products'('id' 'name'⍪Products))
    ∇

:EndNamespace