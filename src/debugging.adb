package body debugging with SPARK_Mode => Off
is

--Print_Char_Codes: S: the string to print char codes. Prints numeric representation for each cahracter
   --                  for an entire string.
   procedure Print_Char_Codes ( S : String ) is
   begin
      for C of S loop
         Put( Integer'Image(Character'Pos(C)) & " ");
         --Put(C);
      end loop;
      Put_Line("");
   end;
   
end debugging;
