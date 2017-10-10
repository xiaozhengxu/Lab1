`define AND and #20
`define OR or #20
`define XOR xor #20 //????
`define NOT not #10
`define NAND nand #10
`define NOR nor #10

`include "multiplexer.v"
`include "AddSub.v"

module BitSliceALU
(
  output ALUout,
  output Cout,
  input invertB,
  input Cin,
  input[2:0] addr,
  input bit1, bit2
);
  wire Cout;
  wire [7:0] out;
  structAddSub structadder(out[0], Cout, bit1, bit2, invertB, Cin);

  wire nored, nanded;

  `XOR (out[1], bit1, bit2);

  `NAND (nanded, bit1, bit2);
  `XOR (out[3], invertB, nanded);

  `NOR (nored, bit1, bit2);
  `XOR (out[4], invertB, nored);

  //`XOR (out[2], bit1, bit2);
  /*wire sum, Cout;

  structAddSub structadder(out[2], Cout, bit1, bit2, invertB, Cin);

  assign out[0] = bit1;
  assign out[1] = bit2;*/
  //assign out[7:0] = 8'b0;

  structuralMultiplexer opmux(ALUout, addr, out);
endmodule

module ALU
(
output[31:0]  result,
output        carryout,
output        zero,
output        overflow,
input[31:0]   operandA,
input[31:0]   operandB,
input[2:0]    mux,
input         invertB,
input         flags
);
  //wire control2;
  wire overflow;
  wire[31:0] Cout;
  //integer i = 0;
  BitSliceALU bit0(result[0], Cout[0], invertB, 1'b0, mux, operandA[0], operandB[0]);
  //always @(*)
  genvar i;
  generate
    for (i = 1; i < 32; i = i+1)
    begin: ripple
      BitSliceALU bit(result[i], Cout[i], invertB, Cout[i-1], mux, operandA[i], operandB[i]);
    end
  endgenerate


  `XOR (overflow, Cout[31], Cout[30]);
endmodule