
with Message_Buffers;            use Message_Buffers;
with Peripherals_Nonblocking; use Peripherals_Nonblocking;
package body UART is
   procedure Send (This : in out Serial_Port; Text : String) is
      Outgoing : aliased Message (Physical_Size => 1024);  -- arbitrary size
   begin
      Set (Outgoing, To => Text);
      Put (This, Outgoing'Unchecked_Access);
      Await_Transmission_Complete (Outgoing);
      --  We must await xmit completion because Put does not wait
   end Send;
   procedure Init_UART is
   begin
       Initialize (COM1);
       Initialize (COM2);
       Configure (COM1, Baud_Rate => 115_200);
       Configure (COM2, Baud_Rate => 9_600);
   end Init_UART;
end UART;
