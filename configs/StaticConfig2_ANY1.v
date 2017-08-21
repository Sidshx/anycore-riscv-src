/*******************************************************************************
#                        NORTH CAROLINA STATE UNIVERSITY
#
#                              AnyCore Project
# 
# AnyCore written by NCSU authors Rangeen Basu Roy Chowdhury and Eric Rotenberg.
# 
# AnyCore is based on FabScalar which was written by NCSU authors Niket K. 
# Choudhary, Brandon H. Dwiel, and Eric Rotenberg.
# 
# AnyCore also includes contributions by NCSU authors Elliott Forbes, Jayneel 
# Gandhi, Anil Kumar Kannepalli, Sungkwan Ku, Hiran Mayukh, Hashem Hashemi 
# Najaf-abadi, Sandeep Navada, Tanmay Shah, Ashlesha Shastri, Vinesh Srinivasan, 
# and Salil Wadhavkar.
# 
# AnyCore is distributed under the BSD license.
*******************************************************************************/

`timescale 1ns/1ps

//`define CLKPERIOD 1.12
//`define CLKPERIOD 1.68 //3X
//`define CLKPERIOD 1.71 //3x0.57
`define CLKPERIOD 3.42 //6x0.57

`define SRAM_DATA_WIDTH 8

//* Fetch Width
`define FETCH_WIDTH             2
`define FETCH_WIDTH_LOG         1

`define FETCH_TWO_WIDE
//`define FETCH_THREE_WIDE
//`define FETCH_FOUR_WIDE
//`define FETCH_FIVE_WIDE
//`define FETCH_SIX_WIDE
//`define FETCH_SEVEN_WIDE
//`define FETCH_EIGHT_WIDE

//* Dispatch Width
`define DISPATCH_WIDTH          2
`define DISPATCH_WIDTH_LOG      1

`define DISPATCH_TWO_WIDE
//`define DISPATCH_THREE_WIDE
//`define DISPATCH_FOUR_WIDE
//`define DISPATCH_FIVE_WIDE
//`define DISPATCH_SIX_WIDE
//`define DISPATCH_SEVEN_WIDE
//`define DISPATCH_EIGHT_WIDE

//* Issue Width
`define ISSUE_WIDTH             3
`define ISSUE_WIDTH_LOG         2 

`define ISSUE_TWO_WIDE
`define ISSUE_THREE_WIDE
//`define ISSUE_FOUR_WIDE
//`define ISSUE_FIVE_WIDE
//`define ISSUE_SIX_WIDE
//`define ISSUE_SEVEN_WIDE
//`define ISSUE_EIGHT_WIDE

//* Commit Width
`define COMMIT_WIDTH            2
`define COMMIT_WIDTH_LOG        1

`define COMMIT_TWO_WIDE
//`define COMMIT_THREE_WIDE
//`define COMMIT_FOUR_WIDE
//`define COMMIT_FIVE_WIDE
//`define COMMIT_SIX_WIDE
//`define COMMIT_SEVEN_WIDE
//`define COMMIT_EIGHT_WIDE

//* Register Read Depth
//`define RR_TWO_DEEP
//`define RR_THREE_DEEP
//`define RR_FOUR_DEEP

//* Issue Depth
`define ISSUE_TWO_DEEP
`define ISSUE_THREE_DEEP

/* Control which execution pipes can execute simple instructions.
 * Starting at the MSB and going toward the LSB, set a bit for each
 * pipe that supports simple instructions. Bits 0 and 1 must not be set. */
`define SIMPLE_VECT 'b100
/* `define TWO_SIMPLE */
/* `define THREE_SIMPLE */
/* `define FOUR_SIMPLE */
/* `define FIVE_SIMPLE */
/* `define SIX_SIMPLE */

/* Control which execution pipes can execute complex instructions.
 * Starting at bit 2 and going toward the MSB, set a bit for each
 * pipe that supports complex instructions */
`define COMPLEX_VECT 'b100
/* `define TWO_COMPLEX */
/* `define THREE_COMPLEX */
/* `define FOUR_COMPLEX */
/* `define FIVE_COMPLEX */
/* `define SIX_COMPLEX */


// Instruction queue size should be greater
// than 2*FETCH_WIDTH (decode width)
`define INST_QUEUE              8
`define INST_QUEUE_LOG          3

`define SIZE_ACTIVELIST         48
`define SIZE_ACTIVELIST_LOG     6

`define SIZE_PHYSICAL_TABLE     48
`define SIZE_PHYSICAL_LOG       6

`define SIZE_ISSUEQ             16
`define SIZE_ISSUEQ_LOG         4

//* Select Block Size
`define SIZE_SELECT_BLOCK       8

`define SIZE_LSQ                8
`define SIZE_LSQ_LOG            3

`define SIZE_RAS                8
`define SIZE_RAS_LOG            3

`define SIZE_CTI_QUEUE          16
`define SIZE_CTI_LOG            4

`define SIZE_RMT                34
`define SIZE_RMT_LOG            6

`define SIZE_FREE_LIST          (`SIZE_PHYSICAL_TABLE-`SIZE_RMT) // 14
`define SIZE_FREE_LIST_LOG      4

`define SIZE_BTB                32*(1<<`FETCH_WIDTH_LOG) // Num BTB lanes is power of 2
`define SIZE_BTB_LOG            5+`FETCH_WIDTH_LOG

`define SIZE_CNT_TABLE          32*(1<<`FETCH_WIDTH_LOG) // Num BTB lanes is power of 2
`define SIZE_CNT_TBL_LOG        5+`FETCH_WIDTH_LOG

`define SIZE_LD_VIOLATION_PRED     128 
`define SIZE_LD_VIOLATION_PRED_LOG 7


//* comment following line, if load violation predictor is not required.
`define ENABLE_LD_VIOLATION_PRED

//`define N_REPAIR_CYCLES         4
//`define N_REPAIR_PACKETS        (34 + `N_REPAIR_CYCLES - 1)/`N_REPAIR_CYCLES // Note: this is ceil(34/N_REPAIR_CYCLES)

// Rangeen
`define N_ARCH_REGS             34
//`define N_REPAIR_PACKETS        `DISPATCH_WIDTH  // If this is greater than COMMIT_WIDTH, AMT will have N_REPAIR_PACKETS number of read ports
`define N_REPAIR_PACKETS        6  // If this is greater than COMMIT_WIDTH, AMT will have N_REPAIR_PACKETS number of read ports
`define N_REPAIR_CYCLES        (`N_ARCH_REGS + `N_REPAIR_PACKETS - 1)/`N_REPAIR_PACKETS // Note: the integer part of this expression is ceil(N_ARCH_REGS/N_REPAIR_PACKETS)

//Added by RBRC

`define EXEC_WIDTH `ISSUE_WIDTH 
`define STRUCT_PARTS 4    // The number of partitions for reconfigurable structures
`define STRUCT_PARTS_LOG 2    // The number of partitions for reconfigurable structures

`define SCRATCH_PAD

`ifdef SCRATCH_PAD
  `define DEBUG_INST_RAM_WIDTH 40
  `define DEBUG_INST_RAM_DEPTH 256
  `define DEBUG_INST_RAM_LOG   8
  `define DEBUG_DATA_RAM_WIDTH 32
  `define DEBUG_DATA_RAM_DEPTH 256
  `define DEBUG_DATA_RAM_LOG   8
`endif

/* Parameters associated with the reconfigurable multi-port RAM*/
`define RAM_RESET_ZERO 0
`define RAM_RESET_SEQ 1
`ifdef USE_VPI
`define GET_ARCH_PC             $getArchPC()
`define READ_OPCODE(a)          $read_opcode(a)
`define READ_OPERAND(a)         $read_operand(a)
`define READ_SIGNED_BYTE(a)     $readSignedByte(a)
`define READ_UNSIGNED_BYTE(a)   $readUnsignedByte(a)
`define READ_SIGNED_HALF(a)     $readSignedHalf(a)
`define READ_UNSIGNED_HALF(a)   $readUnsignedHalf(a)
`define READ_WORD(a)            $readWord(a)
`define WRITE_BYTE(a,b)         $writeByte(a,b)
`define WRITE_HALF(a,b)         $writeHalf(a,b)
`define WRITE_WORD(a,b)         $writeWord(a,b)

`else
`define GET_ARCH_PC             0
`define READ_OPCODE(a)          $random
`define READ_OPERAND(a)         $random
`define READ_SIGNED_BYTE(a)     $random
`define READ_UNSIGNED_BYTE(a)   $random
`define READ_SIGNED_HALF(a)     $random
`define READ_UNSIGNED_HALF(a)   $random
`define READ_WORD(a)            $random
`define WRITE_BYTE(a,b)         //
`define WRITE_HALF(a,b)         //
`define WRITE_WORD(a,b)         //
`endif


`define SIZE_PC                 32
`define SIZE_INSTRUCTION        64
`define SIZE_INSTRUCTION_BYTE   8

`define SIZE_INST_BYTE_OFFSET   3
`define SIZE_PREDICTION_CNT     2

`define BRANCH_TYPE_LOG             2

`define RETURN                  2'h0
`define CALL                    2'h1
`define JUMP_TYPE               2'h2
`define COND_BRANCH             2'h3

/*
 * 00 = Return
 * 01 = Call Direct/Indirect
 * 10 = Jump Direct/Indirect
 * 11 = Conditional Branch
*/

`define SIZE_DATA               32
`define INSTRUCTION_TYPES       4
`define INST_TYPES_LOG          2
`define MEMORY_TYPE             2'b00
`define CONTROL_TYPE            2'b01
`define SIMPLE_TYPE             2'b10
`define COMPLEX_TYPE            2'b11
`define INSTRUCTION_TYPE0       2'b00     // Simple ALU
`define INSTRUCTION_TYPE1       2'b01     // Complex ALU (for MULTIPLY & DIVIDE)
`define INSTRUCTION_TYPE2       2'b10     // CONTROL Instructions
`define INSTRUCTION_TYPE3       2'b11     // LOAD/STORE Address Generator
`define LDST_BYTE               2'b00
`define LDST_HALF_WORD          2'b01
`define LDST_WORD               2'b10
`define LDST_DOUBLE_WORD        2'b11
`define LDST_TYPES_LOG          2

`define SIZE_VIRT_ADDR        32
`define SIZE_DATA_BYTE_OFFSET   2

`define FU0                     2'b00     // Simple ALU
`define FU1                     2'b01     // Complex ALU (for MULTIPLY & DIVIDE)
`define FU2                     2'b10     // ALU for CONTROL Instructions
`define FU3                     2'b11     // LOAD/STORE Address Generator
`define FU0_LATENCY             1
`define FU1_LATENCY             5
`define FU2_LATENCY             1
`define FU3_LATENCY             2

`define SIZE_EXE_FLAGS         8
                                   /*  bit[0]: Mispredict,
                                    *  bit[1]: Exception,
                                    *  bit[2]: Executed,
                                    *  bit[3]: Fission Instruction,
                                    *  bit[4]: Destination Valid,
                                    *  bit[5]: Predicted Control Instruction
                                    *  bit[6]: Load byte/half-word sign
                                    *  bit[7]: Conditional Branch Instruction
                                   */

/* PISA instruction format
*/
`define SIZE_OPCODE_P           32       // opcode size from original PISA i.e. 32bits
`define SIZE_OPCODE_I           8       // opcode size used for implementation
`define SIZE_IMMEDIATE          16
`define SIZE_TARGET             26
`define SIZE_RS                 8
`define SIZE_RT                 8
`define SIZE_RD                 8
`define SIZE_RU                 8
`define SIZE_SPECIAL_REG        2         // In case of SimpleScalar HI and LO
                                         // are special registers, which stores
                                         // Multiply and Divide result.
`define REG_RA                  31


