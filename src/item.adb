package body item is
begin
   for Y in Item_Layer'Range(1) loop
      for X in Item_Layer'Range(2) loop
         Item_Layer(Y,X) := No_Item_Concrete;
      end loop;
   end loop;
end item;
