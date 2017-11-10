with Ada.Containers; use Ada.Containers; --for count_type

package game_constants with SPARK_Mode => On
is
   --mechanics
   LAYER_DEPTH : constant Natural := 10;

   --dungeon
   DUNGEON_MAX_WIDTH_X : constant Natural := 500;
   DUNGEON_MAX_WIDTH_Y : constant Natural := 500;

   --rendering
   SCREEN_WIDTH_X : constant Natural := 118;  --a little smaller than actual console default to leave room for line feed.
   SCREEN_WIDTH_Y : constant Natural := 28;   --a little smaller than actual console default to leave room for player input
   SCREEN_AREA : constant Natural := (SCREEN_WIDTH_X + 1 + 1) * (SCREEN_WIDTH_Y + 1);
   SCREEN_AREA_W_MORE_MESSAGE_ROOM : constant Natural := (SCREEN_WIDTH_X +1 +1) * (SCREEN_WIDTH_Y -2);
   SCREEN_AREA_WO_LF_W_MORE_MESSAGE_ROOM : constant Natural := (SCREEN_WIDTH_X + 1) * (SCREEN_WIDTH_Y - 2);
   SCREEN_AREA_WO_HYPHEN_W_MORE_MESSAGE_ROOM : constant Natural := (SCREEN_WIDTH_X) * (SCREEN_WIDTH_Y - 2); --minus 2 for room for "more messages" message
   MAX_FULL_RENDER_MAP_UPDATES : constant Count_Type := Count_Type(DUNGEON_MAX_WIDTH_Y) * Count_Type(DUNGEON_MAX_WIDTH_X); --theoretical max is every square in dungeon changing at once
   MAX_ILLUMINATION_SOURCES : constant Count_Type := 500; --totally arbitrary number
   MAX_TEXT_MSGS_AT_ONCE : constant Count_Type := 100; --totally arbitrary number
   UNPROCESSED_TEXT_MESSAGE_MAX_LENGTH : constant Natural := SCREEN_AREA_WO_HYPHEN_W_MORE_MESSAGE_ROOM;
   PROCESSED_TEXT_MESSAGE_MAX_LENGTH : constant Natural := SCREEN_AREA_W_MORE_MESSAGE_ROOM;
   ANSI_FG_COLOR_CODE_LENGTH : constant Natural := 11; --this is for 256 colors
   ANSI_BG_COLOR_CODE_LENGTH : constant Natural := 11; --this is for 256 colors
      ANSI_COLOR_CODE_LENGTH : constant Natural := ANSI_FG_COLOR_CODE_LENGTH + ANSI_BG_COLOR_CODE_LENGTH;
   RENDER_BUFFER_LENGTH : constant Natural := SCREEN_AREA;
   RENDER_COLOR_BUFFER_LENGTH : constant Natural :=  SCREEN_AREA + SCREEN_AREA*ANSI_COLOR_CODE_LENGTH;
   RENDER_TEMP_COLOR_BUFFER_LENGTH : constant Natural :=  SCREEN_AREA + SCREEN_AREA*ANSI_COLOR_CODE_LENGTH + ANSI_COLOR_CODE_LENGTH;

end game_constants;
