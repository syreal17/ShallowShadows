package body illumination is

   function Is_Illuminated(Pos : Pos_Type) return Boolean
   is
      C : Illumination_Sources_Type.Cursor;
      Illumine_Abstract : Item_Abstract_Type;
      Pos_Illumine : Pos_Type;
      Obstructed : Boolean;
      Length : Natural;
   begin
      --check if square is illuminated by some other illumination source
      C := Illumination_Sources_Type.First(Illumination_Sources);
      while Illumination_Sources_Type.Has_Element(Illumination_Sources, C) loop
         Illumine_Abstract := Illumination_Sources_Type.Element(Illumination_Sources, C);
         Pos_Illumine.Y := Illumine_Abstract.Pos.Y;
         Pos_Illumine.X := Illumine_Abstract.Pos.X;
         LOS(Pos, Pos_Illumine, Obstructed, Length, False);
         
         
         if not Obstructed and Length <= Illumine_Abstract.Illumination_Distance then
            return True;
         end if;
         
         Illumination_Sources_Type.Next(Illumination_Sources, C);
      end loop;
      
      return False;
   end Is_Illuminated;
   
end illumination;
