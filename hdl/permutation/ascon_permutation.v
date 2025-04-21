module Permutation (
    input           clk,
    input           reset,
    input   [4:0]   ctr,       // Bộ đếm chu kỳ (0 đến 5 cho 6 chu kỳ)
    input   [319:0] S,
    input   [4:0]   rounds,    // Vẫn là 12 để khớp với ASCON
    input           start,
    output  [319:0] out,
    output          done
);

    reg [63:0] x0_q, x1_q, x2_q, x3_q, x4_q;
    wire [63:0] x0_d1, x1_d1, x2_d1, x3_d1, x4_d1;  // Kết quả vòng 1 trong chu kỳ
    wire [63:0] x0_d2, x1_d2, x2_d2, x3_d2, x4_d2;  // Kết quả vòng 2 trong chu kỳ
    reg Done;

    always @(posedge clk) begin
        if (reset)
            {x0_q, x1_q, x2_q, x3_q, x4_q, Done} <= 0;
        else if (start) begin
            if (ctr == 0)
                {x0_q, x1_q, x2_q, x3_q, x4_q} <= S;
            else
                {x0_q, x1_q, x2_q, x3_q, x4_q} <= {x0_d2, x1_d2, x2_d2, x3_d2, x4_d2};
        end
        Done <= (ctr == (rounds >> 1));  // 12 vòng chia 2 = 6 chu kỳ
    end

    assign done = Done;
    assign out = {x0_q, x1_q, x2_q, x3_q, x4_q};

    // Define intermediate signals with explicit 5-bit width
    wire [4:0] ctr_round1 = (ctr * 2 - 1);  // Vòng 1, 3, 5, 7, 9, 11
    wire [4:0] ctr_round2 = (ctr * 2);      // Vòng 2, 4, 6, 8, 10, 12

    // Vòng 1 trong chu kỳ
    wire [63:0] rc_out1;
    roundconstant u0 (
        .x2(x2_q),
        .ctr(ctr_round1),  // Truyền 5-bit
        .out(rc_out1),
        .rounds(rounds)
    );

    wire [63:0] sl0_1, sl1_1, sl2_1, sl3_1, sl4_1;
    sub_layer u1 (
        .x0(x0_q), .x1(x1_q), .x2(rc_out1), .x3(x3_q), .x4(x4_q),
        .sl0(sl0_1), .sl1(sl1_1), .sl2(sl2_1), .sl3(sl3_1), .sl4(sl4_1)
    );

    linear_layer u2 (
        .X0(sl0_1), .X1(sl1_1), .X2(sl2_1), .X3(sl3_1), .X4(sl4_1),
        .Y0(x0_d1), .Y1(x1_d1), .Y2(x2_d1), .Y3(x3_d1), .Y4(x4_d1)
    );

    // Vòng 2 trong chu kỳ
    wire [63:0] rc_out2;
    roundconstant u3 (
        .x2(x2_d1),
        .ctr(ctr_round2),  // Truyền 5-bit
        .out(rc_out2),
        .rounds(rounds)
    );

    wire [63:0] sl0_2, sl1_2, sl2_2, sl3_2, sl4_2;
    sub_layer u4 (
        .x0(x0_d1), .x1(x1_d1), .x2(rc_out2), .x3(x3_d1), .x4(x4_d1),
        .sl0(sl0_2), .sl1(sl1_2), .sl2(sl2_2), .sl3(sl3_2), .sl4(sl4_2)
    );

    linear_layer u5 (
        .X0(sl0_2), .X1(sl1_2), .X2(sl2_2), .X3(sl3_2), .X4(sl4_2),
        .Y0(x0_d2), .Y1(x1_d2), .Y2(x2_d2), .Y3(x3_d2), .Y4(x4_d2)
    );
endmodule