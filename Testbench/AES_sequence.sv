class AES_sequence extends uvm_sequence#(AES_sequence_item) ;
    `uvm_object_utils(AES_sequence)
    
    AES_sequence_item tr;  
  
    function new(string name = "AES_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        tr = AES_sequence_item::type_id::create("tr");
        start_item(tr);
        tr.rst = 1;
        tr.plain_text = 0;
        tr.key = 0;
        finish_item(tr);
      	
        for(int i = 0; i < 20; i++)begin
            start_item(tr);
          	tr.rst = 0;
            if (!tr.randomize()) begin
                `uvm_error("AES_sequence", "Randomization failed for AES_sequence_item");
            end
            finish_item(tr);
        end
    endtask
endclass : AES_sequence