/*
 * Copyright (c) 2026 Bhavya Sharma
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_bhavya_srm_ttt_core (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_oe = 8'b1111_0000;

  reg [7:0] hb; 
  always @(posedge clk) begin 
    if (!rst_n) hb <= 8'd0; 
    else hb <= hb + 8'd1; 
  end 

  reg [7:0] capture;
  always @(posedge clk) begin
    if (!rst_n) capture <= 8'd0;
    else if (uio_in[1]) capture <= ui_in; 
  end

  assign uo_out   = {hb[7], capture[6:0]};
  assign uio_out  = {hb[3:0], 4'b0000};
  

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in[7:2], uio_in[0], 1'b0};

endmodule

`default_nettype wire
