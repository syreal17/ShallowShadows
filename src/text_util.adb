package body text_util is

   function Is_MultiChar_Word_Beginning(Previous, Current, Next : Character) return Boolean
   is
   begin
      return Is_Space(Previous) and Is_Alphanumeric(Current) and Is_Alphanumeric(Next);
   end Is_MultiChar_Word_Beginning;
   
   function Is_MultiChar_Word_Middle(Previous, Current, Next : Character) return Boolean
   is
   begin
      return Is_Alphanumeric(Previous) and Is_Alphanumeric(Current) and Is_Alphanumeric(Next);
   end Is_MultiChar_Word_Middle;

end text_util;
