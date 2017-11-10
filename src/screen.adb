package body screen is

   --TODO: implement for ease of adding messages to the game for actions or triggers or whatever
   procedure Enqueue_Message(Screen : in out Screen_Type; TM : Text_Message_type)
   is
   begin
      Text_Message_Queue_Pkg.Prepend(Screen.Text_Message_Queue, TM);
   end Enqueue_Message;
   
end screen;
