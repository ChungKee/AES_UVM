`timescale 1ns / 1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

//`include "AES_assertion.sv"
`include "AES_if.sv"
`include "AES_sequence_item.sv"
`include "AES_sequence.sv"
`include "AES_driver.sv"
`include "AES_monitor.sv"
`include "AES_config.sv"
`include "AES_agent.sv"
`include "AES_model.sv"
`include "AES_scoreboard.sv"
`include "AES_subscriber.sv"
`include "AES_env.sv"
`include "AES_test.sv"


module test;

    AES_interface AES_if();
    
    AES  my_AES
    (
        .clk(AES_if.clk),
        .rst(AES_if.rst),
        .P(AES_if.P),
        .K(AES_if.K),
        .C(AES_if.C),
        .valid(AES_if.valid)
    );

    initial begin
        AES_if.clk = 0;
    end  
    always #10 AES_if.clk = ~AES_if.clk;
   
    initial begin
        uvm_config_db#(virtual AES_interface)::set(null, "*", "AES_if", AES_if);
        run_test("AES_golden_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
  
endmodule