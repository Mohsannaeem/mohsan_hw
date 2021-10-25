# import add_pkg
# import cocotb
# from cocotb.triggers import Timer
# from uvm import *



@cocotb.test()
async def tb_top(dut):
    add_vif = adder_if(dut)
    UVMConfigDb.set( self, "*", "add_vif", add_vif)
    await run_test('adder_test')

