`timescale 1ns/1ns
module tb_encdec;

    // parameter k = 128;            // Key size
    // parameter r = 64;            // Rate
    // parameter a = 12;             // Initialization round no.
    // parameter b = 6;              // Intermediate round no.
    // parameter l = 40;             // Length of associated data
    // parameter y = 80;             // Length of Plain Text
    // parameter TI = 1;
    // parameter FP = 0;

    parameter PERIOD = 20;          // Clock frequency
    parameter max = (`k>=`y && `k>=`l)? `k: ((`y>=`l)? `y: `l);

    reg       clk = 0;
    reg       rst;
    reg       keyxSI;
    reg       noncexSI;
    reg       associated_dataxSI;
    reg       cipher_textxSI;
    reg       decryption_startxSI;
    reg       decrypt;

    integer ctr = 0;
    reg [`y-1:0] cipher_text, plain_text;
    reg [127:0] tag;

    wire  plain_textxSO;
    wire  tagxSO;
    wire  decryption_readyxSO;
    integer check_time;

    // parameter KEY = 'h2db083053e848cefa30007336c47a5a1;
    // parameter NONCE = 'h3f3607dbce3503ba84f5843d623de056;
    // parameter AD = 'h4153434f4e;
    // parameter CT = 'h87a59a2ea49b233259e3;

    Ascon #(
        `k,`r,`a,`b,`l,`y
    ) uut (
        clk,
        rst,
        keyxSI,
        noncexSI,
        associated_dataxSI,
        cipher_textxSI,
        decryption_startxSI,
        decrypt,
        plain_textxSO,
        tagxSO,
        decryption_readyxSO
    );

    // Clock Generator of 10ns
    always #(PERIOD) clk = ~clk;

    task write;
    input [max-1:0] rd, i, key, nonce, ass_data, ct; 
    begin
        @(posedge clk);
        keyxSI = key[`k-1-i];
        noncexSI = nonce[127-i];
        cipher_textxSI = ct[`y-1-i];
        associated_dataxSI = ass_data[`l-1-i];
    end
    endtask

    task read_dec;
    input integer i;
    begin
        @(posedge clk);
        plain_text[i] = plain_textxSO;
        tag[i] = tagxSO;
    end
    endtask


    task read_enc;
    input integer i;
    begin
        @(posedge clk);
        cipher_text[i] = plain_textxSO;
        tag[i] = tagxSO;
    end
    endtask

    initial begin
        $dumpfile("test.vcd");
        $dumpvars;
        $display("Start!");

        $display("Start encryption!");
        decrypt = 0;
        rst = 1;
        #(1.5*PERIOD)
        rst = 0;
        ctr = 0;
        repeat(max) begin
            write($random, ctr, `KEY, `NONCE, `AD, `PT);
            ctr = ctr + 1;
        end
        ctr = 0;
        decryption_startxSI = 1;
        check_time = $time;
        $display("Key:\t%h", uut.key);
        $display("Nonce:\t%h", uut.nonce);
        $display("AD:\t%h", uut.associated_data);
        $display("PT:\t%h", uut.input_data);
        #(4.5*PERIOD)
        decryption_startxSI = 0;

        #(500*PERIOD)

        $display("Start decryption!");
        decrypt = 1;
        rst = 1;
        #(2.5*PERIOD)
        rst = 0;
        ctr = 0;
        repeat(max) begin
            write($random, ctr, `KEY, `NONCE, `AD, `CT);
            ctr = ctr + 1;
        end
        ctr = 0;
        decryption_startxSI = 1;
        check_time = $time;
        #(0.5*PERIOD)
        $display("Key:\t%h", uut.key);
        $display("Nonce:\t%h", uut.nonce);
        $display("AD:\t%h", uut.associated_data);
        $display("CT:\t%h", uut.input_data);
        #(4.5*PERIOD)
        decryption_startxSI = 0;
    end

    always @(*) begin
        if(decryption_readyxSO) begin
            if (uut.flag_dec) begin
                check_time = $time - check_time;
                $display("Decryption Done! It took%d clock cycles", check_time/(2*PERIOD));
                #(4*PERIOD)
                repeat(max) begin
                    read_dec(ctr);
                    ctr = ctr + 1;
                end
                $display("PT:\t%h", plain_text);
                $display("Tag:\t%h", tag);
                $finish;
            end else begin
                check_time = $time - check_time;
                $display("Encryption Done! It took%d clock cycles", check_time/(2*PERIOD));
                #(4*PERIOD)
                repeat(max) begin
                    read_enc(ctr);
                    ctr = ctr + 1;
                end
                $display("CT:\t%h", cipher_text);
                $display("Tag:\t%h", tag);
                //$finish;
            end
        end
    end
endmodule
