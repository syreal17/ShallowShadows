with SPARK.Text_IO; use SPARK.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with ADa.Containers.Formal_Doubly_Linked_Lists; use Ada.Containers;
with ada.Strings.fixed;

with spatial; use spatial;
with level; use level;
with corporeal; use corporeal;
with player; use player;
with rendering; use rendering;
with game_constants; use game_constants;
with bresenham; use bresenham;
with dungeon; use dungeon;
with item; use item;
with illumination; use illumination;
with fov; use fov;
with text_messages; use text_messages;
with screen; use screen;

package render with SPARK_Mode => On
is
   
   procedure Render_Dungeon
   with Global => (In_Out => (Standard_Output, Terrain_Layer, Screen_Instance, Standard_Input),
                   Input => (Player_Abstract_Instance, TM_more_messages,
                             Player_Layer, Player_Concrete_Nothing, 
                             Illumination_Sources, Item_Layer, No_Item_Concrete)),
        Pre    => Is_Writable (Standard_Output);
        
   procedure Render_Dungeon_Color
   with Global => (In_Out => (Standard_Output, Terrain_Layer, Screen_Instance, Standard_Input),
                   Input => (Player_Abstract_Instance, TM_more_messages,
                             Player_Layer, Player_Concrete_Nothing, 
                             Illumination_Sources, Item_Layer, No_Item_Concrete)),
        Pre    => Is_Writable (Standard_Output);
        
   function Get_Tile(Pos : Pos_Type; Illuminated : Boolean; Discovered : Boolean; Seen : Boolean) return Tile_Type
   with Global => (Input => (Player_Layer, Player_Concrete_Nothing, 
                             Terrain_Layer, Item_Layer, No_Item_Concrete));
                             
   function Get_Color_Code(Pos : Pos_Type; Illuminated : Boolean; Discovered : Boolean; Seen : Boolean) return String
   with Global => (Input => (Player_Layer, Player_Concrete_Nothing, 
                             Terrain_Layer, Item_Layer, No_Item_Concrete));
                             
   procedure Overlay_Queued_Texts(buffer : in out String; done, is_messages_to_print : out Boolean)
   with Global => (In_Out => (Screen_Instance),
                   Input => (TM_more_messages));
   
   procedure Overlay_Buffer_Text_message_rev(buffer : in out String; TM : Text_Message_Type; Lines_Used : Natural)
   with Global => null;
   
   TM_more_messages : Text_Message_type := Construct_Message("(more messages - press Enter to continue)");

end render;
