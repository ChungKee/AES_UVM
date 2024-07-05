class AES_subscriber extends uvm_subscriber #(AES_sequence_item);
    `uvm_component_utils(AES_subscriber)
    
    bit [9:0] cover_plain_text;
    bit [9:0] cover_key;

    covergroup one_hot_cg;
        c1: coverpoint cover_plain_text{
            bins all[] = {[0:1023]};
            option.weight = 0;
        }
        c2: coverpoint cover_key{
            bins all[] = {[0:1023]};
            option.weight = 0;
        }
        c1c2: cross c1,c2;
    endgroup

    function new(input string inst = "AES_subscriber", uvm_component parent);
        super.new(inst, parent); 
        one_hot_cg = new();   
    endfunction

    virtual function void write(AES_sequence_item t);
        cover_plain_text = t.plain_text[9:0];
        cover_key        = t.key[9:0];
        one_hot_cg.sample();
        `uvm_info("AES_SUBSCRIBER", $sformatf("Plain = %x key = %x rst = %x", t.plain_text, t.key, t.rst), UVM_NONE);
        $display("The actual coverage = %f", one_hot_cg.get_inst_coverage());
    endfunction    
endclass //AES_subscriber 