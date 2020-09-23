function   avar_wavelet_Impact =  Cal_on_wavelet(coverPath)
C_STRUCT = jpeg_read(coverPath);
C_QUANT = C_STRUCT.quant_tables{1};

%% Pre-compute impact in spatial domain when a jpeg coefficient is changed by 1
spatialImpact = cell(8, 8);
for bcoord_i=1:8
    for bcoord_j=1:8
        testCoeffs = zeros(8, 8);
        testCoeffs(bcoord_i, bcoord_j) = 1;
        spatialImpact{bcoord_i, bcoord_j} = idct2(testCoeffs)*C_QUANT(bcoord_i, bcoord_j);  %修改每一个DCT系数之后，计算其对应的8*8空域受到的影响
    end
end

%% Get 2D wavelet filters - Daubechies 8
% 1D high pass decomposition filter
hpdf = [-0.0544158422, 0.3128715909, -0.6756307363, 0.5853546837, 0.0158291053, -0.2840155430, -0.0004724846, 0.1287474266, 0.0173693010, -0.0440882539, ...
        -0.0139810279, 0.0087460940, 0.0048703530, -0.0003917404, -0.0006754494, -0.0001174768];
% 1D low pass decomposition filter
lpdf = (-1).^(0:numel(hpdf)-1).*fliplr(hpdf);

F{1} = lpdf'*hpdf;
F{2} = hpdf'*lpdf;
F{3} = hpdf'*hpdf;

%% Pre compute impact on wavelet coefficients when a jpeg coefficient is changed by 1
waveletImpact = cell(numel(F), 8, 8); %每个元素对应23*23的矩阵
for Findex = 1:numel(F)
    for bcoord_i=1:8
        for bcoord_j=1:8
            waveletImpact_temp = conv2(spatialImpact{bcoord_i, bcoord_j}, F{Findex}, 'full');
            waveletImpact{Findex, bcoord_i, bcoord_j} = sum( abs(waveletImpact_temp(:)))/(23*23);
        end
    end   
end

avar_wavelet_Impact = zeros(8, 8);
for bcoord_i=1:8
    for bcoord_j=1:8
      avar_wavelet_Impact(bcoord_i, bcoord_j) = ( waveletImpact{1, bcoord_i, bcoord_j} + waveletImpact{2, bcoord_i, bcoord_j} + waveletImpact{3, bcoord_i, bcoord_j})/3; 
    end
end