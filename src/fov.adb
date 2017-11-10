package body fov is

   function Is_Darkseen(Pos_Target, Pos_Seer : Pos_Type; Darkvision_Distance : Natural) return Boolean
   is
      Obstructed : Boolean;
      Length : Natural;
   begin
      LOS(Pos_Target, Pos_Seer, Obstructed, Length, False);
      
      if Length <= Darkvision_Distance then
         return True;
      end if;
      
      return False;
   end Is_Darkseen;
   
   function Is_FOV(Pos_Target, Pos_Seer : Pos_Type; Facing : Facing_Type) return Boolean
   is
   begin
      case Facing is
         when North =>
            if Pos_Target.X <= Pos_Seer.X then
               return True;
            end if;
         when South =>
            if Pos_Target.X >= Pos_Seer.X then
               return True;
            end if;
         when East =>
            if Pos_Target.Y >= Pos_Seer.Y then
               return True;
            end if;
         when West =>
            if Pos_Target.Y <= Pos_Seer.Y then
               return True;
            end if;
      end case;
      
      return False;
   end Is_FOV;
   
   function Is_Obstructed(Pos_Target, Pos_Seer : Pos_Type) return Boolean
   is
      --Y_Mod_Vec : Y_Vec_Type;
     -- X_Mod_Vec : X_Vec_Type;
     -- Pos_Mod_Target : Pos_Type;
      Obstructed : Boolean;
      Length : Natural;
   begin
      --NOTE: the mod to target pos has some unintended side effects of seeing walls very far away but not ones closer.
      --make a modified starting position for LOS for walls because if taken naively, straight walls block their own ends from view
      --Y_Mod_Vec := Integer'Max(Integer'Min(Pos_Seer.Y - Pos_Target.Y, 1), -1);
      --X_Mod_Vec := Integer'Max(Integer'Min(Pos_Seer.X - Pos_Target.X, 1), -1);
      --Pos_Mod_Target.Y := Pos_Target.Y + Y_Mod_vec;
      --Pos_Mod_Target.X := Pos_Target.X + X_Mod_vec;
      
      --if Terrain_Layer(Pos_Target.Y, Pos_Target.X).Render.Extended_LOS then
        -- LOS(Pos_Mod_Target, Pos_Seer, Obstructed, Length, False);
      --else
         LOS(Pos_Target, Pos_Seer, Obstructed, Length, False);
     -- end if;
      
      return Obstructed;
   end Is_Obstructed;
   
end fov;
