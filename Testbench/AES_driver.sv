class AES_driver extends uvm_driver #(AES_sequence_item);
    `uvm_component_utils(AES_driver)
    
    virtual AES_interface vif2;
    AES_sequence_item tr;
 
    
    function new(input string path = "AES_driver", uvm_component parent = null);
        super.new(path,parent);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = AES_sequence_item::type_id::create("tr");
        if(!uvm_config_db #(virtual AES_interface)::get(this, "", "AES_if", vif2))
            `uvm_error("drv", "Unable to access interface");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      
        @(posedge vif2.clk);
        forever begin
            seq_item_port.get_next_item(tr);
            vif2.rst <= tr.rst;
            vif2.P   <= tr.plain_text;
            vif2.K   <= tr.key;
            `uvm_info("AES_DRV",$sformatf("Plain = %x key = %x rst = %x",tr.plain_text,tr.key,tr.rst), UVM_NONE);
            @(posedge vif2.clk);
            seq_item_port.item_done();
        end
    endtask
  
endclass : AES_driver