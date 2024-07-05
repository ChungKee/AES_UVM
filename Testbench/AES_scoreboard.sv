
class AES_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(AES_scoreboard);
    
    uvm_analysis_imp#(AES_sequence_item, AES_scoreboard) recv;
    AES_model my_aes_class;

    function new(input string inst = "AES_scoreboard", uvm_component parent);
        super.new(inst, parent);
    endfunction
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        recv = new("AES_RECV", this);
        my_aes_class = new();
    endfunction

    bit [127:0] buffer[$:20];
    bit flag = 0;
    virtual function void write(AES_sequence_item tr);
        bit [127:0] expected_data;
        bit [127:0] actual_data;
        bit [127:0] ans;
        if (tr.rst) begin
            buffer = {};
        end 
        else begin
            expected_data = my_aes_class.AES_128(tr.plain_text, tr.key);
            buffer.push_back(expected_data);
        end

        if (tr.valid)begin
            actual_data   = tr.ciphertext;
            ans           = buffer.pop_front();
            if (actual_data == ans) begin
                `uvm_info("AES_scoreboard", $sformatf("Data match! Data: %h", actual_data), UVM_LOW);
            end
            else begin
                `uvm_error("AES_scoreboard", $sformatf("Data mismatch! Expected: %h, Got: %h", ans, actual_data));
            end
        end
    endfunction

endclass : AES_scoreboard