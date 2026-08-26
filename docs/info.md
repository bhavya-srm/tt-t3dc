## How it works

Fixed-latency tick-to-trade decision core. Market data messages arrive
byte-parallel on `ui_in`, framed by `SOP` and qualified by `BYTE_VALID`.
The price field is compared against four preloaded thresholds, and the
resulting fire signals appear on `uo_out` a constant number of valid
cycles after `SOP`, independent of message content.

## How to test

Drive `ui_in` with message bytes, one per clock, asserting `SOP` on the
first byte and `BYTE_VALID` on each valid byte. Observe `LAT_MARKER`
(`uo[5]`), which pulses a fixed number of cycles after every `SOP`.

## External hardware

None. Optionally a logic analyser or PMOD-connected FPGA on the input
pins for latency characterisation.
