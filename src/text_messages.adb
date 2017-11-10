package body text_messages is

   function Construct_Message(message : String) return Text_Message_Type
   is
      TM : Text_Message_Type;
   begin
      --init TM
      for I in TM.Unprocessed_Message'Range loop
         TM.Unprocessed_Message(I) := NUL;
      end loop;
      
      for I in TM.Processed_Message'Range loop
         TM.Processed_Message(I) := NUL;
      end loop;
      
      TM.Processed_Lines := 0;
      
      --copy string to unprocessed buffer
      for I in message'Range loop
         TM.Unprocessed_Message(I) := message(I);
      end loop;
   
      Process_Message(TM);
      
      return TM;
   end Construct_Message;
   
   function Get_Message(TM : Text_Message_Type) return String
   is
      S : String(1 .. Get_Message_Length(TM));
   begin
      for I in S'Range loop
         S(I) := TM.Processed_Message(I);
      end loop;
      
      return S;
   end Get_Message;
   
   function Get_Message_Length(TM : Text_Message_Type) return Natural
   is
      J : Positive := 1;
   begin
      for I in TM.Processed_Message'Range loop
         if TM.Processed_Message(I) = NUL then
            return J - 1;
         end if;
         
         J := J + 1;
      end loop;
      
      return J - 1;
   end Get_Message_Length;
   
   function Get_Message_Lines(TM : Text_Message_type) return Natural
   is
   begin
      return TM.Processed_Lines;
   end Get_Message_Lines;

   procedure Process_Message(TM : in out Text_Message_Type)
   is
      Counted_Line : Boolean := False;
      J : Positive := 1;
      Previous, Current, Next : Character;
   begin
      --TODO: break into lines by inserrting line feeds, adds hyphens when breaking up a word at the end of a line (need In_Word util), count lines, lastly, put into Processed_Message
      TM.Processed_Lines := 0;
      
      for I in TM.Unprocessed_Message'Range loop
         if TM.Unprocessed_Message(I) = NUL then
            exit;
         end if;
      
         if not Counted_Line then
            TM.Processed_Lines := TM.Processed_Lines + 1;
            Counted_Line := True;
         end if;
         
         if J mod SCREEN_WIDTH_X = SCREEN_WIDTH_X - 1 then
            if I < TM.Unprocessed_Message'Last then
               Previous := TM.Unprocessed_Message(I-1);
               Current := TM.Unprocessed_Message(I);
               Next := TM.Unprocessed_Message(I+1);
                 --check if we're at beginning or middle of word
               if Is_MultiChar_Word_Middle(Previous, Current, Next) then
                  TM.Processed_Message(J) := '-';
                  J := J + 1;
               elsif Is_MultiChar_Word_Beginning(Previous, Current, Next) then
                  TM.Processed_Message(J) := ' ';
                  J := J + 1;
               end if;
            end if;
         end if;
         
         if J mod SCREEN_WIDTH_X = 0 then
            TM.Processed_Message(J) := LF;
            Counted_Line := False;
            J := J + 1;
         end if;
         
         TM.Processed_Message(J) := TM.Unprocessed_Message(I);
         J := J + 1;
      end loop;
   end Process_Message;
    
end text_messages;
