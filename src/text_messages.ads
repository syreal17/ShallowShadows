with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

with game_constants; use game_constants;
with text_util; use text_util;

package text_messages with SPARK_Mode => On is

   --really need to have unified placement at least to start
   --type Placement_Type is (High, Low);

   type Text_Message_type is private;

   function Construct_Message(message : String) return Text_Message_Type
   with Global => null,
        Pre => message'Length < UNPROCESSED_TEXT_MESSAGE_MAX_LENGTH;

   function Get_Message(TM : Text_Message_type) return String
   with Global => null;

   function Get_Message_Length(TM : Text_Message_type) return Natural
   with Global => null;

   function Get_Message_Lines(TM : Text_Message_type) return Natural
   with Global => null;

   --private part for processing message on the DL
   private

      type Text_Message_Type is
      record
         --really need to have unified placement at least to start
         --Placement : Placement_Type;
         Unprocessed_Message : String(1 .. UNPROCESSED_TEXT_MESSAGE_MAX_LENGTH); --the screen area without the line feed, so max size of message without the line feeds.
         Processed_Message : String(1 .. PROCESSED_TEXT_MESSAGE_MAX_LENGTH); --anything longer than one screenful gets automatically converted into multiple messages
         Processed_Lines : Natural; --how many console lines the message takes
      end record;

      No_Text_message : Text_Message_type :=
         (Unprocessed_Message => (others=>NUL),
          Processed_Message => (others=>NUL),
          Processed_Lines => 0);

      procedure Process_Message(TM : in out Text_Message_Type)
      with Global => null;
end text_messages;
