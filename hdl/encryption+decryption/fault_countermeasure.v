// Fault countermeasure
module FC #(
    parameter k = 128,            // Key size
    parameter r = 128,            // Rate
    parameter a = 12,             // Initialization round no.
    parameter b = 6,              // Intermediate round no.
    parameter l = 40,             // Length of associated data
    parameter y = 40,             // Length of Plain Text
)(
    input           clk,
    input           rst,
    input  [k-1:0]  key, random_key_1, random_key_2, random_key_3, random_key_4,
    input  [127:0]  nonce, random_nonce_1, random_nonce_2, random_nonce_3, random_nonce_4,
    input  [l-1:0]  associated_data, random_ad_1, random_ad_2, random_ad_3, random_ad_4,
    input  [y-1:0]  plain_text, random_pt_1, random_pt_2, random_ct_1, random_ct_2,
    input           encryption_start,
    input           decryption_start,
    input  [63:0]   r0,r1,r2,r3,r4,r5,r6,
    input  [63:0]   r7,r8,r9,r10,r11,r12,r13,
    input  [127:0]  random_fault_1, random_fault_2,
    input  [y-1:0]  random_fault_3, random_fault_4,

    output [y-1:0]  cipher_text,            // Plain text converted to cipher text
    output [y-1:0]  dec_plain_text,         // Decrypted Text
    output [127:0]  tag,                    // Final Tag after Encryption 
    output [127:0]  dec_tag,                // Tag after Decryption
    output          encryption_ready,       // To indicate the end of Encryption
    output          decryption_ready,       // To indicate the end of Decryption
    output          message_authentication  // Indicates whether the message is authenticated
);
    
    Encryption #(
        k,r,a,b,l,y
    ) d1 (
        clk,
        rst,
        key, 
        nonce, 
        associated_data,
        plain_text,
        encryption_start,
        cipher_text,
        tag,          
        encryption_ready
    );

    Decryption #(
        k,r,a,b,l,y
    ) d2 (
        clk,
        rst,
        key,
        nonce,
        associated_data,
        cipher_text,
        decryption_start,
        dec_plain_text,             
        dec_tag,                     
        decryption_ready        
        
endmodule
