module top
#( parameter param28 = (~^{(^(+((8'haa) ? (8'hb5) : (8'hbb)))), (((-(7'h43)) ? ((7'h40) >= (8'h9c)) : {(8'h9c), (8'hac)}) | (((8'hb4) || (8'h9e)) ? ((7'h43) ~^ (7'h43)) : {(8'hb3), (8'ha1)}))}) )
(y, clk, wire3, wire2, wire1, wire0);
  output wire [(32'h126):(32'h0)] y;
  input wire [(1'h0):(1'h0)] clk;
  input wire signed [(4'hb):(1'h0)] wire3;
  input wire signed [(4'hc):(1'h0)] wire2;
  input wire [(2'h2):(1'h0)] wire1;
  input wire [(4'he):(1'h0)] wire0;
  reg [(4'hd):(1'h0)] reg27 = (1'h0);
  wire [(4'ha):(1'h0)] wire26;
  wire [(5'h11):(1'h0)] wire25;
  wire [(5'h10):(1'h0)] wire24;
  reg signed [(4'he):(1'h0)] reg23 = (1'h0);
  reg [(4'hb):(1'h0)] reg22 = (1'h0);
  reg signed [(2'h3):(1'h0)] reg21 = (1'h0);
  reg signed [(5'h12):(1'h0)] reg20 = (1'h0);
  reg [(3'h6):(1'h0)] reg19 = (1'h0);
  reg [(5'h12):(1'h0)] reg18 = (1'h0);
  reg [(4'hd):(1'h0)] reg17 = (1'h0);
  reg signed [(5'h15):(1'h0)] reg16 = (1'h0);
  reg signed [(2'h3):(1'h0)] reg15 = (1'h0);
  reg signed [(3'h4):(1'h0)] forvar14 = (1'h0);
  reg [(4'hd):(1'h0)] reg13 = (1'h0);
  reg [(4'he):(1'h0)] reg12 = (1'h0);
  reg [(5'h15):(1'h0)] reg11 = (1'h0);
  reg [(3'h6):(1'h0)] reg10 = (1'h0);
  reg [(4'hb):(1'h0)] forvar9 = (1'h0);
  wire signed [(4'hf):(1'h0)] wire8;
  reg [(4'ha):(1'h0)] reg7 = (1'h0);
  reg signed [(4'he):(1'h0)] reg6 = (1'h0);
  reg [(5'h11):(1'h0)] reg5 = (1'h0);
  reg signed [(3'h5):(1'h0)] forvar4 = (1'h0);
  assign y = {reg27,
                 wire26,
                 wire25,
                 wire24,
                 reg23,
                 reg22,
                 reg21,
                 reg20,
                 reg19,
                 reg18,
                 reg17,
                 reg16,
                 reg15,
                 forvar14,
                 reg13,
                 reg12,
                 reg11,
                 reg10,
                 forvar9,
                 wire8,
                 reg7,
                 reg6,
                 reg5,
                 forvar4,
                 (1'h0)};
  always
    @(posedge clk) begin
      for (forvar4 = (1'h0); (forvar4 < (1'h0)); forvar4 = (forvar4 + (1'h1)))
        begin
          reg5 <= (&forvar4);
          reg6 = $unsigned("3gzh1");
        end
      reg7 <= wire2;
    end
  assign wire8 = (wire0[(4'h8):(3'h4)] ? {"x3T4ID"} : reg5[(4'he):(2'h3)]);
  always
    @(posedge clk) begin
      for (forvar9 = (1'h0); (forvar9 < (3'h4)); forvar9 = (forvar9 + (1'h1)))
        begin
          if ((reg7 ^ (^~$unsigned(wire8[(4'hd):(4'h9)]))))
            begin
              reg10 <= ($signed($signed(reg6)) << "VmlA5");
              reg11 = $unsigned((wire3 ?
                  {wire2[(2'h3):(2'h2)]} : ({(reg6 ~^ (8'had)),
                      (^~wire8)} * (^(wire0 ? wire3 : reg5)))));
              reg12 = ($signed(("" >> $unsigned($signed(reg5)))) == wire8);
              reg13 <= $signed("CpbLTzF1an3nwPZ3");
            end
          else
            begin
              reg10 <= reg12;
              reg11 = "ZOPB28Bi";
            end
          for (forvar14 = (1'h0); (forvar14 < (2'h2)); forvar14 = (forvar14 + (1'h1)))
            begin
              reg15 = forvar9[(3'h4):(1'h1)];
              reg16 <= "fZ9QUSb3";
              reg17 = $signed($signed(reg16));
              reg18 <= reg7;
              reg19 = wire8;
            end
          reg20 <= (reg5[(4'hb):(1'h0)] ?
              "Ih" : ($signed("rS") + $unsigned(($unsigned(reg17) ?
                  (reg19 | reg13) : reg10))));
          reg21 <= "HMbH1DXTMp";
        end
      reg22 <= {($signed((|(reg10 && reg6))) > (+(|(-(8'h9d))))),
          "Jy5StK3CJ45NO"};
      reg23 <= wire8[(1'h1):(1'h0)];
    end
  assign wire24 = (~&$unsigned(("uTIsTLTffxrXNXbW" ?
                      (((8'hac) ? forvar9 : wire3) ?
                          (+wire2) : {forvar14,
                              reg5}) : reg11[(5'h11):(2'h3)])));
  assign wire25 = $unsigned("2ocfz");
  assign wire26 = (8'h9d);
  always
    @(posedge clk) begin
      reg27 <= wire26;
    end
endmodule