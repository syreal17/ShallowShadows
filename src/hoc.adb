pragma SPARK_Mode(On);

with SPARK.Text_IO; use SPARK.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with game_constants; use game_constants;
with level; use level;
with render;
with screen; use screen;
with player;
with dungeon;
with level1; use level1;
with text_messages;
with narration; use narration;

procedure HOC
with Global => (In_Out => (Standard_Output, Standard_Input, Screen_Instance),
                Output => (player.Player_Layer, dungeon.Terrain_Layer,
                           player.Player_Abstract_Instance),
                Input => (level1_dungeon_init, player.Player_Concrete_Instance)),
     Pre    => Is_Writable (Standard_Output) and
               Status (Standard_Output) = Success and
               Is_Readable (Standard_Input) and
               Status (Standard_Input) = Success
is
   --S : String (1 .. SCREEN_WIDTH_X) := (others=>NUL);
   --S_last : String (1 .. SCREEN_WIDTH_X) := (others=>NUL);
   Valid : Boolean;
   --N : Natural;
   IR : Immediate_Result;
   Avail : Boolean;
   Game_Continue : Boolean := True;
   --TM : text_messages.Text_Message_type;
begin
   --pre loops for beginning inits
   --Nothing yet

   --TM := text_messages.Construct("As you step from the stairs, they seal behind you trapping you in the Pits. You hear a voice: 'Hello Sailor! Welcome to the Pits. Your Lord Baal has committed you and your mortal shell to this place for his dread amusement. You are not the first and you are not the last. Perhaps there's a way out? Maybe you can make some friends. Just pray to your gods that your death is quick, painless and unexpected. But hey, I won't leave you completely out to dry. I'll show you how to move down here. Type 'y' and then 'enter' when you understand this message. Then type '6' and then 'enter' to move to the east.'");
   --Put(text_messages.Get_Message(TM));
   --Put(text_messages.Get_Message_Lines(TM)'Image);

   --Have outer while loop for loading a level and inits, inner loop for gameplay
   Load_Dungeon(level1_dungeon_init);

   --back story, for testing purposes --TODO: change player_continue_prompt to User_Wait_For_Space, maybe that will work in raw mode
   screen.Enqueue_Message(Screen_Instance, TM_narration_intro4);
   screen.Enqueue_Message(Screen_Instance, TM_narration_intro1);
   screen.Enqueue_Message(Screen_Instance, TM_narration_intro2);
   screen.Enqueue_Message(Screen_Instance, TM_narration_intro3);

   while Game_Continue loop
      --S := (others=>NUL); --reset the buffer, otherwise only what is overwritten is replaced.

      render.Render_Dungeon_Color;

      --check Current_Level.Finished -> exit gameplay loop
      --Get_Line(S, N);

      --trying get immediate
      loop
         Get_Immediate(IR, Avail);
         if Avail then
            player.Do_User_action_RL(IR.Item, Valid, Game_Continue);
            exit;
         end if;
      end loop;

      --if N = 0 then
      --   S := S_last;
      --end if;

      --player.Do_User_action_IF(S, Valid);

      --if N = 1 and Valid then
      --   S_last := S;
      --end if;
   end loop;
end HOC;
