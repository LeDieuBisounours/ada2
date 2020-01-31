with Serial_IO.Nonblocking; use Serial_IO.Nonblocking;

package UART is
   procedure Send (This : in out Serial_Port; Text : String);
   procedure Init_UART with inline;
end UART;
