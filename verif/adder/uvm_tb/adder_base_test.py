class adder_base_test(UVMTest):
    
    def __init__(self, name, parent=None):
        super().__init__(name, parent)

    def build_phase(self, phase):
        self.cmn_cfg = common_config("cmn_cfg", self)
        self.env = top_env("env", self)

        cmn_cfg.randomize()
        UVMConfigDb.set(self, "*", "cmn_cfg", self.cmn_cfg)


    # async def run_phase(self, phase):
        # phase.raise_objection(self)
        # await Timer(100, "NS")
        # phase.drop_objection(self)

uvm_component_utils(adder_base_test)