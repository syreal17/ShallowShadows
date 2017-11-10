package body player with SPARK_Mode => On
is

   procedure Player_Move(Y_Vec : X_Vec_Type; X_Vec : Y_Vec_Type; Change_Facing : Boolean)
   is
      Temp_Player_Concrete : Player_Concrete_Type;
      new_Pos : Pos_Type := Player_Abstract_Instance.Pos;
      old_Pos : Pos_Type := Player_Abstract_Instance.Pos;
   begin 
      --check that player remains within bounds of the dungeon
      --Note: can do facing changes here because only one of these is true at a time because currently we can only move in cardinal directions
      if X_Vec = -1 and old_Pos.X > X_Pos_Type'First then
         new_Pos.X := old_Pos.X + X_Vec;
         
         if Change_Facing then
            Player_Layer(old_Pos.Y, old_Pos.X).Soma.Facing := North;
         end if;
      elsif X_Vec = 1 and old_Pos.X < X_Pos_Type'Last then
         new_Pos.X := old_Pos.X + X_Vec;
         
         if Change_Facing then
            Player_Layer(old_Pos.Y, old_Pos.X).Soma.Facing := South;
         end if;
      end if;
      
      if Y_Vec = -1 and old_Pos.Y > Y_Pos_Type'First then
         new_Pos.Y := old_Pos.Y + Y_Vec;
         
         if Change_Facing then
            Player_Layer(old_Pos.Y, old_Pos.X).Soma.Facing := West;
         end if;
      elsif Y_Vec = 1 and old_Pos.Y < Y_Pos_Type'Last then
         new_Pos.Y := old_Pos.Y + Y_Vec;
         
         if Change_Facing then
            Player_Layer(old_Pos.Y, old_Pos.X).Soma.Facing := East;
         end if;
      end if;
      
      --check what the player is trying to move into
      if not Terrain_Layer(new_Pos.Y, new_Pos.X).Physical_Obstruction and 
       not Terrain_Layer(new_Pos.Y, new_Pos.X).Nothingness and
       Player_Layer(old_Pos.Y, old_Pos.X).Soma.Current_Height <= Terrain_Layer(new_Pos.Y, new_Pos.X).Clearance then
      
         --copy player from old position to put in new position
         Temp_Player_Concrete := Player_Layer(old_Pos.Y, old_Pos.X);
         
         --erase old posiiton of player in player layer and queue change for full render map
         Player_Layer(old_Pos.Y, old_Pos.X) := Player_Concrete_Nothing;
         
         --create new player in player layer- queue change for full render map
         Player_Layer(new_Pos.Y, new_Pos.X) := Temp_Player_Concrete;
         
         --update abstract player component
         Player_Abstract_Instance.Pos := new_Pos;
         
         --update screen position
         Screen_Instance.Pos.Y := Integer'Max(Player_Abstract_Instance.Pos.Y - (SCREEN_WIDTH_Y/2), Y_Pos_Type'First);
         Screen_Instance.Pos.X := Integer'Max(Player_Abstract_Instance.Pos.X - (SCREEN_WIDTH_X/2), X_Pos_Type'First);
      end if;
   end Player_Move;
   
   procedure Player_Turn_CCW
   is
   begin
      case Player_Layer(Player_Abstract_Instance.Pos.Y, Player_Abstract_Instance.Pos.X).Soma.Facing is
         when North =>
            Player_Face(West);
         when West =>
            Player_Face(South);
         when South =>
            Player_Face(East);
         when East =>
            Player_Face(North);
      end case;
   end Player_Turn_CCW;
   
   procedure Player_Turn_CW
   is
   begin
      case Player_Layer(Player_Abstract_Instance.Pos.Y, Player_Abstract_Instance.Pos.X).Soma.Facing is
         when North =>
            Player_Face(East);
         when West =>
            Player_Face(North);
         when South =>
            Player_Face(West);
         when East =>
            Player_Face(South);
      end case;
   end Player_Turn_CW;
   
   procedure Player_Face(New_Facing : Facing_Type)
   is
   begin
      Player_Layer(Player_Abstract_Instance.Pos.Y, Player_Abstract_Instance.Pos.X).Soma.Facing := New_Facing;
   end Player_Face;
   
   procedure Player_Toggle_Crouch
   is
      Y : Y_Pos_Type := Player_Abstract_Instance.Pos.Y;
      X : X_Pos_Type := Player_Abstract_Instance.Pos.X;
      Player_Concrete : Player_Concrete_Type := Player_Layer(Y, X);
   begin
      case Player_Concrete.Soma.Stance is
         when Standing =>
            Player_Change_Stance(Crouching);
         when Crouching =>
            Player_Change_Stance(Standing);
         when Prone =>
            Player_Change_Stance(Standing);
      end case;
   end Player_Toggle_Crouch;
   
   procedure Player_Toggle_Prone
   is
      Y : Y_Pos_Type := Player_Abstract_Instance.Pos.Y;
      X : X_Pos_Type := Player_Abstract_Instance.Pos.X;
      Player_Concrete : Player_Concrete_Type := Player_Layer(Y, X);
   begin
      case Player_Concrete.Soma.Stance is
         when Standing =>
            Player_Change_Stance(Prone);
         when Crouching =>
            Player_Change_Stance(Prone);
         when Prone =>
            Player_Change_Stance(Standing);   
      end case;
   end Player_Toggle_Prone;
   
   procedure Player_Change_Stance(Stance : Stance_Type)
   is
      Y : Y_Pos_Type := Player_Abstract_Instance.Pos.Y;
      X : X_Pos_Type := Player_Abstract_Instance.Pos.X;
      Player_Concrete : Player_Concrete_Type := Player_Layer(Y, X);
   begin
      case Stance is
         when Standing =>
            if Player_Concrete.Soma.Standing_Height <= Terrain_Layer(Y,X).Clearance then
               Player_Layer(Y,X).Soma.Stance := Standing;
               Player_Layer(Y,X).Soma.Current_Height := Player_Concrete.Soma.Standing_Height;
               Enqueue_Message(Screen_Instance, TM_stand);
            else
               --TODO: print messsage here saying "It's too small to stand up"
               null;
            end if;
         when Crouching =>
            if Player_Concrete.Soma.Crouching_Height <= Terrain_Layer(Y,X).Clearance then
               Player_Layer(Y,X).Soma.Stance := Crouching;
               Player_Layer(Y,X).Soma.Current_Height := Player_Concrete.Soma.Crouching_Height;
               Enqueue_Message(Screen_Instance, TM_crouch);
            else
               --TODO: print messsage here saying "It's too small to crouch"
               null;
            end if;
         when Prone =>
            if Player_Concrete.Soma.Prone_Height <= Terrain_Layer(Y,X).Clearance then
               Player_Layer(Y,X).Soma.Stance := Prone;
               Player_Layer(Y,X).Soma.Current_Height := Player_Concrete.Soma.Prone_Height;
               Enqueue_Message(Screen_Instance, TM_prone);
            else
               --TODO: print messsage here saying "It's too small to lay prone" --don't think that is actually possible
               null;
            end if;
      end case;
   end Player_Change_Stance;
   
   procedure Do_User_action_IF(S : String; Valid : out Boolean)
   is
      eight_str : String(1..SCREEN_WIDTH_X) := ('8', others=>NUL);
      eight2_str : String(1..SCREEN_WIDTH_X) := ('8', '8', others=>NUL);
      six_str : String(1..SCREEN_WIDTH_X) := ('6', others=>NUL);
      six2_str : String(1..SCREEN_WIDTH_X) := ('6', '6', others=>NUL);
      two_str : String(1..SCREEN_WIDTH_X) := ('2', others=>NUL);
      two2_str : String(1..SCREEN_WIDTH_X) := ('2', '2', others=>NUL);
      four_str : String(1..SCREEN_WIDTH_X) := ('4', others=>NUL);
      four2_str : String(1..SCREEN_WIDTH_X) := ('4', '4', others=>NUL);
      t_str : String(1..SCREEN_WIDTH_X) := ('t', others=>NUL);
      s_str : String(1..SCREEN_WIDTH_X) := ('s', others=>NUL);
      stand_str : String(1..SCREEN_WIDTH_X) := ('s','t','a','n','d', others=>NUL);
      crouch_str : String(1..SCREEN_WIDTH_X) := ('c','r','o','u','c','h', others=>NUL);
      lay_str : String(1..SCREEN_WIDTH_X) := ('l','a','y', others=>NUL);
      prone_str : String(1..SCREEN_WIDTH_X) := ('p','r','o','n','e', others=>NUL);
   begin
      --debugging
      --Print_Char_Codes(S);
      Valid := False;
   
      if S = eight_str then
         Player_Move(-1, 0, True);
         Valid := True;
      elsif S = six_str then
         Player_Move(0, 1, True);
         Valid := True;
      elsif S = two_str then
         Player_Move(1, 0, True);
         Valid := True;
      elsif S = four_str then
         Player_move(0, -1, True);
         Valid := True;
      elsif S = eight2_str then
         Player_Face(West);
         Valid := True;
      elsif S = six2_str then
         Player_Face(South);
         Valid := True;
      elsif S = two2_str then
         Player_Face(East);
         Valid := True;
      elsif S = four2_str then
         Player_Face(North);
         Valid := True;
      elsif S = stand_str then
         Player_Change_Stance(Standing);
         Valid := True;
      elsif S = crouch_Str then
         Player_Change_Stance(Crouching);
         Valid := True;
      elsif S = prone_str or S = lay_str then
         Player_Change_Stance(Prone);
         Valid := True;
      end if;
      
      if Valid then
         Player_Abstract_Instance.Turns_Taken := Player_Abstract_Instance.Turns_Taken + 1;
      end if;
   end Do_User_Action_IF;
   
   procedure Do_User_action_RL(C : Character; Valid : out Boolean; Game_Continue : out Boolean)
   is
      Player_Concrete : Player_Concrete_Type := Player_Layer(Player_Abstract_Instance.Pos.Y, Player_Abstract_Instance.Pos.X);
   begin
      --debugging
      --Print_Char_Codes(S);
      Valid := False;
      Game_Continue := True;
   
      --static keys
      if C = walk_north_key then
         Player_Move(-1, 0, True);
         Valid := True;
      elsif C = walk_east_key then
         Player_Move(0, 1, True);
         Valid := True;
      elsif C = walk_south_key then
         Player_Move(1, 0, True);
         Valid := True;
      elsif C = walk_west_key then
         Player_move(0, -1, True);
         Valid := True;
      elsif C = toggle_crouch_key then
         Player_Toggle_Crouch;
         Valid := True;
      elsif C = toggle_prone_key then
         Player_Toggle_Prone;
         Valid := True;
      elsif C = quit_key then
         Game_Continue := False;
         Valid := True;
      end if;
      
      --Valid is also useful to seeing if a key has been found yet
      if not Valid then
         --dyanmic keys
         case Player_Concrete.Soma.Facing is
            when West =>
               if C = turn_strafe_key_7 then
                  Player_Turn_CW;
                  Valid := True;
               elsif C = turn_strafe_key_9 then
                  Player_Turn_CCW;
                  Valid := True;
               elsif C = turn_strafe_key_1 then
                  Player_Move(0, -1, False);
                  Valid := True;
               elsif C = turn_strafe_key_3 then
                  Player_Move(0, 1, False);
                  Valid := True;
               elsif C = backpedal_key then
                  Player_Move(1, 0, False);
                  Valid := True;
               end if;
            when East =>
               if C = turn_strafe_key_1 then
                  Player_Turn_CCW;
                  Valid := True;
               elsif C = turn_strafe_key_3 then
                  Player_Turn_CW;
                  Valid := True;
               elsif C = turn_strafe_key_7 then
                  Player_Move(0, -1, False);
                  Valid := True;
               elsif C = turn_strafe_key_9 then
                  Player_Move(0, 1, FAlse);
                  Valid := True;
               elsif C = backpedal_key then
                  Player_Move(-1, 0, False);
                  Valid := True;
               end if;
            when North =>
               if C = turn_strafe_key_1 then
                  Player_Turn_CW;
                  Valid := True;
               elsif C = turn_strafe_key_7 then
                  Player_Turn_CCW;
                  Valid := True;
               elsif C = turn_strafe_key_9 then
                  Player_Move(-1, 0, False);
                  Valid := True;
               elsif C = turn_strafe_key_3 then
                  Player_Move(1, 0, False);
                  Valid := True;
               elsif C = backpedal_key then
                  Player_Move(0, 1, False);
                  Valid := True;
               end if;
            when South =>
               if C = turn_strafe_key_9 then
                  Player_Turn_CW;
                  Valid := True;
               elsif C = turn_strafe_key_3 then
                  Player_Turn_CCW;
                  Valid := True;
               elsif C = turn_strafe_key_7 then
                  Player_Move(-1, 0, False);
                  Valid := True;
               elsif C = turn_strafe_key_1 then
                  Player_Move(1, 0, False);
                  Valid := True;
               elsif C = backpedal_key then
                  Player_Move(0, -1, False);
                  Valid := True;
               end if;
         end case;
      end if;
      
      if Valid then
         Player_Abstract_Instance.Turns_Taken := Player_Abstract_Instance.Turns_Taken + 1;
      end if;
   end Do_User_Action_RL;
   
   procedure User_Wait_For_Continue_Messages_Key
   is
      IR : Immediate_Result;
      Avail : Boolean;
   begin
      loop
         Get_Immediate(IR, Avail);
         if Avail then
            if IR.Item = continue_messages_key then
               return;
            end if;
         end if;
      end loop;
   end User_Wait_For_Continue_Messages_Key;

begin
   
   --player layer initialization
   for Y in Player_Layer'Range(1) loop
      for X in Player_Layer'Range(2) loop
         Player_Layer(Y,X) := Player_Concrete_Nothing;
      end loop;
   end loop;

end player;
