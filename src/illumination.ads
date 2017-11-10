with SPARK.Text_IO; use SPARK.Text_IO;
with Ada.Containers.Formal_Doubly_Linked_Lists; use Ada.Containers;

with bresenham; use bresenham;
with spatial; use spatial;
with game_constants; use game_constants;
with item; use item;

package illumination is

   function Is_Illuminated(Pos : Pos_Type) return Boolean;

   package Illumination_Sources_Type is new Ada.Containers.Formal_Doubly_Linked_Lists
      (Element_Type => Item_Abstract_Type);
      
   Illumination_Sources : Illumination_Sources_Type.List(MAX_ILLUMINATION_SOURCES);

end illumination;
