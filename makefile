# SONIX DSP Makefile Version:1.0.0.2
# Defination
COMPILER = "d:\sonix\SN8_C_~1.255\bin\build\sn8pc.exe"
GMA = "d:\Sonix\SN8_C_~1.255\Bin\Build\gma.exe"
LINKER = "d:\Sonix\SN8_C_~1.255\Bin\Build\slink.exe"
CONVERT = "d:\Sonix\SN8_C_~1.255\Bin\Build\RcvSN8.exe"

# Define Path Macro
PRJ_PATH=.
OBJ_PATH=.\Obj
INC_PATH=.\Include
LIB_PATH=.\Lib
C_INC_PATH=d:\Sonix\SN8_C_~1.255\C\include
OUT_PATH=.\Bin
VPATH=.\:$(OBJ_PATH):$(LIB_PATH):$(INC_PATH):$(C_INC_PATH):$(OUT_PATH)

# Define Option Flags
COMPILER_FLAGS = -target=SN8P2708A -INI="d:\Sonix\SN8_C_~1.255\Bin\Build\SN8P2700A.ini" -PROJECTNAME=".\test.prj" -WL=3 -Chip_Series=2 -A -g -I.\Include -Id:\Sonix\SN8_C_~1.255\C\include -PUSH1 -NoCALLHL -NoGlobalOpt -tempdir="$(OBJ_PATH)"  -cpp_skip_asm -DICE_Mode=0
GMA_FLAGS = /INI:"SN8P2700A.ini" /ID1:0 /ID2:0  /MACHINE:SN8P2708A  /Chip_Series:2 /NOPeephole: /PATH:".\Include" /PROJECTNAME:".\test.prj" /WL:3 /DEFINE:ICE_Mode=0 /DEFINE:SN8P2708A=1  /OutputPath:"$(OBJ_PATH)" 
LINK_FLAGS = /MACHINE:SN8P2708A /Chip_Series:2 /INI:"SN8P2700A.ini" /WL:3 /OutputFile:"$(OUT_PATH)/test.out"  /MAP:"$(OBJ_PATH)\test.map"   /LISTFILE:  /STDLIB:".\Obj"    /PATH:"$(LIB_PATH)" /STACK: /PROJECTNAME:".\test.prj"
CONV_FLAGS = /MACHINE:SN8P2708A /INI:"SN8P2700A.ini" /WL:3 /OutputFile:"$(OUT_PATH)/test.sn8"  /PROJECTNAME:".\test.prj" /IDSVersion:V1.20.219.255n /Chip_Series:2 /OSLIB:".\Obj"  
LINK_DEP_FILES = $(OBJ_PATH)\main.o $(OBJ_PATH)\key.o   \

# Define Rule
$(OBJ_PATH)\key.asm: .\Src\key.c $(C_INC_PATH)\SN8P2708A.h $(PRJ_PATH)\test.cfg
	@$(COMPILER) $(COMPILER_FLAGS) -o $@ $^ 

$(OBJ_PATH)\main.asm: .\Src\main.c $(C_INC_PATH)\SN8P2708A.h $(PRJ_PATH)\test.cfg
	@$(COMPILER) $(COMPILER_FLAGS) -o $@ $^ 

$(OBJ_PATH)\key.o: $(OBJ_PATH)\key.asm $(PRJ_PATH)\test.cfg
	@$(GMA) $(GMA_FLAGS) /CSource: /CASE: $< 

$(OBJ_PATH)\main.o: $(OBJ_PATH)\main.asm $(PRJ_PATH)\test.cfg
	@$(GMA) $(GMA_FLAGS) /CSource: /CASE: $< 

$(OUT_PATH)\test.out: $(LINK_DEP_FILES) $(PRJ_PATH)\test.cop
	@$(LINKER) $(LINK_FLAGS) /CSource: /CASE: $(LINK_DEP_FILES) 

$(OUT_PATH)\test.sn8: $(OUT_PATH)\test.out $(PRJ_PATH)\test.cop
	@$(CONVERT) $(CONV_FLAGS) $^ 


# Define Clean Rule
Clean:
	@del /F /Q $(OBJ_PATH)\*.*;
	@if EXIST .\test.prj.stb del .\test.prj.stb;
	@if EXIST .\test.out del .\test.out;
	@if EXIST .\test.sn8 del .\test.sn8;
	@if EXIST .\test.sn8.dep del .\test.sn8.dep;
	@if EXIST $(OUT_PATH)\test.out del $(OUT_PATH)\test.out;
	@if EXIST $(OUT_PATH)\test.sn8 del $(OUT_PATH)\test.sn8;
	@if EXIST $(OUT_PATH)\test.sn8.dep del $(OUT_PATH)\test.sn8.dep;

# Don't keep invalid files, command line must return non-zero(1 or 2) value 
# to validate delete on error mechanism 
# else return 0 for success

.DELETE_ON_ERROR:

Begin: 

Build: Begin All 

Rebuild: Clean Build 

All:$(OUT_PATH)\test.out $(OUT_PATH)\test.sn8
