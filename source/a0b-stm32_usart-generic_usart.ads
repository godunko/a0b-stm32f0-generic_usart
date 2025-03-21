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

package A0B.STM32_USART.Generic_USART
  with Pure
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
     (Peripheral : not null access A0B.Peripherals.USART.USART_Registers)
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

   not overriding procedure Initiate_DMA_Transmit
     (Self   : in out USART_Controller;
      Buffer : System.Address;
      Length : A0B.Types.Unsigned_32) is abstract;

   not overriding function Is_DMA_Transmit_Completed
     (Self : in out USART_Controller) return Boolean is abstract;

   not overriding procedure Complete_DMA_Transmit
     (Self : in out USART_Controller) is abstract;

   not overriding procedure Initiate_DMA_Receive
     (Self   : in out USART_Controller;
      Buffer : System.Address;
      Length : A0B.Types.Unsigned_32) is abstract;

   not overriding procedure Complete_DMA_Receive
     (Self : in out USART_Controller) is abstract;

   not overriding function Is_DMA_Receive_Enabled
     (Self : in out USART_Controller) return Boolean is abstract;

   not overriding function Is_DMA_Receive_Completed
     (Self : in out USART_Controller) return Boolean is abstract;

   not overriding function Get_DMA_Remain_Receive
     (Self : in out USART_Controller) return A0B.Types.Unsigned_32 is abstract;

private

   type USART_Controller
     (Peripheral : not null access A0B.Peripherals.USART.USART_Registers)
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

end A0B.STM32_USART.Generic_USART;
