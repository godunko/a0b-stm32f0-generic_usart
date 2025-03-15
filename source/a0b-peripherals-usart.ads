--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  STM32F0 USART [RM0091]

pragma Ada_2022;

with A0B.Types;

package A0B.Peripherals.USART
  with Pure, No_Elaboration_Code_All
is

   USART_CR1_Offset  : constant := 16#00#;
   USART_CR2_Offset  : constant := 16#04#;
   USART_CR3_Offset  : constant := 16#08#;
   USART_BRR_Offset  : constant := 16#0C#;
   USART_GTPR_Offset : constant := 16#10#;
   USART_RTOR_Offset : constant := 16#14#;
   USART_RQR_Offset  : constant := 16#18#;
   USART_ISR_Offset  : constant := 16#1C#;
   USART_ICR_Offset  : constant := 16#20#;
   USART_RDR_Offset  : constant := 16#24#;
   USART_TDR_Offset  : constant := 16#28#;

   ---------------
   -- USART_BRR --
   ---------------

   type USART_BRR_Register is record
      BRR            : A0B.Types.Unsigned_16;
      Reserved_16_31 : A0B.Types.Reserved_16;
   end record with Size => 32;

   for USART_BRR_Register use record
      BRR            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   ---------------
   -- USART_CR1 --
   ---------------

   type USART_CR1_Register is record
      UE             : Boolean;
      UESM           : Boolean;
      RE             : Boolean;
      TE             : Boolean;
      IDLEIE         : Boolean;
      RXNEIE         : Boolean;
      TCIE           : Boolean;
      TXEIE          : Boolean;
      PEIE           : Boolean;
      PS             : Boolean;
      PCE            : Boolean;
      WAKE           : Boolean;
      M0             : Boolean;
      MME            : Boolean;
      CMIE           : Boolean;
      OVER8          : Boolean;
      DEDT           : A0B.Types.Unsigned_5;
      DEAT           : A0B.Types.Unsigned_5;
      RTOIE          : Boolean;
      EOBIE          : Boolean;
      M1             : Boolean;
      Reserved_29_31 : A0B.Types.Reserved_3;
   end record with Size => 32;

   for USART_CR1_Register use record
      UE             at 0 range 0 .. 0;
      UESM           at 0 range 1 .. 1;
      RE             at 0 range 2 .. 2;
      TE             at 0 range 3 .. 3;
      IDLEIE         at 0 range 4 .. 4;
      RXNEIE         at 0 range 5 .. 5;
      TCIE           at 0 range 6 .. 6;
      TXEIE          at 0 range 7 .. 7;
      PEIE           at 0 range 8 .. 8;
      PS             at 0 range 9 .. 9;
      PCE            at 0 range 10 .. 10;
      WAKE           at 0 range 11 .. 11;
      M0             at 0 range 12 .. 12;
      MME            at 0 range 13 .. 13;
      CMIE           at 0 range 14 .. 14;
      OVER8          at 0 range 15 .. 15;
      DEDT           at 0 range 16 .. 20;
      DEAT           at 0 range 21 .. 25;
      RTOIE          at 0 range 26 .. 26;
      EOBIE          at 0 range 27 .. 27;
      M1             at 0 range 28 .. 28;
      Reserved_29_31 at 0 range 29 .. 31;
   end record;

   ---------------
   -- USART_CR2 --
   ---------------

   type USART_CR2_Register is record
      Reserved_0_3 : A0B.Types.Reserved_4;
      ADDM7        : Boolean;
      LBDL         : Boolean;
      LBDIE        : Boolean;
      Reserved_7   : A0B.Types.Reserved_1;
      LBCL         : Boolean;
      CPHA         : Boolean;
      CPOL         : Boolean;
      CLKEN        : Boolean;
      STOP         : A0B.Types.Unsigned_2;
      LINEN        : Boolean;
      SWAP         : Boolean;
      RXINV        : Boolean;
      TXINV        : Boolean;
      DATAINV      : Boolean;
      MSBFIRST     : Boolean;
      ABREN        : Boolean;
      ABRMOD       : A0B.Types.Unsigned_2;
      RTOEN        : Boolean;
      ADD          : A0B.Types.Unsigned_8;
   end record with Size => 32;

   for USART_CR2_Register use record
      Reserved_0_3 at 0 range 0 .. 3;
      ADDM7        at 0 range 4 .. 4;
      LBDL         at 0 range 5 .. 5;
      LBDIE        at 0 range 6 .. 6;
      Reserved_7   at 0 range 7 .. 7;
      LBCL         at 0 range 8 .. 8;
      CPHA         at 0 range 9 .. 9;
      CPOL         at 0 range 10 .. 10;
      CLKEN        at 0 range 11 .. 11;
      STOP         at 0 range 12 .. 13;
      LINEN        at 0 range 14 .. 14;
      SWAP         at 0 range 15 .. 15;
      RXINV        at 0 range 16 .. 16;
      TXINV        at 0 range 17 .. 17;
      DATAINV      at 0 range 18 .. 18;
      MSBFIRST     at 0 range 19 .. 19;
      ABREN        at 0 range 20 .. 20;
      ABRMOD       at 0 range 21 .. 22;
      RTOEN        at 0 range 23 .. 23;
      ADD          at 0 range 24 .. 31;
   end record;

   ---------------
   -- USART_CR3 --
   ---------------

   type USART_CR3_Register is record
      EIE            : Boolean;
      IREN           : Boolean;
      IRLP           : Boolean;
      HDSEL          : Boolean;
      NACK           : Boolean;
      SCEN           : Boolean;
      DMAR           : Boolean;
      DMAT           : Boolean;
      RTSE           : Boolean;
      CTSE           : Boolean;
      CTSIE          : Boolean;
      ONEBIT         : Boolean;
      OVRDIS         : Boolean;
      DDRE           : Boolean;
      DEM            : Boolean;
      DEP            : Boolean;
      Reserved_16    : A0B.Types.Reserved_1;
      SCARCNT        : A0B.Types.Unsigned_3;
      WUS            : A0B.Types.Unsigned_2;
      WUFIE          : Boolean;
      Reserved_23_31 : A0B.Types.Reserved_9;
   end record with Size => 32;

   for USART_CR3_Register use record
      EIE            at 0 range 0 .. 0;
      IREN           at 0 range 1 .. 1;
      IRLP           at 0 range 2 .. 2;
      HDSEL          at 0 range 3 .. 3;
      NACK           at 0 range 4 .. 4;
      SCEN           at 0 range 5 .. 5;
      DMAR           at 0 range 6 .. 6;
      DMAT           at 0 range 7 .. 7;
      RTSE           at 0 range 8 .. 8;
      CTSE           at 0 range 9 .. 9;
      CTSIE          at 0 range 10 .. 10;
      ONEBIT         at 0 range 11 .. 11;
      OVRDIS         at 0 range 12 .. 12;
      DDRE           at 0 range 13 .. 13;
      DEM            at 0 range 14 .. 14;
      DEP            at 0 range 15 .. 15;
      Reserved_16    at 0 range 16 .. 16;
      SCARCNT        at 0 range 17 .. 19;
      WUS            at 0 range 20 .. 21;
      WUFIE          at 0 range 22 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   ----------------
   -- USART_GTPR --
   ----------------

   type USART_GTPR_Register is record
      PSC            : A0B.Types.Unsigned_8;
      GT             : A0B.Types.Unsigned_8;
      Reserved_16_31 : A0B.Types.Reserved_16;
   end record with Size => 32;

   for USART_GTPR_Register use record
      PSC            at 0 range 0 .. 7;
      GT             at 0 range 8 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   ---------------
   -- USART_ICR --
   ---------------

   type USART_ICR_Register is record
      PECF           : Boolean;
      FECF           : Boolean;
      NCF            : Boolean;
      ORECF          : Boolean;
      IDLECF         : Boolean;
      Reserved_5     : A0B.Types.Reserved_1;
      TCCF           : Boolean;
      Reserved_7     : A0B.Types.Reserved_1;
      LBDCF          : Boolean;
      CTSCF          : Boolean;
      Reserved_10    : A0B.Types.Reserved_1;
      RTOCF          : Boolean;
      EOBCF          : Boolean;
      Reserved_13_16 : A0B.Types.Reserved_4;
      CMCF           : Boolean;
      Reserved_18_19 : A0B.Types.Reserved_2;
      WUCF           : Boolean;
      Reserved_21_31 : A0B.Types.Reserved_11;
   end record with Size => 32;

   for USART_ICR_Register use record
      PECF           at 0 range 0 .. 0;
      FECF           at 0 range 1 .. 1;
      NCF            at 0 range 2 .. 2;
      ORECF          at 0 range 3 .. 3;
      IDLECF         at 0 range 4 .. 4;
      Reserved_5     at 0 range 5 .. 5;
      TCCF           at 0 range 6 .. 6;
      Reserved_7     at 0 range 7 .. 7;
      LBDCF          at 0 range 8 .. 8;
      CTSCF          at 0 range 9 .. 9;
      Reserved_10    at 0 range 10 .. 10;
      RTOCF          at 0 range 11 .. 11;
      EOBCF          at 0 range 12 .. 12;
      Reserved_13_16 at 0 range 13 .. 16;
      CMCF           at 0 range 17 .. 17;
      Reserved_18_19 at 0 range 18 .. 19;
      WUCF           at 0 range 20 .. 20;
      Reserved_21_31 at 0 range 21 .. 31;
   end record;

   ---------------
   -- USART_ISR --
   ---------------

   type USART_ISR_Register is record
      PE             : Boolean;
      FE             : Boolean;
      NF             : Boolean;
      ORE            : Boolean;
      IDLE           : Boolean;
      RXNE           : Boolean;
      TC             : Boolean;
      TXE            : Boolean;
      LBDF           : Boolean;
      CTSIF          : Boolean;
      CTS            : Boolean;
      RTOF           : Boolean;
      EOBF           : Boolean;
      Reserved_13    : A0B.Types.Reserved_1;
      ABRE           : Boolean;
      ABRF           : Boolean;
      BUSY           : Boolean;
      CMF            : Boolean;
      SBKF           : Boolean;
      RWU            : Boolean;
      WUF            : Boolean;
      TEACK          : Boolean;
      REACK          : Boolean;
      Reserved_23_31 : A0B.Types.Reserved_9;
   end record with Size => 32;

   for USART_ISR_Register use record
      PE             at 0 range 0 .. 0;
      FE             at 0 range 1 .. 1;
      NF             at 0 range 2 .. 2;
      ORE            at 0 range 3 .. 3;
      IDLE           at 0 range 4 .. 4;
      RXNE           at 0 range 5 .. 5;
      TC             at 0 range 6 .. 6;
      TXE            at 0 range 7 .. 7;
      LBDF           at 0 range 8 .. 8;
      CTSIF          at 0 range 9 .. 9;
      CTS            at 0 range 10 .. 10;
      RTOF           at 0 range 11 .. 11;
      EOBF           at 0 range 12 .. 12;
      Reserved_13    at 0 range 13 .. 13;
      ABRE           at 0 range 14 .. 14;
      ABRF           at 0 range 15 .. 15;
      BUSY           at 0 range 16 .. 16;
      CMF            at 0 range 17 .. 17;
      SBKF           at 0 range 18 .. 18;
      RWU            at 0 range 19 .. 19;
      WUF            at 0 range 20 .. 20;
      TEACK          at 0 range 21 .. 21;
      REACK          at 0 range 22 .. 22;
      Reserved_23_31 at 0 range 23 .. 31;
   end record;

   ---------------
   -- USART_RDR --
   ---------------

   type USART_RDR_Register is record
      RDR           : A0B.Types.Unsigned_9;
      Reserved_9_31 : A0B.Types.Reserved_23;
   end record with Size => 32;

   for USART_RDR_Register use record
      RDR           at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   ---------------
   -- USART_RQR --
   ---------------

   type USART_RQR_Register is record
      ABRRQ         : Boolean;
      SBKRQ         : Boolean;
      MMRQ          : Boolean;
      RXFRQ         : Boolean;
      TXFRQ         : Boolean;
      Reserved_5_31 : A0B.Types.Reserved_27;
   end record with Size => 32;

   for USART_RQR_Register use record
      ABRRQ         at 0 range 0 .. 0;
      SBKRQ         at 0 range 1 .. 1;
      MMRQ          at 0 range 2 .. 2;
      RXFRQ         at 0 range 3 .. 3;
      TXFRQ         at 0 range 4 .. 4;
      Reserved_5_31 at 0 range 5 .. 31;
   end record;

   ----------------
   -- USART_RTOR --
   ----------------

   type USART_RTOR_Register is record
      RTO  : A0B.Types.Unsigned_24;
      BLEN : A0B.Types.Unsigned_8;
   end record with Size => 32;

   for USART_RTOR_Register use record
      RTO  at 0 range 0 .. 23;
      BLEN at 0 range 24 .. 31;
   end record;

   ---------------
   -- USART_TDR --
   ---------------

   type USART_TDR_Register is record
      TDR           : A0B.Types.Unsigned_9;
      Reserved_9_31 : A0B.Types.Reserved_23;
   end record with Size => 32;

   for USART_TDR_Register use record
      TDR           at 0 range 0 .. 8;
      Reserved_9_31 at 0 range 9 .. 31;
   end record;

   -----------
   -- USART --
   -----------

   type USART_Registers is record
      USART_CR1  : USART_CR1_Register  with Volatile, Full_Access_Only;
      USART_CR2  : USART_CR2_Register  with Volatile, Full_Access_Only;
      USART_CR3  : USART_CR3_Register  with Volatile, Full_Access_Only;
      USART_BRR  : USART_BRR_Register  with Volatile, Full_Access_Only;
      USART_GTPR : USART_GTPR_Register with Volatile, Full_Access_Only;
      USART_RTOR : USART_RTOR_Register with Volatile, Full_Access_Only;
      USART_RQR  : USART_RQR_Register  with Volatile, Full_Access_Only;
      USART_ISR  : USART_ISR_Register  with Volatile, Full_Access_Only;
      USART_ICR  : USART_ICR_Register  with Volatile, Full_Access_Only;
      USART_RDR  : USART_RDR_Register  with Volatile, Full_Access_Only;
      USART_TDR  : USART_TDR_Register  with Volatile, Full_Access_Only;
   end record;

   for USART_Registers use record
      USART_CR1  at USART_CR1_Offset  range 0 .. 31;
      USART_CR2  at USART_CR2_Offset  range 0 .. 31;
      USART_CR3  at USART_CR3_Offset  range 0 .. 31;
      USART_BRR  at USART_BRR_Offset  range 0 .. 31;
      USART_GTPR at USART_GTPR_Offset range 0 .. 31;
      USART_RTOR at USART_RTOR_Offset range 0 .. 31;
      USART_RQR  at USART_RQR_Offset  range 0 .. 31;
      USART_ISR  at USART_ISR_Offset  range 0 .. 31;
      USART_ICR  at USART_ICR_Offset  range 0 .. 31;
      USART_RDR  at USART_RDR_Offset  range 0 .. 31;
      USART_TDR  at USART_TDR_Offset  range 0 .. 31;
   end record;

end A0B.Peripherals.USART;
