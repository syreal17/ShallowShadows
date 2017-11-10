with SPARK.Text_IO; use SPARK.Text_IO;

with spatial; use spatial;
with dungeon; use dungeon;
with player; use Player;

package bresenham with SPARK_Mode => On is

  procedure LOS(Target_Pos, Seer_Pos : Pos_type; Obstructed : out Boolean; Length : out Natural; Debug : Boolean)
  with Global => (Input => (Terrain_layer));

  private

     procedure Check_Obstruction(Line_Pos, Target_Pos, Seer_pos : Pos_Type; Obstructed : out Boolean)
     with Global => (Input => (Terrain_Layer, Player_Layer));

end bresenham;
