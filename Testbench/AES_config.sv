class AES_config extends uvm_object;
    `uvm_object_utils(AES_config)
    function new(string inst = "AES_config");
        super.new(inst);
    endfunction

    uvm_active_passive_enum is_active = UVM_ACTIVE;
endclass : AES_config