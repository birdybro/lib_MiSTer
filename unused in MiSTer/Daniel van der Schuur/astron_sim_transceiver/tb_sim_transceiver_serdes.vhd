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

-- Purpose:
--   Model a basic serializer->deserializer link and verify received data
-- Description:
--   Data generator -> Serializer -> Deserializer -> Data verification
-- Usage:
--   as 10
--   run -all
--   Observe:
--   . user tx_in_data on serializer == user rx_out_data on deserializer
--   . serial_line carries 4 bytes per serialized word. Each
--     byte is followed by its 2 valid bits and is sent LSb first.

LIBRARY IEEE, common_pkg_lib;                    
USE IEEE.STD_LOGIC_1164.ALL;    
USE IEEE.numeric_std.ALL;
USE common_pkg_lib.common_pkg.ALL;
USE common_pkg_lib.tb_common_pkg.ALL;

ENTITY tb_sim_transceiver_serdes IS  
END ENTITY tb_sim_transceiver_serdes;

ARCHITECTURE tb of tb_sim_transceiver_serdes IS

  CONSTANT c_data_w         : NATURAL := 32;
  CONSTANT c_tr_clk_period  : TIME := 6.4 ns;  -- 156.25 MHz

  SIGNAL tb_end           : STD_LOGIC := '0';
  
  SIGNAL tr_clk           : STD_LOGIC := '0';
  SIGNAL tr_rst           : STD_LOGIC := '1';

  SIGNAL tx_enable        : STD_LOGIC := '1';
  SIGNAL tx_ready         : STD_LOGIC;

  SIGNAL tx_in_data       : STD_LOGIC_VECTOR(c_data_w-1 DOWNTO 0);
  SIGNAL tx_in_val        : STD_LOGIC;
  SIGNAL tx_in_ctrl       : STD_LOGIC_VECTOR(c_data_w/c_byte_w-1 DOWNTO 0);

  SIGNAL serial_line      : STD_LOGIC;

  SIGNAL rx_out_data      : STD_LOGIC_VECTOR(c_data_w-1 DOWNTO 0);
  SIGNAL rx_out_val       : STD_LOGIC;
  SIGNAL rx_out_ctrl      : STD_LOGIC_VECTOR(c_data_w/c_byte_w-1 DOWNTO 0);

  SIGNAL prev_rx_out_data : STD_LOGIC_VECTOR(c_data_w-1 DOWNTO 0);
  SIGNAL verify_en        : STD_LOGIC := '0';
  SIGNAL rd_ready         : STD_LOGIC := '1';

BEGIN

  p_tb_end : PROCESS
  BEGIN
    WAIT FOR c_tr_clk_period*300;
    
    -- Stop the simulation
    tb_end <= '1';
    ASSERT FALSE REPORT "Simulation finished." SEVERITY NOTE;
    WAIT;
  END PROCESS;

  tr_clk  <= NOT tr_clk OR tb_end AFTER c_tr_clk_period/2;
  tr_rst  <= '0' AFTER c_tr_clk_period*10;

  p_tx_ready: PROCESS
  BEGIN
    tx_ready <= '0';
    WAIT UNTIL tr_rst = '0';
    WHILE tb_end='0' LOOP
      tx_ready <= '1';
      WAIT FOR c_tr_clk_period*50;
      tx_ready <= '0';
      WAIT FOR c_tr_clk_period*50;
    END LOOP;
  END PROCESS;

  -- Generate Tx data output with c_rl = 1 and counter data starting at 0
  proc_common_gen_data(1, 0, tr_rst, tr_clk, tx_enable, tx_ready, tx_in_data, tx_in_val);  

  tx_in_ctrl <= (OTHERS=>tx_in_val);

  u_ser: ENTITY work.sim_transceiver_serializer
  GENERIC MAP (
    g_data_w        => c_data_w,
    g_tr_clk_period => c_tr_clk_period
  )
  PORT MAP (
    tb_end             => tb_end,
    tr_clk             => tr_clk,  
    tr_rst             => tr_rst,
     
    tx_in_data         => tx_in_data,
    tx_in_ctrl         => tx_in_ctrl,

    tx_serial_out      => serial_line
  );

  u_des: ENTITY work.sim_transceiver_deserializer 
  GENERIC MAP (
    g_data_w        => c_data_w,
    g_tr_clk_period => c_tr_clk_period
  )
  PORT MAP (
    tb_end             => tb_end,
    tr_clk             => tr_clk,  
    tr_rst             => tr_rst,
     
    rx_out_data        => rx_out_data,
    rx_out_ctrl        => rx_out_ctrl,

    rx_serial_in       => serial_line
  );

  p_verify_en: PROCESS
  BEGIN
    verify_en <= '0';
    WAIT UNTIL tr_rst = '0';
    WAIT FOR c_tr_clk_period*5;
    verify_en <= '1';
    WAIT;
  END PROCESS;

  rx_out_val <= andv(rx_out_ctrl);

  -- Verify dut output incrementing data
  proc_common_verify_data(1, tr_clk, verify_en, rd_ready, rx_out_val, rx_out_data, prev_rx_out_data);

END tb;
