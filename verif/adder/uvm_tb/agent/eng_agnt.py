
class eng_agnt(UVMAgent):

    #  // constructor
    def __init__(self, name, parent):
        UVMAgent.__init__(self, name, parent)
        self.driver = None
        self.sequencer = None
        self.monitor = None
        self.tag = "eng_agnt_" + name

    #  // build_phase
    def build_phase(self, phase):
        UVMAgent.build_phase(self, phase)
        self.monitor = ubus_slave_monitor.type_id.create("u_slv_monitor", self)
        if self.get_is_active() == UVM_ACTIVE:
            self.driver = ubus_slave_driver.type_id.create("u_slv_driver", self)
            self.sequencer = ubus_slave_sequencer.type_id.create("u_slv_sequencer", self)

    # connect_phase
    def connect_phase(self, phase):
        if self.get_is_active() == UVM_ACTIVE:
            uvm_info(self.tag, "Connecting comps in active mode now",
                    UVM_MEDIUM)
            self.driver.seq_item_port.connect(self.sequencer.seq_item_export)
            self.sequencer.addr_ph_port.connect(self.monitor.addr_ph_imp)


uvm_component_utils(eng_agnt)
