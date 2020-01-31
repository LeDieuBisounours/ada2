------------------------------------------------------------------------------
--                                                                          --
--                    Copyright (C) 2015-2016, AdaCore                      --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

--  A demonstration of a higher-level USART interface, using non-blocking I/O.
--  The file declares the main procedure for the demonstration.

with Last_Chance_Handler;  pragma Unreferenced (Last_Chance_Handler);
--  The "last chance handler" is the user-defined routine that is called when
--  an exception is propagated. We need it in the executable, therefore it
--  must be somewhere in the closure of the context clauses.

with STM32.Device;    use STM32.Device;
with STM32.GPIO; use STM32.GPIO;
with Serial_IO.Nonblocking; use Serial_IO.Nonblocking;

--with STM32.Timers;    use STM32.Timers;
with Message_Buffers;            use Message_Buffers;
with Timer_Interrupts;  use Timer_Interrupts;
with Peripherals_Nonblocking; Use Peripherals_Nonblocking;
with UART; use UART;

procedure Demo_Serial_Port_Nonblocking is

   Incoming : aliased Message (Physical_Size => 1024);  -- arbitrary size
   cmdString : String (1.. 2);
   type CmdInt is range 0 .. 255;
   type CmdValue is array (1 .. 4) of CmdInt;
   readDist : constant CmdValue :=  (34, 0, 0, 34);--44, 2, 170, 240); -- 0x22 0x00 0x00 0x22
   LastVal: Boolean := False;
   CurrVal: Boolean;




begin
   --Setup
   Init_UART;
   --Enable_Clock(PA1);
   Enable_Clock(PE9); --echo
   Enable_Clock(PE10); -- comp/trig
   Enable_Clock(PE11); -- dac
   Configure_IO(PE9,
                Config => (
                           Mode => Mode_In,
                           Resistors => Pull_Down
                          )
              );
   Configure_IO(PE10,
                Config => (
                           Mode => Mode_Out,
                           Resistors => Pull_Up
                          )
               );
   PE10.Set;

   --loop
   loop
      PE10.Clear;
      PE10.Set;
      for k in range (1 .. 20) loop


         CurrVal:= PE9.Set;
         if CurrVal then
            cmdString := "O";
         else
            cmdString := "X";
            end if;
            Send(COM1, cmdString);
         end loop;
         delay 1.0;

      end loop;

 --  Configure_IO(PA1,
 --               Config => (
 --                          Mode => Mode_In,
 --                          Resistors => Pull_Down
 --                         )
 --              );

   --Send (COM1, "Hello world !.");
--   delay 2.0;
 --     Send (COM1, "Hello world2 !.");

 --  for k in readDist'Range loop
      cmdString(1) := Character'Val(readDist(k));
      Send(COM2, cmdString);
   end loop;

 --   Get (COM2, Incoming'Unchecked_Access);
--   Await_Reception_Complete (Incoming);
--   Send (COM1, "Received : " & Content (Incoming));

   --Lock(PA1);

--   Enable_Clock(Timer_7);
--   Reset(Timer_7);
--   Configure(Timer_7, Prescaler => 13999, Period => 5999);
--   Enable_Interrupt(Timer_7, Timer_Update_Interrupt);
--   Enable(Timer_7);

   --Counter := 0;
   -- Send (COM1, cmdString);
   --Send(COM2, cmdString);

  loop
    CurrVal := PA1.Set;
      if CurrVal then
         Send(COM1, "true");
         else
         Send(COM1,  "false");
         end if;
   --      if CurrVal xor LastVal then

        -- if Counter = 0 t
        -- end if;
      --   Counter := Counter + 1;
        -- LastVal := CurrVal;
      --end if;

   end loop;
--  loop
--     Get (COM1, Incoming'Unchecked_Access);
--   Await_Reception_Complete (Incoming);
--     --  We must await reception completion because Get does not wait
--
--     Send (COM1, "Received : " & Content (Incoming));
--  end loop;
end Demo_Serial_Port_Nonblocking;

