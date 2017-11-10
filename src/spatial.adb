package body spatial is

   function "<" (L, R : Pos_Type) return Boolean is
   begin
      return L.Y < R.Y;
   end "<";
   
end spatial;
