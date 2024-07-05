class AES_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(AES_sequence_item)
    
    rand logic [127:0] plain_text; 
    rand logic [127:0] key;
    logic [127:0] ciphertext;
    logic valid;
    logic rst;
      
    function new(string name = "AES_sequence_item");
        super.new(name);
    endfunction
 
endclass : AES_sequence_item