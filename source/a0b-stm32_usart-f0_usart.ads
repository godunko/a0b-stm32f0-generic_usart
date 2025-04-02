--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  STM32F0+ USART Generic Driver.
--
--  It supports only UART right now.

with System;

with A0B.Asynchronous_Operations;
with A0B.Callbacks;
with A0B.Peripherals.USART;
with A0B.Types;

generic
   type DMA_Data_Item_Length is private;

   Byte_Length : DMA_Data_Item_Length;

   type DMA_Channel (<>) is abstract tagged limited private;

   with procedure Initialize (Channel : in out DMA_Channel'Class);

   with procedure Configure_Peripheral_To_Memory
     (Channel              : in out DMA_Channel'Class;
      Peripheral_Address   : System.Address;
      Peripheral_Data_Size : DMA_Data_Item_Length;
      Memory_Data_Size     : DMA_Data_Item_Length);

   with procedure Configure_Memory_To_Peripheral
     (Channel              : in out DMA_Channel'Class;
      Peripheral_Address   : System.Address;
      Peripheral_Data_Size : DMA_Data_Item_Length;
      Memory_Data_Size     : DMA_Data_Item_Length);

   with procedure Set_Transfer_Completed_Callback
     (Channel  : in out DMA_Channel'Class;
      Callback : A0B.Callbacks.Callback);

   with procedure Set_Memory
     (Channel         : in out DMA_Channel'Class;
      Memory_Address  : System.Address;
      Number_Of_Items : A0B.Types.Unsigned_16);

   with procedure Enable (Channel : in out DMA_Channel'Class);

   with procedure Disable (Channel : in out DMA_Channel'Class);

   with function Is_Enabled (Channel : DMA_Channel'Class) return Boolean;

   with function Get_Number_Of_Data_Items
     (Channel : DMA_Channel'Class) return A0B.Types.Unsigned_16;

   with procedure Enable_Transfer_Completed_Interrupt
     (Channel : in out DMA_Channel'Class);

--     procedure Disable_Transfer_Completed (Self : in out DMA_Channel'Class);

   with function Get_Masked_And_Clear_Transfer_Completed
     (Channel : in out DMA_Channel'Class) return Boolean;

package A0B.STM32_USART.F0_USART
  with Preelaborate
is

   type UART_Parity is (None, Even, Odd);

   type UART_Stop_Bits is (Stop_0_5, Stop_1, Stop_1_5, Stop_2);

   type USART_Word_Length is range 7 .. 9;

   type UART_Configuration is tagged record
      Word_Length  : USART_Word_Length := 8;
      Parity       : UART_Parity       := None;
      Stop_Bits    : UART_Stop_Bits    := Stop_1;
      USARTDIV     : A0B.Types.Unsigned_16;
   end record;

   type USART_Controller
     (Peripheral       : not null access A0B.Peripherals.USART.USART_Registers;
      Receive_Channel  : not null access DMA_Channel'Class;
      Transmit_Channel : not null access DMA_Channel'Class)
   is abstract tagged limited private with Preelaborable_Initialization;

   procedure Enable (Self : in out USART_Controller'Class);

   procedure Transmit
     (Self     : in out USART_Controller'Class;
      Buffer   :
        aliased in out A0B.Asynchronous_Operations.Transfer_Descriptor'Class;
      Finished : A0B.Callbacks.Callback;
      Success  : in out Boolean);

   procedure Receive
     (Self     : in out USART_Controller'Class;
      Buffer   :
        aliased in out A0B.Asynchronous_Operations.Transfer_Descriptor'Class;
      Finished : A0B.Callbacks.Callback;
      Success  : in out Boolean);

   procedure On_Interrupt (Self : in out USART_Controller'Class);

private

   type USART_Controller
     (Peripheral       : not null access A0B.Peripherals.USART.USART_Registers;
      Receive_Channel  : not null access DMA_Channel'Class;
      Transmit_Channel : not null access DMA_Channel'Class)
   is abstract tagged limited record
      Transmit_Buffer   :
        access A0B.Asynchronous_Operations.Transfer_Descriptor'Class;
      Transmit_Callback : A0B.Callbacks.Callback;
      Receive_Buffer    :
        access A0B.Asynchronous_Operations.Transfer_Descriptor'Class;
      Receive_Callback  : A0B.Callbacks.Callback;
   end record;

   procedure Initialize_F0
     (Self          : in out USART_Controller'Class;
      Configuration : UART_Configuration'Class);

end A0B.STM32_USART.F0_USART;
