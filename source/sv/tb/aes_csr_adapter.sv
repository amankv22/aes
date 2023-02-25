module aes_csr_adapter #(parameter ADDR_WIDTH=32, DATA_WIDTH=32) (
  input logic clk_i,
  input logic rst_ni,
  input logic [ADDR_WIDTH-1:0] addr,
  input logic [DATA_WIDTH-1:0] wdata,
  input logic [DATA_WIDTH-1:0] rdata
);

//---------------------------------------- Main logic -----------------------------------------

  logic wr;
  logic rd;

  assign wr = wr_en && acc_en;
  assign rd = (!wr_en) && acc_en;
//---------------------------------------------------------------------------------------------

//-------------------------------------- Instantiations ---------------------------------------

  // Instantiate CSR Proof Accelerator (PA)
  jasper_csr_checker #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) inst_jasper_csr_checker
  (
    .rstN(rst_ni),
    .clk(clk_i),
    .wr(wr),
    .rd(rd),
    .addr(addr),
    .din(wdata),
    .dout(rdata)
    );
//---------------------------------------------------------------------------------------------

endmodule

bind aes aes_csr_adapter #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) aes_csr_adapter
  (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .addr(aes.tl_i.a_address),
    .wdata(aes.tl_i.a_data),
    .rdata(aes.tl_o.d_data)
  );
