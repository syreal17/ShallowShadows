with rendering; use rendering;
with game_constants; use game_constants;
with spatial; use spatial;

package item is
   pragma Elaborate_Body;

   type Item_Type is
   record
      Render : Item_Render;
   end record;
   
   type Item_Abstract_Type is
   record
      Pos : Pos_Type;
      Illumination_Distance : Natural;
   end record;
   
   No_Item_Concrete : Item_Type :=
      (Render => No_Item_Render);
   
   Torch_Item_Concrete : Item_Type :=
      (Render => Torch_Item_Render);
      
   Torch_Item_Abstract : Item_Abstract_Type :=
      (Pos => Item_Default_Pos,
       Illumination_Distance => 10);
       
   type Item_Layer_Type is array (Positive range Y_Pos_Type'First .. Y_Pos_Type'Last, Positive range X_Pos_Type'First .. X_Pos_Type'Last) of Item_Type;
   
   Item_Layer : Item_Layer_Type;

end item;
