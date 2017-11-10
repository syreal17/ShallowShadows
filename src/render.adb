package body render with SPARK_Mode => On
is

   procedure Render_Dungeon is
      --should account for screen position
      min_Y : Y_Pos_Type := Screen_Instance.Pos.Y;
      max_Y : Y_Pos_Type := min_Y + SCREEN_WIDTH_Y;
      min_X : X_Pos_Type := Screen_Instance.Pos.X;
      max_X : X_Pos_Type := min_X + SCREEN_WIDTH_X;
      buffer : String(1 .. SCREEN_AREA) := (others=>NUL);
      dungeon_buffer : String(1 .. SCREEN_AREA);
      --Pos : Pos_type;
      J : Positive := 1;
      --Illuminated_Player : Boolean;
      Pos_Rend : Pos_Type;
      Pos_Player : Pos_type := Player_Abstract_Instance.Pos;
      Obstructed : Boolean;
      Player_Facing : Facing_Type := Player_Layer(Pos_Player.Y, Pos_Player.X).Soma.Facing;
      FOV : Boolean;
      Illuminated : Boolean;
      Darkseen : Boolean;
      
      done : Boolean := False;
      is_messages_to_print : Boolean;
      --S : String(1 .. SCREEN_WIDTH_X);
      --N : Natural;
   begin
      --copy window in level to string buffer
      for Y in min_Y .. max_Y loop
         for X in min_X .. max_X loop
            --current position to render
            Pos_Rend.Y := Y;
            Pos_Rend.X := X;
            
            --check if square is obstructed
            Obstructed := Is_Obstructed(Pos_Rend, Pos_Player);
            
            --check if square is within player's darkvision range
            Darkseen := Is_Darkseen(Pos_Rend, Pos_Player, Player_Abstract_Instance.Darkvision_Distance);
            
            --check if square is in Field of View FOV
            FOV := Is_FOV(Pos_Rend, Pos_Player, Player_Facing);
            
            --check if square is illuminated
            Illuminated := Is_Illuminated(Pos_rend);
            
            if not Obstructed and FOV and (Illuminated or Darkseen) then
               Terrain_Layer(Y,X).Discovered := True;
               buffer( J ) := Get_Tile(Pos_Rend, Illuminated, Terrain_Layer(Y,X).Discovered, True);
            else
               buffer( J ) := Get_Tile(Pos_Rend, Illuminated, Terrain_Layer(Y,X).Discovered, False);
            end if;
            J := J + 1;
         end loop;
         
         buffer( J ) := LF;
         J := J + 1;
      end loop;
      --copy pure dungeon buffer to dungeon_buffer, so we can reprint the dungeon after all the messages
      dungeon_buffer := buffer;
      
      --loop until Overlay Buffer is done, then put dungeon_buffer
      while not done loop
         buffer := dungeon_buffer;
         --TODO: overwrite buffer with text messsages, popping as many off the queue as will fit on the screen
         Overlay_Queued_Texts(buffer, done, is_messages_to_print);
         
         if is_messages_to_print and not done then
           Put(buffer);
           User_Wait_For_Continue_Messages_Key;
         end if;
      end loop;
      
      Put(buffer);
   end Render_Dungeon;
   
   procedure Render_Dungeon_Color is
      --should account for screen position
      min_Y : Y_Pos_Type := Screen_Instance.Pos.Y;
      max_Y : Y_Pos_Type := min_Y + SCREEN_WIDTH_Y;
      min_X : X_Pos_Type := Screen_Instance.Pos.X;
      max_X : X_Pos_Type := min_X + SCREEN_WIDTH_X;
      buffer : String(1 .. RENDER_BUFFER_LENGTH) := (others=>NUL);
      dungeon_buffer : String(1 .. RENDER_BUFFER_LENGTH);
      color_buffer : String(1 .. RENDER_COLOR_BUFFER_LENGTH) := (others=>NUL);
      temp_buffer : String(1 .. RENDER_TEMP_COLOR_BUFFER_LENGTH) := (others=>NUL);
      color_array : Linear_ANSI_Colors := (others=> Empty_Color_Code);
      --Pos : Pos_type;
      J : Positive := 1;
      K : Positive := 1;
      --Illuminated_Player : Boolean;
      Pos_Rend : Pos_Type;
      Pos_Player : Pos_type := Player_Abstract_Instance.Pos;
      Obstructed : Boolean;
      Player_Facing : Facing_Type := Player_Layer(Pos_Player.Y, Pos_Player.X).Soma.Facing;
      FOV : Boolean;
      Illuminated : Boolean;
      Darkseen : Boolean;
      
      done : Boolean := False;
      is_messages_to_print : Boolean;
      --S : String(1 .. SCREEN_WIDTH_X);
      --N : Natural;
      color_code : String(1..ANSI_COLOR_CODE_LENGTH) := (others=>NUL);
   begin
      --copy window in level to string buffer
      for Y in min_Y .. max_Y loop
         for X in min_X .. max_X loop
            --current position to render
            Pos_Rend.Y := Y;
            Pos_Rend.X := X;
            
            --check if square is obstructed
            Obstructed := Is_Obstructed(Pos_Rend, Pos_Player);
            
            --check if square is within player's darkvision range
            Darkseen := Is_Darkseen(Pos_Rend, Pos_Player, Player_Abstract_Instance.Darkvision_Distance);
            
            --check if square is in Field of View FOV
            FOV := Is_FOV(Pos_Rend, Pos_Player, Player_Facing);
            
            --check if square is illuminated
            Illuminated := Is_Illuminated(Pos_rend);
            
            if not Obstructed and FOV and (Illuminated or Darkseen) then
               Terrain_Layer(Y,X).Discovered := True;
               buffer( J ) := Get_Tile(Pos_Rend, Illuminated, Terrain_Layer(Y,X).Discovered, True);
               --TODO: add color to Linear_ANSI_Color here
               color_array( J ) := Get_Color_Code(Pos_Rend, Illuminated, Terrain_Layer(Y,X).Discovered, True);
            else
               buffer( J ) := Get_Tile(Pos_Rend, Illuminated, Terrain_Layer(Y,X).Discovered, False);
               --TODO: add color to Linear_ANSI_Color here
               color_array( J ) := Get_Color_Code(Pos_Rend, Illuminated, Terrain_Layer(Y,X).Discovered, False);
            end if;
            J := J + 1;
         end loop;
         
         buffer( J ) := LF;
         --TODO: add color to Linear_ANSI_Color here
         color_array( J ) := LF_Color;
         J := J + 1;
      end loop;
      --copy pure dungeon buffer to dungeon_buffer, so we can reprint the dungeon after all the messages
      dungeon_buffer := buffer;
      
      --loop until Overlay Buffer is done, 
      while not done loop
         buffer := dungeon_buffer;
         --overwrite buffer with text messsages, popping as many off the queue as will fit on the screen
         Overlay_Queued_Texts(buffer, done, is_messages_to_print);
         
         if is_messages_to_print and not done then
           --TODO: add, add_color here
           Put(buffer);
           User_Wait_For_Continue_Messages_Key;
         end if;
      end loop;
      
      --copy buffer to color buffer
      for H in buffer'Range loop
         color_buffer( H ) := buffer( H );
      end loop;
      
      for I in reverse color_array'Range loop
         color_code := color_array( I );
         temp_buffer := Ada.Strings.Fixed.Insert(color_buffer, I, color_code);
         color_buffer := Ada.Strings.Fixed.Delete(temp_buffer, RENDER_COLOR_BUFFER_LENGTH+1, RENDER_TEMP_COLOR_BUFFER_LENGTH); --TODO: replace magic numbers with constant
      end loop;
         
      
      Put(color_buffer);
   end Render_Dungeon_Color;
   
   function Get_Tile(Pos : Pos_Type; Illuminated : Boolean; Discovered : Boolean; Seen : Boolean) return Tile_Type
   is
      Player_Concrete : Player_Concrete_Type := Player_Layer(Pos.Y, Pos.X);
      Tile : Tile_Type;
   begin
      --go through layers, drawing most important tile. Most important is towards bottom
      if Discovered and Seen and Illuminated then
         Tile := Terrain_Layer(Pos.Y, Pos.X).Render.discovered_seen_illuminated_tile;
      elsif Discovered and Seen and not Illuminated then
         Tile := Terrain_Layer(Pos.Y, Pos.X).Render.discovered_seen_darkened_tile;
      elsif Discovered and not Seen then
         Tile := Terrain_Layer(Pos.Y, Pos.X).Render.discovered_unseen_tile;
      elsif not Discovered and not Seen then
         Tile := Terrain_Layer(Pos.Y, Pos.X).Render.undiscovered_unseen_tile;
      else
         --if tile gets X something went wrong
         --TODO: raise exception and use SPARK to prove it doesn't happen
         Tile := 'X';
      end if;
      
      if Item_Layer(Pos.Y, Pos.X) /= No_Item_Concrete then
         if Seen then
            Tile := Item_Layer(Pos.Y, Pos.X).Render.seen_tile;
         elsif not Seen then
            Tile := Item_Layer(Pos.Y, Pos.X).Render.unseen_tile;
         end if;
      end if;
      
      if Player_Concrete /= Player_Concrete_Nothing then
         if Illuminated and Player_Concrete.Soma.Stance = Standing then
            Tile := Player_Layer(Pos.Y, Pos.X).Render.standing_tile;
         elsif Illuminated and (Player_Concrete.Soma.Stance = Crouching or Player_Concrete.Soma.Stance = Prone) then
            Tile := Player_Layer(Pos.Y, Pos.X).Render.crouch_prone_tile;
         elsif not Illuminated and Player_Concrete.Soma.Stance = Standing then
            Tile := Player_Layer(Pos.Y, Pos.X).Render.standing_tile;
         elsif not Illuminated and (Player_Concrete.Soma.Stance = Crouching or Player_Concrete.Soma.Stance = Prone) then
            Tile := Player_Layer(Pos.Y, Pos.X).Render.crouch_prone_tile;
         end if;
      end if;
      
      return Tile;
   end Get_Tile;
   
   function Get_Color_Code(Pos : Pos_Type; Illuminated : Boolean; Discovered : Boolean; Seen : Boolean) return String
   is
      Player_Concrete : Player_Concrete_Type := Player_Layer(Pos.Y, Pos.X);
   begin
      if Player_Concrete /= Player_Concrete_Nothing then
         if Illuminated and Player_Concrete.Soma.Stance = Standing then
            return Player_Concrete.Render.illuminated_fg_color & Player_Concrete.Render.bg_color;
         elsif Illuminated and (Player_Concrete.Soma.Stance = Crouching or Player_Concrete.Soma.Stance = Prone) then
            return Player_Concrete.Render.illuminated_fg_color & Player_Concrete.Render.bg_color;
         elsif not Illuminated and Player_Concrete.Soma.Stance = Standing then
            return Player_Concrete.Render.darkened_fg_color & Player_Concrete.Render.bg_color;
         elsif not Illuminated and (Player_Concrete.Soma.Stance = Crouching or Player_Concrete.Soma.Stance = Prone) then
            return Player_Concrete.Render.darkened_fg_color & Player_Concrete.Render.bg_color;
         end if;
      end if;
      
      if Item_Layer(Pos.Y, Pos.X) /= No_Item_Concrete then
         if Seen and Illuminated then
            return Item_Layer(Pos.Y, Pos.X).Render.illuminated_fg_color & Item_Layer(Pos.Y, Pos.X).Render.illuminated_bg_color; --& Item_Layer(Pos.Y, Pos.X).Render.seen_tile;
         elsif Seen and not Illuminated then
            return Item_Layer(Pos.Y, Pos.X).Render.darkened_fg_color & Item_Layer(Pos.Y, Pos.X).Render.darkened_bg_color;
         elsif not Seen then
            return LF_Color;
         end if;
      end if;
   
      if Discovered and Seen and Illuminated then
         return Terrain_Layer(Pos.Y, Pos.X).Render.illuminated_fg_color & Terrain_Layer(Pos.Y, Pos.X).Render.illuminated_bg_color; --& Terrain_Layer(Pos.Y, Pos.X).Render.discovered_seen_illuminated_tile;
      elsif Discovered and Seen and not Illuminated then
         return Terrain_Layer(Pos.Y, Pos.X).Render.darkened_fg_color & Terrain_Layer(Pos.Y, Pos.X).Render.darkened_bg_color;-- & Terrain_Layer(Pos.Y, Pos.X).Render.discovered_seen_darkened_tile;
      elsif Discovered and not Seen then
         return Terrain_Layer(Pos.Y, Pos.X).Render.darkened_fg_color & Terrain_Layer(Pos.Y, Pos.X).Render.darkened_bg_color;-- & Terrain_Layer(Pos.Y, Pos.X).Render.discovered_unseen_tile;
      elsif not Discovered and not Seen then
         return LF_Color;-- & Terrain_Layer(Pos.Y, Pos.X).Render.undiscovered_unseen_tile;
      else
         --TODO: raise exception and use SPARK to prove it doesn't happen
         return Empty_Color_Code;
      end if;
   end Get_Color_Code;
   
   procedure Overlay_Queued_Texts(buffer : in out String; done, is_messages_to_print : out Boolean)
   is
      TM : Text_Message_type;
      C, Prev_C : Text_Message_Queue_Pkg.Cursor;
      Lines_Left : Natural := SCREEN_WIDTH_Y - 2; --making room for a "more messages" message if needed
      Lines_Used : Natural := 0;
   begin
      is_messages_to_print := False;
   
      if Text_Message_Queue_Pkg.Length(Screen_Instance.Text_Message_Queue) = 0 then
         done := True;
         return;
      end if;
      
      --TODO: to make more important meesages the first ones, could do Last instead of first, and previous instead of next
      --traverse queue, popping items off until either we reach the end of queue, or run out of screen space. 
      --In the first case, we're done, in the second we're not done. In both cases there are messages to print
      C := Text_Message_Queue_Pkg.First(Screen_Instance.Text_Message_Queue);
      while Text_Message_Queue_Pkg.Has_Element(Screen_Instance.Text_Message_Queue, C) loop
         TM := Text_Message_Queue_Pkg.Element(Screen_Instance.Text_Message_Queue, C);
         --Put_Line( "Message Lines: " & Get_Message_Lines(TM)'Image & " Lines_Left: " & Lines_Left'Image);
         if Get_Message_Lines(TM) + 1 <= Lines_Left then
            Lines_Left := Lines_Left - (Get_Message_Lines(TM) + 1);
            is_messages_to_print := True;
            
            Overlay_Buffer_Text_message_rev(buffer, TM, Lines_Used);
            
            Prev_C := C;
            C := Text_Message_Queue_Pkg.Next(Screen_Instance.Text_Message_Queue, C);
            --delete Prev_C from queue, it was printed
            Text_Message_Queue_Pkg.Delete(Screen_Instance.Text_Message_Queue, Prev_C);
            
            Lines_Used := Lines_Used + Get_Message_Lines(TM) + 1;
         else
            is_messages_to_print := True;
            
            Overlay_Buffer_Text_message_rev(buffer, TM_more_messages, Lines_Used);
            
            done := False;
            return;
         end if;
      end loop;
      
      done := True;
      return;
   end Overlay_Queued_Texts;
   
   procedure Overlay_Buffer_Text_message_rev(buffer : in out String; TM : Text_Message_Type; Lines_Used : Natural)
   is
      Start_I : Positive := 1;
      Count_LF : Natural := 0;
   begin
      --overlay on buffer here
      for I in reverse buffer'Range loop
         if buffer(I) = LF then
            Count_LF := Count_LF + 1;
            if Count_LF = Lines_Used + Get_Message_Lines(TM) + 1 then
               --Put_Line(Count_LF'Image);
               Start_I := I + 1;
               exit;
            end if;
         end if;
      end loop;
      
      --Put_Line(Start_I'Image);
      for I in Start_I .. Start_I + Get_Message_Length(TM) - 1 loop
         buffer(I) := Get_Message(TM)((I - Start_I)+1);
      end loop;
   end Overlay_Buffer_Text_message_rev;
end render;
