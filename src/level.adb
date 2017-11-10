package body level with SPARK_Mode => On
is

   procedure Load_Dungeon(To_Load_Dungeon_Init : Dungeon_Init_Type) is
      To_load_id : Identifier_Type;
   begin
      --traverse init array, loading objects into layers as we go
      for Y in To_load_dungeon_init'range(1) loop
         for X in To_load_dungeon_init'range(2) loop
            To_Load_Id := To_Load_Dungeon_Init(Y,X);
            
            case To_Load_Id is
               when PLAYER01 =>
                  Player_Abstract_Instance.Pos.Y := Y;
                  Player_Abstract_Instance.Pos.X := X;
                  Player_Layer(Y,X) := Player_Concrete_Instance;
                  Terrain_Layer(Y,X) := Floor_Terrain; --want the player standing on something
               
               when WALL0000 =>
                  Terrain_Layer(Y,X) := Wall_Terrain;
                  
               when WALHOLEN =>
                  Terrain_Layer(Y,X) := WallHoleN_Terrain;
                  
               when WALHOLES =>
                  Terrain_Layer(Y,X) := WallHoleS_Terrain;
                  
               when WALHOLEW =>
                  Terrain_Layer(Y,X) := WallHoleW_Terrain;
                  
               when WALHOLEE =>
                  Terrain_Layer(Y,X) := WallHoleE_Terrain;
                  
               when WINDOW00 =>
                  Terrain_Layer(Y,X) := Window_Terrain;
                  
               when TUNNEL00 =>
                  Terrain_Layer(Y,X) := Tunnel_Terrain;
               
               when FLOOR000 =>
                  Terrain_Layer(Y,X) := Floor_Terrain;
                  
               when NOTHING0 =>
                  Terrain_Layer(Y,X) := Nothing_Terrain;
                  
               when TORCHITM =>
                  Item_Layer(Y,X) := Torch_Item_Concrete;
                  Terrain_Layer(Y,X) := Floor_Terrain;
                  Torch_Item_Abstract.Pos.Y := Y;
                  Torch_Item_Abstract.Pos.X := X;
                  Illumination_Sources_Type.Prepend(Illumination_Sources, Torch_Item_Abstract);
            end case;
         end loop;
      end loop;
   end Load_Dungeon;
   
end level;
