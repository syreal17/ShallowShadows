package body bresenham is
   
   procedure LOS(Target_Pos, Seer_Pos : Pos_type; Obstructed : out Boolean; Length : out Natural; Debug : Boolean)
   is
      DX  : constant Float := abs Float (Seer_Pos.X - Target_Pos.X);
      DY  : constant Float := abs Float (Seer_Pos.Y - Target_Pos.Y);
      Err : Float;
      X   : Positive := Target_Pos.X;
      Y   : Positive := Target_Pos.Y;
      Step_X : Integer := 1;
      Step_Y : Integer := 1;
      Line_Pos : Pos_Type;
   begin
      Length := 0;
      Obstructed := False;
      
      if Target_Pos.X > Seer_Pos.X then
         Step_X := -1;
      end if;
      
      if Target_Pos.Y > Seer_Pos.Y then
         Step_Y := -1;
      end if;
      
      if DX > DY then
         Err := DX / 2.0;
         while X /= Seer_Pos.X loop
            Line_Pos.Y := Y;
            Line_Pos.X := X;
            
            if Terrain_Layer(Line_Pos.Y, Line_Pos.X).Visual_Obstruction then
               if Line_Pos /= Target_Pos then
                  Obstructed := True;
                  return;
               end if;
            end if;
            if Player_Layer(Line_Pos.Y, Line_Pos.X) /= Player_Concrete_Nothing then
               if Line_Pos /= Seer_Pos and Line_Pos /= Target_Pos then
                  Obstructed := True;
                  return;
               end if;
            end if;
            
            Err := Err - DY;
            if Err < 0.0 then
               Y := Y + Step_Y;
               Err := Err + DX;
            end if;
            X := X + Step_X;
            Length := Length + 1;
         end loop;
      else
         Err := DY / 2.0;
         while Y /= Seer_Pos.Y loop
            Line_Pos.Y := Y;
            Line_Pos.X := X;
         
            if Terrain_Layer(Line_Pos.Y,Line_Pos.X).Visual_Obstruction then
               if Line_Pos /= Target_Pos then
                  Obstructed := True;
                  return;
               end if;
            end if;
            if Player_Layer(Line_Pos.Y, Line_Pos.X) /= Player_Concrete_Nothing then
               if Line_Pos /= Seer_Pos and Line_Pos /= Target_Pos then
                  Obstructed := True;
                  return;
               end if;
            end if;
            
            Err := Err - DX;
            if Err < 0.0 then
               X := X + Step_X;
               Err := Err + DY;
            end if;
            Y := Y + Step_Y;
            Length := Length + 1;
         end loop;
      end if;
      
      Line_Pos.Y := Y;
      Line_Pos.X := X;
      
      if Terrain_Layer(Line_Pos.Y,Line_Pos.X).Visual_Obstruction then
         if Line_Pos /= Target_Pos then
            Obstructed := True;
            return;
         end if;
      end if;
      if Player_Layer(Line_Pos.Y, Line_Pos.X) /= Player_Concrete_Nothing then
         if Line_Pos /= Seer_Pos and Line_Pos /= Target_Pos then
            Obstructed := True;
            return;
         end if;
      end if;-- Ensure dots to be drawn
   end LOS;
   
   procedure Check_Obstruction(Line_Pos, Target_Pos, Seer_Pos : Pos_Type; Obstructed : out Boolean)
   is
   begin
      if Terrain_Layer(Line_Pos.Y, Line_Pos.X).Visual_Obstruction then
         if Line_Pos /= Target_Pos then --walls otherwise would block themselves from view
            Obstructed := True;
            return;
         end if;
      end if;
   end Check_Obstruction;
   
end bresenham;
