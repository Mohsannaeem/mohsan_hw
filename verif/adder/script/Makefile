# Minimal Makefile for uvm-python minimal example
MC_ROOT ?= __PLEASE_SET_AN_ENVIRONMENT_VARIABLE_NAMED_TCROOT_TO_POINT_TO_THE_SMARTNIC_REPO___
Design = ${MC_ROOT}/design
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES = ${Design}/adder.sv
TOPLEVEL := adder_top
MODULE   ?= adder_test
SIM = "icarus"
# PYTHONPATH := ../../../src:$(PYTHONPATH)
# export PYTHONPATH

include $(shell cocotb-config --makefiles)/Makefile.sim
