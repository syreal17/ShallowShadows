with bresenham; use bresenham;
with spatial; use spatial;
with dungeon; use dungeon;
with corporeal; use corporeal;

package fov is

   function Is_Darkseen(Pos_Target, Pos_Seer : Pos_Type; Darkvision_Distance : Natural) return Boolean
   with Global => (Input => Terrain_Layer);
   
   function Is_FOV(Pos_Target, Pos_Seer : Pos_Type; Facing : Facing_Type) return Boolean
   with Global => null;
   
   function Is_Obstructed(Pos_Target, Pos_Seer : Pos_Type) return Boolean
   with Global => (Input => Terrain_Layer);

end fov;
