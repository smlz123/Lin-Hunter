module top
#( parameter param11 = ({(&((-(8'haa)) & ((8'hb3) >= (8'haa))))} ? ((^~(8'hb5)) <<< (|{((8'hbf) ? (8'hab) : (8'h9e)), {(8'ha4), (8'h9f)}})) : ((!({(8'hb2), (8'ha2)} != (!(8'hae)))) ? (!(+(^~(8'hb6)))) : (~|{((8'had) ? (8'hb4) : (8'ha0))})))
, parameter param12 = (-(param11 ? ((param11 ? param11 : (param11 ? (8'hab) : param11)) ? ((8'h9f) >= (param11 >= (8'hbe))) : (|{param11})) : param11)) )
(y, clk, wire3, wire2, wire1, wire0);
  output wire [(32'h56):(32'h0)] y;
  input wire [(1'h0):(1'h0)] clk;
  input wire signed [(4'hf):(1'h0)] wire3;
  input wire signed [(3'h6):(1'h0)] wire2;
  input wire [(5'h15):(1'h0)] wire1;
  input wire [(4'hd):(1'h0)] wire0;
  reg [(4'hc):(1'h0)] reg10 = (1'h0);
  reg signed [(4'h8):(1'h0)] reg9 = (1'h0);
  reg signed [(4'ha):(1'h0)] reg8 = (1'h0);
  reg signed [(4'ha):(1'h0)] reg7 = (1'h0);
  wire signed [(5'h15):(1'h0)] wire6;
  wire signed [(5'h15):(1'h0)] wire5;
  wire signed [(2'h3):(1'h0)] wire4;
  assign y = {reg10, reg9, reg8, reg7, wire6, wire5, wire4, (1'h0)};
  assign wire4 = $signed($signed(($signed("") << ({wire3,
                     wire3} << $unsigned(wire3)))));
  assign wire5 = "HoU5MNqz";
  assign wire6 = wire5[(1'h1):(1'h1)];
  always
    @(posedge clk) begin
      reg7 <= "Zuhi4RRh7ml";
      reg8 = wire2[(1'h1):(1'h0)];
      reg9 <= (8'hac);
      reg10 = $signed((($unsigned($unsigned(wire3)) == {(8'h9f), wire2}) ?
          (~^reg7) : (reg7 ? (~|$signed(wire4)) : $unsigned(wire6))));
    end
endmodule