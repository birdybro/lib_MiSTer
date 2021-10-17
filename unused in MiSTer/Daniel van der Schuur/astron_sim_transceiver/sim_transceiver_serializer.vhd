-------------------------------------------------------------------------------
--
-- Copyright 2020
-- ASTRON (Netherlands Institute for Radio Astronomy) <http://www.astron.nl/>
-- P.O.Box 2, 7990 AA Dwingeloo, The Netherlands
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--     http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-------------------------------------------------------------------------------

-- Author:
-- . Daniel van der Schuur
-- Purpose:
--   Basic serializer model for fast transceiver simulation
-- Description:
--   The model serializes parallel data using 10 serial bits per byte. The two 
--   extra bits are used to transfer control (valid, SOP/EOP).
--   The model can represent any real transceiver encoding scheme (10b/8b, 66b/64b) 
--   because the modelled line rate does not have to be the same as the true line rate.
--   The key feature that the model provides is that the parallel data gets
--   transported via a single 1-bit lane. This allows fast simulation of the 
--   link using the true port widths.
--   The most straightforward is to mimic 10/8 encoding for as far as data rates
--   and clock ratios are concerned (not the encoding itself):
--   * User data rate = (8/10)*line data rate
--   * User clock frequency = User data rate / user data width
--   * Serial data block size = 10 bits [9..0] LSb sent first
--     *  [9] = SOP/EOP; '1'=SOP;'U'=EOP.
--     *  [8] = Control bit.
--     *  [7..0] = Data
--   * Word/byte alignment is not required because reference clk and rst are
--     global in simulation: what gets transmitted first is received first.
--   
--  The following diagram shows the serialization of the 32-bit word 0x2. The
--  grid of dots indicates the bit resolution. Note the 1 serial cycle of delay
--  before the first bit is put on the line.
--
--               . _______________________________________ . . . . . . . . . . . . . . . . . . . . .
-- tr_clk        _|. . . . . . . . . . . . . . . . . . . .|_________________________________________
--               _ . . _ . . . . . . _ . . . . . . . . . _ . . . . . . . . . _ . . . . . . . . . _ .        
-- tx_serial_out .|___|.|___________|.|_________________|.|_________________|.|_________________|.|_
--              
--               c P 0 1 2 3 4 5 6 7 c P 0 1 2 3 4 5 6 7 c P 0 1 2 3 4 5 6 7 c P 0 1 2 3 4 5 6 7 c P
--                  |<----- Byte 0 ---->|<----- Byte 1 ---->|<----- Byte 2 ---->|<----- Byte 3 ---->|
--
-- Remarks:
-- . All serializers in the simualation should be simultaneously released from 
--   reset and have to share the same transceiver reference clock.
-- . The number of line clock cycles to transmit one data word fits within 1
--   tr_clk period. After every data word the data is realigned to the tr_clk.


LIBRARY IEEE, common_pkg_lib;
USE IEEE.std_logic_1164.ALL;
USE common_pkg_lib.common_pkg.ALL;

ENTITY sim_transceiver_serializer IS 
  GENERIC(
    g_data_w         : NATURAL := 32;
    g_tr_clk_period  : TIME := 6.4 ns
  );      
  PORT(
    tb_end        : IN  STD_LOGIC := '0';
    
    tr_clk        : IN  STD_LOGIC;
    tr_rst        : IN  STD_LOGIC;

    tx_in_data    : IN  STD_LOGIC_VECTOR(g_data_w-1 DOWNTO 0);
    tx_in_ctrl    : IN  STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0); -- 1 valid bit per byte
    tx_in_sop     : IN  STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0) := (OTHERS=>'0'); -- 1 SOP   bit per byte
    tx_in_eop     : IN  STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0) := (OTHERS=>'0'); -- 1 EOP   bit per byte

    tx_serial_out : OUT STD_LOGIC
  );

END sim_transceiver_serializer;


ARCHITECTURE beh OF sim_transceiver_serializer IS

  CONSTANT c_line_clk_period   : TIME    := g_tr_clk_period * 8 / 10 / g_data_w;
  CONSTANT c_tr_clk_period_sim : TIME    := c_line_clk_period * g_data_w * 10 / 8;

  CONSTANT c_nof_bytes_per_data : NATURAL := g_data_w / c_byte_w;

BEGIN
 
  p_serialize: PROCESS
    VARIABLE v_tx_in_data : STD_LOGIC_VECTOR(g_data_w-1 DOWNTO 0);
    VARIABLE v_tx_in_ctrl : STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0);
    VARIABLE v_tx_in_sop  : STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0);
    VARIABLE v_tx_in_eop  : STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0);
  BEGIN
    tx_serial_out <= '0';
    WAIT UNTIL tr_rst='0';

    -- Align to tr_clk
    WAIT UNTIL rising_edge(tr_clk);
    v_tx_in_data := tx_in_data;
    v_tx_in_ctrl := tx_in_ctrl;
    v_tx_in_sop  := tx_in_sop;
    v_tx_in_eop  := tx_in_eop;

    WHILE tb_end='0' LOOP
      -- Data word serialization cycle
      FOR byte IN 0 TO c_nof_bytes_per_data-1 LOOP
        -- Serialize each data byte using 10 bits per byte on the line
        FOR bit IN 0 TO c_byte_w-1 LOOP
          tx_serial_out <= v_tx_in_data(byte*c_byte_w+bit);   -- Put the 8 data bits of the data byte on the line
          WAIT FOR c_line_clk_period;
        END LOOP;
        tx_serial_out <= v_tx_in_ctrl(byte);                  -- Put the valid bit on the line for each byte
        WAIT FOR c_line_clk_period;
        tx_serial_out <= '0';                                 -- Put the SOP/EOP indicator bit on the line. '1'=SOP; 'U'=EOP.
        IF v_tx_in_sop(byte) = '1' THEN
          tx_serial_out <= '1';
        ELSIF v_tx_in_eop(byte)='1' THEN
          tx_serial_out <= 'U';
        END IF;
        IF byte<c_nof_bytes_per_data-1 THEN
          WAIT FOR c_line_clk_period;  -- exit loop in last line clock cycle
        END IF;
      END LOOP;
      
      -- Realign to tr_clk rising edge if necessary
      WAIT UNTIL rising_edge(tr_clk);
      
      v_tx_in_data := tx_in_data;
      v_tx_in_ctrl := tx_in_ctrl;
      v_tx_in_sop  := tx_in_sop;
      v_tx_in_eop  := tx_in_eop;

    END LOOP;

  END PROCESS;

END beh;
