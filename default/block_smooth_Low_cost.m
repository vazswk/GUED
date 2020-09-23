function neigbor_block = block_smooth_Low_cost(inv_J)
inv_J = 1./(inv_J+10^(-10));
HW = [0.25 0.25 0.25; 0.25 1 0.25; 0.25 0.25 0.25];
HW = HW/sum(HW(:));
neigbor_block = imfilter(inv_J,HW,'symmetric');

