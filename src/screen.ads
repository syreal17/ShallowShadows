with Ada.Containers.Formal_Doubly_Linked_Lists; use Ada.Containers;

with game_constants; use game_constants;
with spatial; use spatial;
with text_messages; use text_messages;

package screen with SPARK_Mode => On is

   package Text_Message_Queue_Pkg is new Ada.Containers.Formal_Doubly_Linked_Lists
      (Element_Type => Text_Message_Type);

   type Screen_Type is
   record
      Pos : Pos_Type;
      Text_Message_Queue : Text_Message_Queue_Pkg.List(MAX_TEXT_MSGS_AT_ONCE); --the entire queue is discharged during every render_dungeon.
   end record;
   
   Text_Message_Queue_Instance : Text_Message_Queue_Pkg.List(MAX_TEXT_MSGS_AT_ONCE);
   
   Screen_Instance : Screen_Type :=
      (Pos => Screen_default_pos,
       Text_Message_Queue => Text_Message_Queue_Instance);
       
   procedure Enqueue_Message(Screen : in out Screen_Type; TM : Text_Message_type)
   with Global => null;

end screen;
