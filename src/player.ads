with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with SPARK.Text_IO; use SPARK.Text_IO;

with spatial; use spatial;
with corporeal; use corporeal;
with rendering;
with game_constants; use game_constants;
with dungeon; use dungeon;
with debugging; use debugging;
with screen; use screen;
with text_messages; use text_messages;

package Player with SPARK_Mode => On
is
   pragma Elaborate_Body;

   subtype Player_Ind_Type is Natural range 0 .. 10;

   type Player_Concrete_Type is 
   record
      Ind : Player_Ind_Type;
      Soma : corporeal.Soma_Type;
      Render : rendering.Player_Render;
   end record;

   type Player_Abstract_Type is
   record
      Pos : spatial.Pos_Type;
      Turns_Taken : Natural;
      Darkvision_Distance : Natural;
   end record;
   
   Player_Concrete_Instance : Player_Concrete_Type :=
      (Ind => 1,
       Soma => corporeal.Player_Start_Soma,
       Render => rendering.Player_Render_Instance);
       
   Player_Concrete_Nothing : Player_Concrete_Type :=
      (Ind => 0,
       Soma => corporeal.Player_Nothing_Soma,
       Render => rendering.Player_Nothing_Render);
       
   Player_Abstract_Instance : Player_Abstract_Type :=
      (Pos => spatial.Player_Default_Pos,
       Turns_Taken => 0,
       Darkvision_Distance => 1);

   type Player_Layer_Type is array (Positive range Y_Pos_Type'First .. Y_Pos_Type'Last, Positive range X_Pos_Type'First .. X_Pos_Type'Last) of Player_Concrete_Type;
   
   Player_Layer : Player_Layer_Type;
   
   walk_north_key : Character := '8';
   walk_south_key : Character := '2';
   walk_west_key : Character := '4';
   walk_east_key : Character := '6';
   turn_strafe_key_7 : Character := '7';
   turn_strafe_key_9 : Character := '9';
   turn_strafe_key_1 : Character := '1';
   turn_strafe_key_3 : Character := '3';
   backpedal_key : Character := '0';
   toggle_crouch_key : Character := 's';
   toggle_prone_key : Character := 'S';
   quit_key : Character := 'Q';
   continue_messages_key : Character := ' ';
   
   --player action narrations
   TM_crouch : Text_Message_type := Construct_Message("You crouch down.");
   TM_stand : Text_Message_type := Construct_Message("You stand up.");
   TM_prone : Text_Message_type := Construct_Message("You lie down.");
       
   procedure Player_Move(Y_Vec : X_Vec_Type; X_Vec : Y_Vec_Type; Change_Facing : Boolean) --Include Ind for multiple players
   with Global => (In_Out => (Player_Abstract_Instance, Player_Layer,
                              Screen_Instance),
                   Input => (Terrain_Layer, Player_Concrete_Nothing));
                   
   procedure Player_Toggle_Crouch
   with Global => (In_Out => (Player_Layer),
                   Input =>   Player_Abstract_Instance);
   
   procedure Player_Toggle_Prone
   with Global => (In_Out => (Player_Layer),
                   Input =>   Player_Abstract_Instance);
                   
   procedure Player_Change_Stance(Stance : Stance_Type)
   with Global => (In_Out => (Player_Layer, Screen_Instance),
                   Input =>   (Player_Abstract_Instance, Terrain_Layer,
                              TM_stand, TM_crouch, TM_prone));
   
   procedure Do_User_action_IF(S : String; Valid : out Boolean)
   with Global => (In_Out => (Player_Abstract_Instance, Player_Layer, Screen_Instance),
                   Input => (Player_Concrete_Nothing));
   
   procedure Do_User_action_RL(C : Character; Valid : out Boolean; Game_Continue : out Boolean)
   with Global => (In_Out => (Player_Abstract_Instance, Player_Layer));
   
   procedure User_Wait_For_Continue_Messages_Key
   with Global => (In_Out => Standard_Input);
   
   procedure Player_Turn_CCW
   with Global => (In_Out => Player_Layer, Input => Player_Abstract_Instance);
   
   procedure Player_Turn_CW
   with Global => (In_Out => Player_Layer, Input => Player_Abstract_Instance);
   
   procedure Player_Face(New_Facing : Facing_Type)
   with Global => (In_Out => Player_Layer, Input => Player_Abstract_Instance);

end Player;
