module test1 (y, clk);
  output wire y;
  input wire clk; 
  wire wire1; 
  assign wire1 = $signed((~""));
  assign y = wire1;
endmodule