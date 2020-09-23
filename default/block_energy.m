function cost_block = block_energy(in_file_name,NR)
avr_residuals = Gabor_filter(in_file_name,NR);
complex_block = zeros(64,64);
for block_R_M = 1:64
    for block_R_N = 1:64
        complex_block(block_R_M,block_R_N)  = sum(sum(avr_residuals((block_R_M-1)*8+1:block_R_M*8,(block_R_N-1)*8+1:block_R_N*8)));      
    end
end
cost_block = block_smooth_Low_cost(complex_block);
end