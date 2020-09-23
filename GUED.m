%% mian.m
clc;clear all;
currdir = pwd;
input  = [currdir '\Cover\Q75'];
output = [currdir '\Stego\Q75' ];

QF = 75;
rate = 0.4; 
flist = dir([input '\*.jpg']);
flen = length(flist);
fprintf('%s%d\n', 'the num of the files: ',flen);   
for i = 1: flen   
    p = (1.2+0.1*(QF-75)/20)*rate + 0.44 + 0.11*(QF-75)/20;
    q = (1.4-0.1*(QF-75)/20)*rate + 0.54 + 0.29*(QF-75)/20;
    
    fprintf('%d%s\n',i, ['      processing image: ' flist(i).name]);
    in_file_name = [input '\' flist(i).name];
    stego_name   = [output '\' flist(i).name];

    img = jpeg_read(in_file_name);
    dct_coef = double(img.coef_arrays{1}); 

    dct_coef2 = dct_coef;
    [img_h, img_w] = size(dct_coef);
    dct_coef2(1:8:end,1:8:end) = 0;
    nz_index = find(dct_coef2 ~=0);
    nz_number = length(nz_index);    

    orig_message = reshape(dct_coef,1, img_h*img_w);

    avar_wavelet_Impact =  Cal_on_wavelet(in_file_name);
    avar_wavelet_Impact = avar_wavelet_Impact.^p;    
    avar_wavelet_Impact(1,1) = 0.5*(avar_wavelet_Impact(2,1) + avar_wavelet_Impact(1,2));                        
    avar_wavelet_Impact_matrix = repmat(avar_wavelet_Impact,[64 64]);                   
    q_matrix = avar_wavelet_Impact_matrix;
    tic
    cost_block = block_energy(in_file_name,12);
    sqr_complex_block = (cost_block).^q;
    J2 = sqr_complex_block (:);
    J = ones(64,1)*J2';
    J = col2im(J,[8 8], [512 512], 'distinct'); 
    decide = q_matrix .* J;
    toc

    decide = reshape(decide,1, img_h*img_w);
    stego = f_sim_embedding_jpg_rand_seed(orig_message, decide, rate,nz_number);% Embed the secret message
    S_struct = img;
    S_struct.coef_arrays{1} = reshape(stego,size(dct_coef));    
    jpeg_write(S_struct, stego_name); 
end  
 
 
 
 
 