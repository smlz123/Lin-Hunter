classdef myemi_cfg
 properties(Constant = true)
     TARGET_LANGUAGE = {
            %'SystemVerilog'  %generate sv language
            'Verilog'        %generate v language
            % 'VHDL'           %generate VHDL language
            };
     is_regenerate_SLEMI = 1;
 end
end