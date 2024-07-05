
class AES_env extends uvm_env;
    `uvm_component_utils(AES_env)

    AES_scoreboard scoreboard;
    AES_subscriber subscriber;
    AES_agent agent;  
  
    function new(input string inst = "AES_env", uvm_component parent);
        super.new(inst, parent);
    endfunction
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard = AES_scoreboard::type_id::create("scoreboard",this);
        subscriber = AES_subscriber::type_id::create("subscriber",this);
        agent = AES_agent::type_id::create("agent",this);
    endfunction
  
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.send.connect(scoreboard.recv);
        agent.monitor.send.connect(subscriber.analysis_export);
    endfunction
 
endclass : AES_env