with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package corporeal with SPARK_Mode => On
is

   subtype Health_Points_Type is Natural range 0 .. 1000;
   --type Physical_State is (Physical_Poison
   type Height_Type is new Positive range 1 .. 2000; --centimeters: will affect large monsters pursuing adventurer
   type Weight_Type is new Positive range 1 .. 4000; --kilograms: not sure what this will affect. Knockover?
   type Facing_Type is (North, South, East, West);
   type Stance_Type is (Standing, Crouching, Prone);

   type Soma_Type is 
   record
      Facing : Facing_Type;
      Stance : Stance_Type;
      Health_Points : Health_Points_Type;
      Health_Points_Max : Health_Points_Type;
      Standing_Height : Height_Type;
      Crouching_Height : Height_Type;
      Prone_Height : Height_Type;
      Current_Height : Height_Type;
      Current_Weight : Weight_Type;
   end record;
   --Vel_X
   --Vel_Y
   --Bodyparts
   
   Player_Start_Soma : Soma_Type :=
      (Facing => North,
       Stance => Standing,
       Health_Points => 20,
       Health_Points_Max => 20,
       Current_Weight => 50,
       Standing_Height => 180,
       Crouching_Height => 90,
       Prone_Height => 40,
       Current_Height => 180);
   
   Player_Nothing_Soma : Soma_Type :=
      (Facing => North,
       Stance => Standing,
       Health_Points => Health_Points_Type'First,
       Health_Points_Max => Health_Points_Type'First,
       Current_Weight => Weight_Type'First,
       Standing_Height => Height_Type'First,
       Crouching_height => Height_Type'First,
       Prone_height => Height_Type'First,
       Current_height => Height_Type'First);

end corporeal;
