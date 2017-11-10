with game_constants; use game_constants;
with corporeal; use corporeal;
with rendering; use rendering;
with player; use player;
with dungeon; use dungeon;
with identifier; use identifier;
with item; use item;
with illumination; use illumination;

package level with SPARK_Mode => On
is

   procedure Load_Dungeon(To_Load_Dungeon_Init : Dungeon_Init_Type)
   with Global => (In_Out => (Player_Layer, Terrain_Layer,
                              Player_Abstract_Instance, Item_Layer,
                              Illumination_Sources, Torch_Item_Abstract),
                   Input => (Player_Concrete_Instance, Wall_Terrain,
                             Floor_Terrain, Nothing_Terrain, Window_Terrain,
                             Torch_Item_Concrete));

end level;
