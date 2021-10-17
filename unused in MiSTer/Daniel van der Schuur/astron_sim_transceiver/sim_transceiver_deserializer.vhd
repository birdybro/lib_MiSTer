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
--   Basic deserializer model for fast transceiver simulation
-- Description:
--   See sim_transceiver_serializer.vhd 
-- Remarks:


LIBRARY IEEE, common_pkg_lib;
USE IEEE.std_logic_1164.ALL;
USE common_pkg_lib.common_pkg.ALL;

ENTITY sim_transceiver_deserializer IS 
  GENERIC(
    g_data_w         : NATURAL := 32;
    g_tr_clk_period  : TIME := 6.4 ns
  );      
  PORT(
    tb_end        : IN  STD_LOGIC := '0';
    
    tr_clk        : IN  STD_LOGIC;
    tr_rst        : IN  STD_LOGIC;

    rx_out_data   : OUT STD_LOGIC_VECTOR(g_data_w-1 DOWNTO 0);
    rx_out_ctrl   : OUT STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0);
    rx_out_sop    : OUT STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0);
    rx_out_eop    : OUT STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0);

    rx_serial_in  : IN  STD_LOGIC
  );

END sim_transceiver_deserializer;


ARCHITECTURE beh OF sim_transceiver_deserializer IS

  CONSTANT c_line_clk_period    : TIME    := g_tr_clk_period * 8 / 10 / g_data_w;
  CONSTANT c_nof_bytes_per_data : NATURAL := g_data_w/c_byte_w;

BEGIN

  p_deserialize: PROCESS
    VARIABLE v_rx_out_data : STD_LOGIC_VECTOR(g_data_w-1 DOWNTO 0);
    VARIABLE v_rx_out_ctrl : STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0);
    VARIABLE v_rx_out_sop  : STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0);
    VARIABLE v_rx_out_eop  : STD_LOGIC_VECTOR(g_data_w/c_byte_w-1 DOWNTO 0);
  BEGIN
    --rx_out_data <= (OTHERS=>'0');
    rx_out_ctrl <= (OTHERS=>'0');
    rx_out_sop  <= (OTHERS=>'0');
    rx_out_eop  <= (OTHERS=>'0');

    WAIT UNTIL tr_rst='0' ;

    -- Align to tr_clk
    WAIT UNTIL rising_edge(tr_clk);
    
    WHILE tb_end='0' LOOP
      -- Wait for half of a serial clk period so data is stable when sampling
      WAIT FOR c_line_clk_period/2;
      
      -- Data word deserialization cycle
      FOR byte IN 0 TO c_nof_bytes_per_data-1 LOOP
        -- Deserialize each data byte using 10 bits per byte from the line
        FOR bit IN 0 TO c_byte_w-1 LOOP
          v_rx_out_data(byte*c_byte_w+bit) := rx_serial_in;  -- Get the 8 data bits of the data byte from the line
          WAIT FOR c_line_clk_period;
        END LOOP;
        v_rx_out_ctrl(byte) := rx_serial_in;                 -- Get the 1 control bit from the line for each byte
        WAIT FOR c_line_clk_period;
        v_rx_out_sop(byte) := '0';                           -- Get the SOP/EOP (tenth) bit from the line
        v_rx_out_eop(byte) := '0';
        IF rx_serial_in='1' THEN
          v_rx_out_sop(byte) := '1';
        ELSIF rx_serial_in = 'U' THEN
          v_rx_out_eop(byte) := '1';
        END IF;
        IF byte<c_nof_bytes_per_data-1 THEN
          WAIT FOR c_line_clk_period;  -- exit loop in last half line clock cycle
        END IF;
      END LOOP;
      
      -- Realign to tr_clk rising edge
      WAIT UNTIL rising_edge(tr_clk);

      -- End of this deserialization cycle: the rx data word has been assembled.
      rx_out_data <= v_rx_out_data;
      rx_out_ctrl <= v_rx_out_ctrl;
      rx_out_sop  <= v_rx_out_sop;
      rx_out_eop  <= v_rx_out_eop;
    END LOOP;

  END PROCESS;

END beh;
