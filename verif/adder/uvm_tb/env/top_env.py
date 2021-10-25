class top_env(UVMEnv):
    #
    #  local pin_vif pif
    #  driver d
    #
    def __init__(self, name, parent=None):
        super().__init__(name, parent)

    def build_phase(self, phase):
        self.ig_agnt = ing_agent("ig_agnt", self)
        self.eg_agnt = eng_agent("eg_agnt", self)
        
    async def run_phase(self, phase):
        phase.raise_objection(self)
        await Timer(100, "NS") # todo control it from the scoreboard event
        phase.drop_objection(self)

uvm_component_utils(top_env)