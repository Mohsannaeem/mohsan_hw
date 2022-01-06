import cocotb
""" Import Timer for delay"""
from cocotb.triggers import Timer,Event
"""Import the RISING Edge to detect Rising edge"""
from cocotb.triggers import RisingEdge
"""Import random to generate random variable"""
import random


"""Method declarations for different functions"""
rst_evnt=Event("reset_done")
rst_evnt.clear()
clk_evnt=Event("clk_done")
clk_evnt.clear()
out_evnt=Event("out_done")
out_evnt.clear()
async def generate_reset(dut):
    """Generate the reset after specific time"""
    dut._log.info("Reset Asserted")
    dut.i_rst.value=0
    await Timer(random.randint(5,15), units="ns")  # wait for cycles
    dut.i_rst.value=1
    dut._log.info("Reset Deasserted")
    rst_evnt.set()
async def generate_clock(dut):
    """Generate clock pulses."""
    dut._log.info("Clock generation start")
    while(not clk_evnt.is_set()):
        dut.i_clk.value = 0
        await Timer(1, units="ns")
        dut.i_clk.value = 1
        await Timer(1, units="ns")
    dut._log.info("Clock generation End")


async def generate_input(dut,no_stimulus):
    # Takes to drive the input on dut interface 
    count=0
    dut._log.info("Waiting for Event")
    rst_evnt.wait()
    await RisingEdge(dut.i_clk)
    for stim in range(no_stimulus):
        dut._log.info("Input Stimulus generation")
        dut.i_a.value = random.randint(0,20)
        dut.i_b.value = random.randint(21,40)
        dut.i_operand.value = random.randint(0,3)
        dut.i_valid.value=1;
        await RisingEdge(dut.i_clk)
        got_a = int(dut.i_a.value)
        got_b = int(dut.i_b.value)
        got_op = int(dut.i_operand.value)
        dut._log.info("Stimulus count = %d)" % count)
        dut._log.info("Input Data1 = %d)" % got_a)
        dut._log.info("Input Data2 = %d)" % got_b)
        dut._log.info("Input operand = %d)" % got_op)
        dut.i_valid.value=0;
        count=count+1
        for rand_test in range(random.randint(5,10)):
            await RisingEdge(dut.i_clk)
    dut._log.info("Input Stimulus Done") 
    out_evnt.set()
    # dut._log.info("Monitor Event Set")        
    for rand_test in range(random.randint(15,25)):
      await RisingEdge(dut.i_clk)
    # dut._log.info("Clock Event Set") 
    clk_evnt.set()
    

async def monitor_out(dut
  ):    
# """Monitor to outputs of input"""
    match = 0
    mismatch = 0
    while(not out_evnt.is_set()):
        i_a = dut.i_a.value
        i_b = dut.i_b.value
        i_operand = dut.i_operand.value
        # print(type(i_operand))
        if dut.o_valid.value:
          if(int(i_operand) == 0):
            exp_result = i_a + i_b
          elif(int(i_operand) == 1):
            exp_result = i_a ^ i_b
          elif(int(i_operand) == 2):
            exp_result = i_a | i_b
          elif(int(i_operand) == 3):
            exp_result = i_a & i_b
          else:
            exp_result = i_a + i_b         
          rcv_result = dut.o_result.value
          
          if (exp_result == rcv_result):
            match=match+1
            dut._log.info("Matched Count %d",match ) 
          else:
            mismatch=mismatch+1
            dut._log.info("Mismatched Count %d",mismatch ) 
          dut._log.info("Recived Result= %d",int(rcv_result) ) 
          dut._log.info("expected Result= %d",int(exp_result) ) 
        await RisingEdge(dut.i_clk)
    dut._log.info("Test Results : Match %s ,Mismatch %s",match,mismatch )                 
    dut._log.info("Monitor Event Done")      
@cocotb.test()
async def alu_design_test(dut):
    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    reset_thread = cocotb.start_soon(generate_reset(dut))  # generate reset "in the background"
    await (reset_thread)

    input_thread = cocotb.start_soon(generate_input(dut,100))       # generate input "in the background"

    output_thread = cocotb.start_soon(monitor_out(dut))      # monitor output "in the background"
    await (input_thread)
    await (output_thread)

