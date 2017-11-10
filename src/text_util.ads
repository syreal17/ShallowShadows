with Ada.Characters.Handling; use Ada.Characters.Handling;

package text_util is

   function Is_MultiChar_Word_Beginning(Previous, Current, Next : Character) return Boolean;
   function Is_MultiChar_Word_Middle(Previous, Current, Next : Character) return Boolean;

end text_util;
