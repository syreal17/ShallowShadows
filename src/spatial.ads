with game_constants; use game_constants;

package spatial with SPARK_Mode => On
is
 
   subtype X_Pos_Type is Positive range 1 .. DUNGEON_MAX_WIDTH_X;
   subtype Y_Pos_Type is Positive range 1 .. DUNGEON_MAX_WIDTH_Y;
   --TODO: refactor rename to directional not vvec
   subtype X_Vec_Type is Integer range -1 .. 1;
   subtype Y_Vec_Type is Integer range -1 .. 1;
   --TODO: LOS length type -- max hypotenous of X and Y max

   type Pos_Type is 
   record
      X : X_Pos_Type;
      Y : Y_Pos_Type;
   end record;
   
   function "<" (L, R : Pos_Type) return Boolean;
   
   --TODO: comment out, starting position is loaded from dungeon
   Player_Default_Pos : Pos_Type :=
      (X => 2,
       Y => 2);
       
   --TODO: need default position for screen?
   Screen_default_pos : Pos_type :=
      (X => 1,
       Y => 1);
   
   Item_Default_Pos : Pos_type :=
      (X => 3,
       Y => 3);

end spatial;
