

# from uvm.base.sv import sv_if

class adder_if(sv_if):

    def __init__(self, dut):
        self.signals = ['a', 'b', 'sum']
        bus_map = {}
        for sig in self.signals:
            bus_map[sig] = sig
        super().__init__(dut, '', bus_map)
        # self.slave_mp = self
        # self.master_mp = self
        # self.monitor_mp = self
       

