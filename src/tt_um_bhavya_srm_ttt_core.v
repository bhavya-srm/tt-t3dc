/*
 * Copyright (c) 2026 Bhavya Sharma
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

module tt_um_bhavya_srm_ttt_core (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

  assign uio_oe = 8'b1111_0000;

  wire sop        = uio_in[0];
  wire byte_valid = uio_in[1];

  // Heartbeat: proves the tile is clocked
  reg [7:0] hb;
  always @(posedge clk) begin
    if (!rst_n) hb <= 8'd0;
    else        hb <= hb + 8'd1;
  end

  // Byte capture: keeps the input path from being optimised away
  reg [7:0] capture;
  always @(posedge clk) begin
    if (!rst_n) capture <= 8'd0;
    else if (byte_valid) capture <= ui_in;
  end

  // Latency marker: SOP delayed by exactly 6 valid cycles
  reg [5:0] pipe;
  always @(posedge clk) begin
    if (!rst_n) pipe <= 6'd0;
    else if (byte_valid) pipe <= {pipe[4:0], sop};
  end

  assign uo_out  = {hb[7], pipe[5], capture[5:0]};
  assign uio_out = {hb[3:0], 4'b0000};

  wire _unused = &{ena, uio_in[7:2], ui_in[7:6], 1'b0};

endmodule

`default_nettype wire
