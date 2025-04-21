module read_image;
    reg [127:0] img[1:5222]; // Định nghĩa mảng có tối đa 5222 phần tử
    integer i, count;

    initial begin
        $readmemb("/home/soysiro/AsconImgVid/test/binary.txt", img); // Đọc file vào mảng
        $dumpfile("/home/soysiro/AsconImgVid/test/binary.vcd"); // Xuất ra file VCD
        $dumpvars(0, read_image); // Xuất ra file VCD
        // Kiểm tra số phần tử thực tế được đọc
        count = 0;
        for (i = 0; i < 5222; i = i + 1) begin
            if (img[i] !== 128'bx) begin // Nếu có dữ liệu hợp lệ
                count = count + 1;
            end
        end

        $display("Total lines read into array: %d", count);
        $finish;
    end
endmodule
