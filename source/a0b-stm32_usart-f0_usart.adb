--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with A0B.Callbacks.Generic_Non_Dispatching;

package body A0B.STM32_USART.F0_USART is

   use type A0B.Types.Unsigned_32;

   package On_Interrupt_Callbacks is
     new A0B.Callbacks.Generic_Non_Dispatching
           (USART_Controller, On_Interrupt);

   ------------
   -- Enable --
   ------------

   procedure Enable (Self : in out USART_Controller'Class) is
   begin
      --  Enable USART, transmitter and receiver.

      declare
         Value : A0B.Peripherals.USART.USART_CR1_Register :=
           Self.Peripheral.USART_CR1;

      begin
         Value.UE := True;
         Value.TE := True;
         Value.RE := True;

         Self.Peripheral.USART_CR1 := Value;
      end;

      --  Clear TC status flag, it has beed set by enable of TE, thus generates
      --  interrupt.
      --
      --  Clear IDLE status flag.

      Self.Peripheral.USART_ICR :=
        (TCCF | IDLECF => True, others => <>);

      --  Enable TC/IDLE interrupts.

      declare
         Value : A0B.Peripherals.USART.USART_CR1_Register :=
           Self.Peripheral.USART_CR1;

      begin
         Value.TCIE   := True;
         Value.IDLEIE := True;

         Self.Peripheral.USART_CR1 := Value;
      end;
   end Enable;

   -------------------
   -- Initialize_F0 --
   -------------------

   procedure Initialize_F0
     (Self          : in out USART_Controller'Class;
      Configuration : UART_Configuration'Class) is
   begin
      pragma Assert (not Self.Peripheral.USART_CR1.UE);

      declare
         Value : A0B.Peripherals.USART.USART_CR1_Register :=
           Self.Peripheral.USART_CR1;

      begin
         Value.UE     := False;
         --  0: USART prescaler and outputs disabled, low-power mode
         Value.UESM   := False;
         --  0: USART not able to wake up the MCU from Stop mode
         Value.RE     := False;  --  0: Receiver is disabled
         Value.TE     := False;  --  0: Transmitter is disabled
         Value.IDLEIE := False;  --  0: Interrupt is inhibited
         Value.RXNEIE := False;  --  0: Interrupt is inhibited
         Value.TCIE   := False;  --  0: Interrupt is inhibited
         Value.TXEIE  := False;  --  0: Interrupt is inhibited
         Value.PEIE   := False;  --  0: Interrupt is inhibited
         Value.PS     := Configuration.Parity = Odd;
         --    0: Even parity
         --    1: Odd parity
         Value.PCE    := Configuration.Parity /= None;
         --  0: Parity control disabled
         --  1: Parity control enabled
         Value.WAKE   := False;  --  0: Idle line
         Value.M0     := Configuration.Word_Length = 9;
         Value.MME    := False;  --  0: Receiver in active mode permanently
         Value.CMIE   := False;  --  0: Interrupt is inhibited
         Value.OVER8  := False;  --  0: Oversampling by 16
         Value.DEDT   := 0;
         Value.DEAT   := 0;
         Value.RTOIE  := False;  --  0: Interrupt is inhibited
         Value.M1     := Configuration.Word_Length = 7;
         --  M[1:0] = 00: 1 Start bit, 8 data bits, n stop bits
         --  M[1:0] = 01: 1 Start bit, 9 data bits, n stop bits
         --  M[1:0] = 10: 1 Start bit, 7 data bits, n stop bits

         Self.Peripheral.USART_CR1 := Value;
      end;

      declare
         pragma Suppress (Range_Check);

         Value : A0B.Peripherals.USART.USART_CR2_Register :=
           Self.Peripheral.USART_CR2;

      begin
         Value.ADDM7    := False;  --  <> 0: 4-bit address detection
         Value.LBDL     := False;  --  <> 0: 10-bit break detection
         Value.LBDIE    := False;  --  <> 0: Interrupt is inhibited
         Value.LBCL     := False;
         --  <> 0: The clock pulse of the last data bit is not output to the CK
         --  pin
         Value.CPHA     := False;
         --  <> 0: The first clock transition is the first data capture edge
         Value.CPOL     := False;
         --  <> 0: Steady low value on CK pin outside transmission window
         Value.CLKEN    := False;  --  <> 0: CK pin disabled
         Value.STOP     :=
           (case Configuration.Stop_Bits is
               when Stop_1   => 2#00#,   --  00: 1 stop bit
               when Stop_0_5 => 2#01#,   --  01: 0.5 stop bit
               when Stop_2   => 2#10#,   --  10: 2 stop bits
               when Stop_1_5 => 2#11#);  --  11: 1.5 stop bits
         Value.LINEN    := False;  --  0: LIN mode disabled
         Value.SWAP     := False;
         --  0: TX/RX pins are used as defined in standard pinout
         Value.RXINV    := False;
         --  0: RX pin signal works using the standard logic levels (VDD
         --  =1/idle, Gnd=0/mark)
         Value.TXINV    := False;
         --  0: TX pin signal works using the standard logic levels (VDD
         --  =1/idle, Gnd=0/mark)
         Value.DATAINV  := False;
         Value.MSBFIRST := False;
         --  0: data is transmitted/received with data bit 0 first, following
         --  the start bit.
         Value.ABREN    := False;  --  0: Auto baud rate detection is disabled.
         Value.ABRMOD   := 2#00#;
         --  <> 00: Measurement of the start bit is used to detect the baud
         --  rate.
         Value.RTOEN    := False;  --  0: Receiver timeout feature disabled.
         Value.ADD      := 0;

         Self.Peripheral.USART_CR2 := Value;
      end;

      declare
         Value : A0B.Peripherals.USART.USART_CR3_Register :=
           Self.Peripheral.USART_CR3;

      begin
         Value.EIE     := False;  --  0: Interrupt is inhibited
         Value.IREN    := False;  --  0: IrDA disabled
         Value.IRLP    := False;  --  <> 0: Normal mode
         Value.HDSEL   := False;  --  0: Half duplex mode is not selected
         Value.NACK    := False;
         --  <> 0: NACK transmission in case of parity error is disabled
         Value.SCEN    := False;  --  0: Smartcard Mode disabled
         Value.DMAR    := False;  --  0: DMA mode is disabled for reception
         Value.DMAT    := False;  --  0: DMA mode is disabled for transmission
         Value.RTSE    := False;  --  0: RTS hardware flow control disabled
         Value.CTSE    := False;  --  0: CTS hardware flow control disabled
         Value.CTSIE   := False;  --  0: Interrupt is inhibited
         Value.ONEBIT  := False;  --  0: Three sample bit method
         Value.OVRDIS  := False;
         --  0: Overrun Error Flag, ORE, is set when received data is not read
         --  before receiving new data.
         Value.DDRE    := False;
         --  0: DMA is not disabled in case of reception error. The
         --  corresponding error flag is set but RXNE is kept 0 preventing from
         --  overrun. As a consequence, the DMA request is not asserted, so
         --  the erroneous data is not transferred (no DMA request), but next
         --  correct received data are transferred (used for Smartcard mode).
         Value.DEM     := False;  --  0: DE function is disabled.
         Value.DEP     := False;  --  <> 0: DE signal is active high.
         Value.SCARCNT := 0;      --  <>
         Value.WUS     := 2#00#;
         --  00: WUF active on address match (as defined by ADD[7:0] and ADDM7)
         Value.WUFIE   := False;  --  0: Interrupt is inhibited

         Self.Peripheral.USART_CR3 := Value;
      end;

      declare
         Value : A0B.Peripherals.USART.USART_BRR_Register :=
           Self.Peripheral.USART_BRR;

      begin
         Value.BRR := Configuration.USARTDIV;

         Self.Peripheral.USART_BRR := Value;
      end;

      --  XXX USART_GTPR
      --  XXX USART_RTOR

      --  Initialize and configure DMA

      Self.Receive_Channel.Initialize;
      Self.Receive_Channel.Configure_Peripheral_To_Memory
        (Peripheral_Address   => Self.Peripheral.USART_RDR'Address,
         Peripheral_Data_Size => Word_Data_Item,
         Memory_Data_Size     => Byte_Data_Item);
      Self.Receive_Channel.Enable_Transfer_Completed_Interrupt;
      Self.Receive_Channel.Set_Transfer_Completed_Callback
        (On_Interrupt_Callbacks.Create_Callback (Self));

      Self.Transmit_Channel.Initialize;
      Self.Transmit_Channel.Configure_Memory_To_Peripheral
        (Peripheral_Address   => Self.Peripheral.USART_TDR'Address,
         Peripheral_Data_Size => Word_Data_Item,
         Memory_Data_Size     => Byte_Data_Item);
      Self.Transmit_Channel.Enable_Transfer_Completed_Interrupt;
      Self.Transmit_Channel.Set_Transfer_Completed_Callback
        (On_Interrupt_Callbacks.Create_Callback (Self));
   end Initialize_F0;

   ------------------
   -- On_Interrupt --
   ------------------

   procedure On_Interrupt (Self : in out USART_Controller'Class) is

      procedure Complete_DMA_Receive;
      --  Update state of the receive buffer, shutdown DMA receive transfer,
      --  emit callback.

      --------------------------
      -- Complete_DMA_Receive --
      --------------------------

      procedure Complete_DMA_Receive is
      begin
         Self.Receive_Buffer.Transferred :=
           Self.Receive_Buffer.Length
             - A0B.Types.Unsigned_32
                (Self.Receive_Channel.Get_Number_Of_Data_Items);
         Self.Receive_Buffer.State := A0B.Asynchronous_Operations.Success;
         Self.Receive_Buffer := null;

         Self.Peripheral.USART_CR3.DMAR := False;
         Self.Receive_Channel.Disable;

         A0B.Callbacks.Emit_Once (Self.Receive_Callback);
      end Complete_DMA_Receive;

      ISR  : constant A0B.Peripherals.USART.USART_ISR_Register :=
        Self.Peripheral.USART_ISR;
      CR1  : constant A0B.Peripherals.USART.USART_CR1_Register :=
        Self.Peripheral.USART_CR1;
      Miss : Boolean := True;

   begin
      if Self.Receive_Channel.Get_Masked_And_Clear_Transfer_Completed then
         Complete_DMA_Receive;

         Miss := False;
      end if;

      if Self.Transmit_Channel.Get_Masked_And_Clear_Transfer_Completed then
         --  Transmit DMA transfer completed, update amount of sent data in
         --  transmit buffer.

         Self.Transmit_Buffer.Transferred := Self.Transmit_Buffer.Length;

         --  Shutdown DMA for transmit

         Self.Peripheral.USART_CR3.DMAT := False;
         Self.Transmit_Channel.Disable;

         Miss := False;
      end if;

      if ISR.RXNE and CR1.RXNEIE then
         Self.Peripheral.USART_CR1.RXNEIE := False;

         if Self.Receive_Buffer.Length = 1 then
            --  For single byte buffer store received data immediately.

            declare
               use type A0B.Types.Unsigned_9;

               Byte : A0B.Types.Unsigned_8
                 with Import, Address => Self.Receive_Buffer.Buffer;

            begin
               Byte :=
                 A0B.Types.Unsigned_8
                   (Self.Peripheral.USART_RDR.RDR and 16#0_FF#);
            end;

            Self.Receive_Buffer.Transferred := 1;
            Self.Receive_Buffer.State := A0B.Asynchronous_Operations.Success;
            Self.Receive_Buffer := null;

            A0B.Callbacks.Emit_Once (Self.Receive_Callback);

         else
            --  Initiate DMA transfer for longer trasfer.

            Self.Peripheral.USART_CR3.DMAR := True;
            Self.Receive_Channel.Set_Memory
              (Memory_Address  => Self.Receive_Buffer.Buffer,
               Number_Of_Items =>
                 A0B.Types.Unsigned_16 (Self.Receive_Buffer.Length));
            Self.Receive_Channel.Enable;
         end if;

         Miss := False;
      end if;

      if ISR.IDLE then
         Self.Peripheral.USART_ICR := (IDLECF => True, others => <>);

         if Self.Receive_Buffer /= null
           and Self.Receive_Channel.Is_Enabled
         then
            Complete_DMA_Receive;
         end if;

         Miss := False;
      end if;

      if ISR.TXE and CR1.TXEIE then
         Self.Peripheral.USART_CR1.TXEIE := False;

         --  Initiate DMA transfer

         Self.Peripheral.USART_CR3.DMAT := True;
         Self.Transmit_Channel.Set_Memory
           (Memory_Address  => Self.Transmit_Buffer.Buffer,
            Number_Of_Items =>
              A0B.Types.Unsigned_16 (Self.Transmit_Buffer.Length));
         Self.Transmit_Channel.Enable;

         Miss := False;
      end if;

      if ISR.TC then
         Self.Peripheral.USART_ICR := (TCCF => True, others => <>);

         Self.Transmit_Buffer.State := A0B.Asynchronous_Operations.Success;
         Self.Transmit_Buffer := null;

         A0B.Callbacks.Emit_Once (Self.Transmit_Callback);

         Miss := False;
      end if;

      if Miss then raise Program_Error; end if;
   end On_Interrupt;

   -------------
   -- Receive --
   -------------

   procedure Receive
     (Self     : in out USART_Controller'Class;
      Buffer   :
        aliased in out A0B.Asynchronous_Operations.Transfer_Descriptor'Class;
      Finished : A0B.Callbacks.Callback;
      Success  : in out Boolean) is
   begin
      if not Success then
         return;
      end if;

      if not Self.Peripheral.USART_CR1.UE
        or Self.Receive_Buffer /= null
      then
         Success := False;

         return;
      end if;

      if Buffer.Length = 0 then
         Buffer.State       := A0B.Asynchronous_Operations.Success;
         Buffer.Transferred := 0;
         A0B.Callbacks.Emit (Finished);

         return;
      end if;

      --  Reset buffer state

      Buffer.State       := A0B.Asynchronous_Operations.Active;
      Buffer.Transferred := 0;

      --  Setup receive operation

      Self.Receive_Buffer   := Buffer'Unchecked_Access;
      Self.Receive_Callback := Finished;

      --  Enable receive interrupt

      Self.Peripheral.USART_CR1.RXNEIE := True;
   end Receive;

   --------------
   -- Transmit --
   --------------

   procedure Transmit
     (Self     : in out USART_Controller'Class;
      Buffer   :
        aliased in out A0B.Asynchronous_Operations.Transfer_Descriptor'Class;
      Finished : A0B.Callbacks.Callback;
      Success  : in out Boolean) is
   begin
      if not Success then
         return;
      end if;

      if not Self.Peripheral.USART_CR1.UE
        or Self.Transmit_Buffer /= null
      then
         Success := False;

         return;
      end if;

      if Buffer.Length = 0 then
         Buffer.State       := A0B.Asynchronous_Operations.Success;
         Buffer.Transferred := 0;
         A0B.Callbacks.Emit (Finished);

         return;
      end if;

      --  Reset buffer state

      Buffer.State       := A0B.Asynchronous_Operations.Active;
      Buffer.Transferred := 0;

      --  Setup transmit operation

      Self.Transmit_Buffer   := Buffer'Unchecked_Access;
      Self.Transmit_Callback := Finished;

      if Self.Transmit_Buffer.Length = 1 then
         --  Single byte is transmitted immediately.

         declare
            Byte : constant A0B.Types.Unsigned_8
              with Import, Address => Self.Transmit_Buffer.Buffer;

         begin
            Self.Peripheral.USART_TDR :=
              (TDR => A0B.Types.Unsigned_9 (Byte), others => <>);
         end;

      else
         --  Overwise initiate interrupt to initiate DMA/FIFO data
         --  transmission.

         Self.Peripheral.USART_CR1.TXEIE := True;
      end if;
   end Transmit;

end A0B.STM32_USART.F0_USART;
