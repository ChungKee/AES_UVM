`ifndef _AES_GOLDEN_TEST_
`define _AES_GOLDEN_TEST_

class AES_golden_test extends uvm_test;

    `uvm_component_utils(AES_golden_test)

    AES_sequence seqr;
    AES_env env;  
  
    function new(input string inst = "AES_golden_test", uvm_component parent);
        super.new(inst, parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = AES_sequence::type_id::create("seqr",this);
        env = AES_env::type_id::create("env",this);
    endfunction
  
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        for(int i = 0; i < 1; i++)begin
            seqr.start(env.agent.seqr);
        end
      repeat (12) @(posedge env.agent.monitor.vif2.clk);
        `uvm_info("AES_GOLDEN_TEST", "END",UVM_NONE);
        phase.drop_objection(this);
    endtask

endclass : AES_golden_test
`endif 
