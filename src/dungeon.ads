with spatial; use spatial;
with identifier; use identifier;
with rendering; use rendering;
with game_constants; use game_constants;
with corporeal; use corporeal;

package dungeon with SPARK_Mode => On
is

   type Dungeon_Init_Type is array (Positive range 1 .. DUNGEON_MAX_WIDTH_Y, Positive range 1 .. DUNGEON_MAX_WIDTH_X) of Identifier_Type;

   --brick and mortar of the dungeon
   type Terrain_Type is
   record
      Id : Identifier_Type;
      Render : Terrain_Render;
      Nothingness : Boolean;
      Physical_Obstruction : Boolean;
      Visual_Obstruction : Boolean;
      Projectile_Obstruction : Boolean;
      Clearance : Height_Type;
      --below are dynamic traits
      Discovered : Boolean;
   end record;

   Floor_Terrain : Terrain_Type :=
      (Id => FLOOR000,
       Render => Floor_Render,
       Nothingness => False,
       Physical_Obstruction => False,
       Visual_Obstruction => False,
       Projectile_Obstruction => False,
       Clearance => 300,
       Discovered => False);

   Tunnel_Terrain : Terrain_Type :=
      (Id => TUNNEL00,
       Render => Floor_Render,
       Nothingness => False,
       Physical_Obstruction => False,
       Visual_Obstruction => False,
       Projectile_Obstruction => False,
       Clearance => 100,
       Discovered => False);

   Wall_Terrain : Terrain_Type :=
      (Id => WALL0000,
       Render => Wall_Render,
       Nothingness => False,
       Physical_Obstruction => True,
       Visual_Obstruction => True,
       Projectile_Obstruction => True,
       Clearance => Height_Type'First,
       Discovered => False);

   WallHoleN_Terrain : Terrain_Type :=
      (Id => WALHOLEN,
       Render => WallHoleN_Render,
       Nothingness => False,
       Physical_Obstruction => False,
       Visual_Obstruction => True,
       Projectile_Obstruction => True,
       Clearance => 100,
       Discovered => False);

   WallHoleS_Terrain : Terrain_Type :=
      (Id => WALHOLES,
       Render => WallHoleS_Render,
       Nothingness => False,
       Physical_Obstruction => False,
       Visual_Obstruction => True,
       Projectile_Obstruction => True,
       Clearance => 100,
       Discovered => False);

   WallHoleW_Terrain : Terrain_Type :=
      (Id => WALHOLEW,
       Render => WallHoleW_Render,
       Nothingness => False,
       Physical_Obstruction => False,
       Visual_Obstruction => True,
       Projectile_Obstruction => True,
       Clearance => 100,
       Discovered => False);

   WallHoleE_Terrain : Terrain_Type :=
      (Id => WALHOLEE,
       Render => WallHoleE_Render,
       Nothingness => False,
       Physical_Obstruction => False,
       Visual_Obstruction => True,
       Projectile_Obstruction => True,
       Clearance => 100,
       Discovered => False);

   Window_Terrain : Terrain_Type :=
      (Id => WINDOW00,
       Render => Window_Render,
       Nothingness => False,
       Physical_Obstruction => True,
       Visual_Obstruction => False,
       Projectile_Obstruction => True,
       Clearance => 20,
       Discovered => False);

   Nothing_Terrain : Terrain_Type :=
      (Id => NOTHING0,
       Render => Nothing_Render,
       Nothingness => True,
       Physical_Obstruction => False,
       Visual_Obstruction => False,
       Projectile_Obstruction => False,
       Clearance => Height_Type'Last,
       Discovered => False);

   type Terrain_Layer_Type is array (Positive range Y_Pos_Type'First .. Y_Pos_Type'Last, Positive range X_Pos_Type'First .. X_Pos_Type'Last) of Terrain_Type;

   Terrain_Layer : Terrain_Layer_Type;

end dungeon;
