class AES_monitor extends uvm_monitor;
    `uvm_component_utils(AES_monitor)
    
    uvm_analysis_port#(AES_sequence_item) send;
    AES_sequence_item tr;
    virtual AES_interface vif2;
      
    function new(input string inst = "AES_monitor", uvm_component parent = null);
       super.new(inst,parent);
    endfunction
      
    virtual function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       tr = AES_sequence_item::type_id::create("tr");
       send = new("send", this);
       if(!uvm_config_db#(virtual AES_interface)::get(this,"","AES_if",vif2))//uvm_test_top.env.agent.drv.aif
         `uvm_error("AES_MONITOR","Unable to access Interface");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      repeat (4) @(posedge vif2.clk);
      forever begin       
        tr.plain_text = vif2.P;
        tr.key        = vif2.K;
        tr.ciphertext = vif2.C;
        tr.valid      = vif2.valid;
        tr.rst        = vif2.rst;
        `uvm_info("CLOCK_MONITOR", $sformatf("P:%0x K:%0x valid:%0x C:%0x", tr.plain_text, tr.key, tr.valid, tr.ciphertext), UVM_NONE);
        send.write(tr);
        @(posedge vif2.clk);
    end
    
    endtask
 
endclass : AES_monitor