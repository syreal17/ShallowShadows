with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with game_constants; use game_constants;

package rendering is

   subtype Tile_Type is Character range Character'Val(0) .. Character'Val(254);
   type Linear_ANSI_Colors is array(Positive range 1 .. SCREEN_AREA) of String(1..ANSI_COLOR_CODE_LENGTH);

   --Player
   type Player_Render is
   record
      illuminated_fg_color : String(1..ANSI_FG_COLOR_CODE_LENGTH);
      darkened_fg_color : String(1..ANSI_FG_COLOR_CODE_LENGTH);
      bg_color : String(1..ANSI_BG_COLOR_CODE_LENGTH);
      standing_tile : Tile_Type;
      crouch_prone_tile : Tile_Type;
   end record;

   --monsters, NPC render
   type Creature_Render is
   record
      illuminated_fg_color : String(1..ANSI_FG_COLOR_CODE_LENGTH);
      darkened_fg_color : String(1..ANSI_FG_COLOR_CODE_LENGTH);
      bg_color : String(1..ANSI_BG_COLOR_CODE_LENGTH);
      standing_tile : Tile_type;
      crouch_prone_tile : Tile_Type;
   end record;
   
   --Brick and Mortar render
   type Terrain_Render is
   record
      Extended_LOS : boolean;
      illuminated_fg_color : String(1..ANSI_FG_COLOR_CODE_LENGTH);
      illuminated_bg_color : String(1..ANSI_BG_COLOR_CODE_LENGTH);
      darkened_fg_color : String(1..ANSI_FG_COLOR_CODE_LENGTH);
      darkened_bg_color : String(1..ANSI_BG_COLOR_CODE_LENGTH);
      undiscovered_unseen_tile : Tile_Type; --use for like remembering a dungeon from your past
      discovered_unseen_tile : Tile_Type;
      discovered_seen_illuminated_tile : Tile_Type;
      discovered_seen_darkened_tile : Tile_Type;
      --undiscovered_seen_tile : Tile_Type; --use for a dungeon of amnesia
   end record;
   
   type Furniture_Render is
   record
      whole_tile : Tile_Type;
      broken_tile : Tile_Type;
   end record;
   
   type Item_Render is
   record
      illuminated_fg_color : String(1..ANSI_FG_COLOR_CODE_LENGTH);
      illuminated_bg_color : string(1..ANSI_BG_COLOR_CODE_LENGTH);
      darkened_fg_color : String(1..ANSI_FG_COLOR_CODE_LENGTH);
      darkened_bg_color : String(1..ANSI_BG_COLOR_CODE_LENGTH);
      seen_tile : Tile_Type;
      unseen_tile : Tile_Type;
   end record;
   
   Empty_Color_Code : String(1..ANSI_COLOR_CODE_LENGTH) := "" & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL & NUL &NUL & NUL;
   
   LF_Color : String(1..ANSI_COLOR_CODE_LENGTH) := Character'Val(27) & "[38;5;255m" & Character'Val(27) & "[48;5;000m"; --TODO; rename
   
   Player_Render_Instance : Player_Render :=
      (illuminated_fg_color => Character'Val(27) & "[38;5;255m",
       darkened_fg_color => Character'Val(27) & "[38;5;012m",
       bg_color => Character'Val(27) & "[48;5;000m",
       standing_tile => 'U',
       crouch_prone_tile => 'u');
   
   Player_Nothing_Render : Player_Render :=
      (illuminated_fg_color => Character'Val(27) & "[38;5;000m",
       darkened_fg_color => Character'Val(27) & "[38;5;000m",
       bg_color => Character'Val(27) & "[48;5;000m",
       standing_tile => ' ',
       crouch_prone_tile => ' ');
       
   Torch_Item_Render : Item_Render :=
      (illuminated_fg_color => Character'Val(27) & "[38;5;011m",
       illuminated_bg_color => Character'Val(27) & "[48;5;000m",
       darkened_fg_color => Character'Val(27) & "[38;5;255m",
       darkened_bg_color => Character'Val(27) & "[48;5;000m",
       seen_tile => '/',
       unseen_tile => ' ');
      
   No_Item_Render : Item_Render :=
      (illuminated_fg_color => Character'Val(27) & "[38;5;000m",
       illuminated_bg_color => Character'Val(27) & "[48;5;000m",
       darkened_fg_color => Character'Val(27) & "[38;5;000m",
       darkened_bg_color => Character'Val(27) & "[48;5;000m",
       seen_tile => ' ',
       unseen_tile => ' ');
       
   Wall_Render_win : Terrain_Render :=
      (Extended_LOS => True,
       illuminated_fg_color => Character'Val(27) & "[38;5;015m",
       illuminated_bg_color => Character'Val(27) & "[48;5;247m",
       darkened_fg_color => Character'Val(27) & "[38;5;000m",
       darkened_bg_color => Character'Val(27) & "[48;5;238m",
       undiscovered_unseen_tile => ' ',
       discovered_unseen_tile => Character'Val(178),
       discovered_seen_illuminated_tile => Character'Val(219),
       discovered_seen_darkened_tile => Character'Val(178));
       --undiscovered_seen_tile => Character'Val(219));
       
   Wall_Render : Terrain_Render :=
      (Extended_LOS => True,
       illuminated_fg_color => Character'Val(27) & "[38;5;015m",
       illuminated_bg_color => Character'Val(27) & "[48;5;247m",
       darkened_fg_color => Character'Val(27) & "[38;5;000m",
       darkened_bg_color => Character'Val(27) & "[48;5;238m",
       undiscovered_unseen_tile => ' ',
       discovered_unseen_tile => '#',
       discovered_seen_illuminated_tile => '#',
       discovered_seen_darkened_tile => '#');
       --undiscovered_seen_tile => Character'Val(219));
       
   WallHoleN_Render : Terrain_Render :=
      (Extended_LOS => True,
       illuminated_fg_color => Character'Val(27) & "[38;5;015m",
       illuminated_bg_color => Character'Val(27) & "[48;5;247m",
       darkened_fg_color => Character'Val(27) & "[38;5;000m",
       darkened_bg_color => Character'Val(27) & "[48;5;238m",
       undiscovered_unseen_tile => ' ',
       discovered_unseen_tile => 's',
       discovered_seen_illuminated_tile => 's',
       discovered_seen_darkened_tile => 's');
       
   WallHoleS_Render : Terrain_Render :=
      (Extended_LOS => True,
       illuminated_fg_color => Character'Val(27) & "[38;5;015m",
       illuminated_bg_color => Character'Val(27) & "[48;5;247m",
       darkened_fg_color => Character'Val(27) & "[38;5;000m",
       darkened_bg_color => Character'Val(27) & "[48;5;238m",
       undiscovered_unseen_tile => ' ',
       discovered_unseen_tile => 's',
       discovered_seen_illuminated_tile => 's',
       discovered_seen_darkened_tile => 's');
       
   WallHoleW_Render : Terrain_Render :=
      (Extended_LOS => True,
       illuminated_fg_color => Character'Val(27) & "[38;5;015m",
       illuminated_bg_color => Character'Val(27) & "[48;5;247m",
       darkened_fg_color => Character'Val(27) & "[38;5;000m",
       darkened_bg_color => Character'Val(27) & "[48;5;238m",
       undiscovered_unseen_tile => ' ',
       discovered_unseen_tile => 's',
       discovered_seen_illuminated_tile => 's',
       discovered_seen_darkened_tile => 's');
        
       
   WallHoleE_Render : Terrain_Render :=
      (Extended_LOS => True,
       illuminated_fg_color => Character'Val(27) & "[38;5;015m",
       illuminated_bg_color => Character'Val(27) & "[48;5;247m",
       darkened_fg_color => Character'Val(27) & "[38;5;000m",
       darkened_bg_color => Character'Val(27) & "[48;5;238m",
       undiscovered_unseen_tile => ' ',
       discovered_unseen_tile => 's',
       discovered_seen_illuminated_tile => 's',
       discovered_seen_darkened_tile => 's');
       
   Window_Render : Terrain_Render :=
      (Extended_LOS => True,
       illuminated_fg_color => Character'Val(27) & "[38;5;015m",
       illuminated_bg_color => Character'Val(27) & "[48;5;000m",
       darkened_fg_color => Character'Val(27) & "[38;5;238m",
       darkened_bg_color => Character'Val(27) & "[48;5;000m",
       undiscovered_unseen_tile => ' ',
       discovered_unseen_tile => '#',
       discovered_seen_illuminated_tile => '#',
       discovered_seen_darkened_tile => '#');
       --undiscovered_seen_tile => '#');
       
   Floor_Render : Terrain_Render :=
      (Extended_LOS => False,
       illuminated_fg_color => Character'Val(27) & "[38;5;015m",
       illuminated_bg_color => Character'Val(27) & "[48;5;000m",
       darkened_fg_color => Character'Val(27) & "[38;5;012m",
       darkened_bg_color => Character'Val(27) & "[48;5;000m",
       undiscovered_unseen_tile => ' ',
       discovered_unseen_tile => ' ',
       discovered_seen_illuminated_tile => ':',
       discovered_seen_darkened_tile => '.');
       --undiscovered_seen_tile => '.');
       
   Nothing_Render : Terrain_Render :=
      (Extended_LOS => False,
       illuminated_fg_color => Character'Val(27) & "[38;5;000m",
       illuminated_bg_color => Character'Val(27) & "[48;5;000m",
       darkened_fg_color => Character'Val(27) & "[38;5;000m",
       darkened_bg_color => Character'Val(27) & "[48;5;000m",
       undiscovered_unseen_tile => ' ',
       discovered_unseen_tile => ' ',
       discovered_seen_illuminated_tile => ' ',
       discovered_seen_darkened_tile => ' ');
       --undiscovered_seen_tile => ' ');

end rendering;
