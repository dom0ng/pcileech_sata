module x4_AHCI_GPT(
    input               rst,
    input               clk,
    output  wire        int_enable,
    input [31:0]        wr_addr,
    input [3:0]         wr_be,
    input [31:0]        wr_data,
    input               wr_valid,
    input  [87:0]       rd_req_ctx,
    input  [31:0]       rd_req_addr,
    input  [3:0]        rd_req_be,
    input               rd_req_valid,
    input  [31:0]       base_address_register,
    output bit [87:0]   rd_rsp_ctx,
    output bit [31:0]   rd_rsp_data,
    input               BAR_INT,
    output bit          rd_rsp_valid
);
  
    bit [87:0]      drd_req_ctx;
    bit [31:0]      drd_req_addr;
    bit [3:0]       drd_req_be;
    bit             drd_req_valid;
    
    bit [3:0]       dwr_be;
    bit [31:0]      dwr_addr;
    bit [31:0]      dwr_data;
    bit             dwr_valid;

    bit [31:0]      data_32;
    bit [7:0]       cmd;
    bit [15:0]      int_status;
    bit [15:0]      int_mask;
    
    always @ ( posedge clk ) begin
        if (rst) begin
            data_32 <= 0;
            int_mask <= 16'b0;
            int_status <= 16'b0;
        end
        
        drd_req_ctx     <= rd_req_ctx;
        drd_req_valid   <= rd_req_valid;
        dwr_valid       <= wr_valid;
        drd_req_addr    <= rd_req_addr;
        drd_req_be      <= rd_req_be;
        rd_rsp_ctx      <= drd_req_ctx;
        rd_rsp_valid    <= drd_req_valid;
        dwr_addr        <= wr_addr;
        dwr_data        <= wr_data;
        dwr_be          <= wr_be;

        if (drd_req_valid) begin
            case (({drd_req_addr[31:24], drd_req_addr[23:16], drd_req_addr[15:08], drd_req_addr[07:00]} - (base_address_register & 32'hFFFFFFF0)) & 32'hFFFF)
                // AHCI Control Registers
                16'h0000 : rd_rsp_data <= 32'h275C8086;  // 
                16'h0004 : rd_rsp_data <= 32'h80000030;  // 
                16'h0008 : rd_rsp_data <= 32'h00000013;  // 
                16'h000C : rd_rsp_data <= 32'h0000000F;  // 
                16'h0010 : rd_rsp_data <= 32'h00000101;  // 
                16'h001C : rd_rsp_data <= 32'h01600002;  // Interrupt vector
                16'h0020 : rd_rsp_data <= 32'h07010000;  // AHCI control
                16'h0024 : rd_rsp_data <= 32'h0000003C;  // AHCI ports implemented

                // Port 0 Registers
                16'h0100 : rd_rsp_data <= 32'hC0000000;  // Port 0 Command List Base Address
                16'h0108 : rd_rsp_data <= 32'hC0002000;  // Port 0 FIS Base Address
                16'h0114 : rd_rsp_data <= 32'h00000000;  // Port 0 Interrupt Status
                16'h0118 : rd_rsp_data <= 32'h00000000;  // Port 0 Interrupt Enable
                16'h0120 : rd_rsp_data <= 32'h00000001;  // Port 0 Command Status
                16'h0124 : rd_rsp_data <= 32'h00000001;  // Port 0 Task File Data
                16'h0128 : rd_rsp_data <= 32'h00000113;  // Port 0 Signature
				
				
				 // Port 0 Registers
                // 16'h0100: rd_rsp_data <= 32'h000001FF;  // Port 0 Status (Phy offline)
                // 16'h0104: rd_rsp_data <= 32'h00000000;  // Port 0 - No external SATA
                // 16'h0108: rd_rsp_data <= 32'h00000000;  // Port 0 - No hot plug
                // 16'h010C: rd_rsp_data <= 32'h00000000;  // Reserved

                // Port 1 Registers
                16'h0180 : rd_rsp_data <= 32'hC0004000;  // Port 1 Command List Base Address
                16'h0188 : rd_rsp_data <= 32'hC0006000;  // Port 1 FIS Base Address
                16'h0194 : rd_rsp_data <= 32'h00000000;  // Port 1 Interrupt Status
                16'h0198 : rd_rsp_data <= 32'h00000000;  // Port 1 Interrupt Enable
                16'h01A0 : rd_rsp_data <= 32'h00000001;  // Port 1 Command Status
                16'h01A4 : rd_rsp_data <= 32'h00000001;  // Port 1 Task File Data
                16'h01A8 : rd_rsp_data <= 32'h00000113;  // Port 1 Signature
				
				// Port 1 Registers
                // 16'h0180: rd_rsp_data <= 32'h000001FF;  // Port 1 Status (Phy offline)
                // 16'h0184: rd_rsp_data <= 32'h00000000;  // Port 1 - No external SATA
                // 16'h0188: rd_rsp_data <= 32'h00000000;  // Port 1 - No hot plug
                // 16'h018C: rd_rsp_data <= 32'h00000000;  // Reserved

                // Port 2 Registers
                16'h0200 : rd_rsp_data <= 32'hC0008000;  // Port 2 Command List Base Address
                16'h0208 : rd_rsp_data <= 32'hC000A000;  // Port 2 FIS Base Address
                16'h0214 : rd_rsp_data <= 32'h00000000;  // Port 2 Interrupt Status
                16'h0218 : rd_rsp_data <= 32'h00000000;  // Port 2 Interrupt Enable
                16'h0220 : rd_rsp_data <= 32'h00000001;  // Port 2 Command Status
                16'h0224 : rd_rsp_data <= 32'h00000001;  // Port 2 Task File Data
                16'h0228 : rd_rsp_data <= 32'h00000113;  // Port 2 Signature
				
				// Port 2 Registers
                // 16'h0200: rd_rsp_data <= 32'h000001FF;  // Port 2 Status (Phy offline)
                // 16'h0204: rd_rsp_data <= 32'h00000000;  // Port 2 - No external SATA
                // 16'h0208: rd_rsp_data <= 32'h00000000;  // Port 2 - No hot plug
                // 16'h020C: rd_rsp_data <= 32'h00000000;  // Reserved

                // Port 3 Registers
                16'h0280 : rd_rsp_data <= 32'hC000C000;  // Port 3 Command List Base Address
                16'h0288 : rd_rsp_data <= 32'hC000E000;  // Port 3 FIS Base Address
                16'h0294 : rd_rsp_data <= 32'h00000000;  // Port 3 Interrupt Status
                16'h0298 : rd_rsp_data <= 32'h00000000;  // Port 3 Interrupt Enable
                16'h02A0 : rd_rsp_data <= 32'h00000001;  // Port 3 Command Status
                16'h02A4 : rd_rsp_data <= 32'h00000001;  // Port 3 Task File Data
                16'h02A8 : rd_rsp_data <= 32'h00000113;  // Port 3 Signature
				
				// Port 3 Registers
                // 16'h0280: rd_rsp_data <= 32'h000001FF;  // Port 3 Status (Phy offline)
                // 16'h0284: rd_rsp_data <= 32'h00000000;  // Port 3 - No external SATA
                // 16'h0288: rd_rsp_data <= 32'h00000000;  // Port 3 - No hot plug
                // 16'h028C: rd_rsp_data <= 32'h00000000;  // Reserved

                default : rd_rsp_data <= 32'h0;
            endcase
        end else if (dwr_valid) begin
            case (({dwr_addr[31:24], dwr_addr[23:16], dwr_addr[15:08], dwr_addr[07:00]} - (base_address_register & 32'hFFFFFFF0)) & 32'hFFFF)
                16'h0020: begin // 
                    if (dwr_be[0]) cmd <= dwr_data[7:0];
                end
                default: begin end
            endcase
        end else begin
            rd_rsp_data <= 32'h0;
        end
    end

    bit[31:0] int_start_cnt = 0;
    always @ (posedge clk) begin
        if (rst) begin
            int_start_cnt <= 0;
        end else if (int_start_cnt <= 32'd1000000) begin
            int_start_cnt <= int_start_cnt + 1'b1;
        end
    end
    
    assign int_enable = (int_start_cnt >= 32'd1000000) && BAR_INT;

endmodule