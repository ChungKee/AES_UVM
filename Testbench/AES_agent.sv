class AES_agent extends uvm_agent;
    `uvm_component_utils(AES_agent)

    AES_monitor monitor;
    AES_driver driver;
    uvm_sequencer#(AES_sequence_item) seqr;    
    AES_config cfg;
 
  
    function new(input string inst = "AES_agent", uvm_component parent = null);
        super.new(inst,parent);
    endfunction
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg = AES_config::type_id::create("cfg"); 
        monitor = AES_monitor::type_id::create("monitor",this);

        if (cfg.is_active == UVM_ACTIVE) begin
            driver = AES_driver::type_id::create("driver",this);
            seqr = uvm_sequencer#(AES_sequence_item)::type_id::create("seqr", this);
        end
        
    endfunction
  
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (cfg.is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(seqr.seq_item_export);
        end
        
    endfunction
 
endclass : AES_agent