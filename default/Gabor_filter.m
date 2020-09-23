function avr_residuals = Gabor_filter(IMAGE,NR)
%% parameters 
% Input:  IMAGE .. path to the JPEG image 
%         NR  .... number of rotations for Gabor kernel 
%% 
I_STRUCT = jpeg_read(IMAGE);

Rotations = (0:NR-1)*pi/NR;
sr=numel(Rotations);

% Standard deviations
Sigma = [0.5 0.75 1 1.25];
ss=numel(Sigma);

PhaseShift = [0 pi/2];
sp=numel(PhaseShift);

AspectRatio = 0.5;

% Decompress to spatial domain
fun = @(x)x.data .*I_STRUCT.quant_tables{1};
I_spatial = blockproc(I_STRUCT.coef_arrays{1},[8 8],fun);
fun=@(x)idct2(x.data);
I_spatial = blockproc(I_spatial,[8 8],fun);


% Load Gabor Kernels
Kernel = cell(ss,sr,sp);
for S = Sigma
    for R = Rotations
        for P=PhaseShift
        Kernel{S==Sigma,R==Rotations,P==PhaseShift} = gaborkernel(S, R, P, AspectRatio);
        end
    end
end

residuals = zeros(size(I_spatial));
sizeCover=size(I_spatial);
for mode_P=1:sp
    for mode_S = 1:ss  
        for mode_R = 1:sr  
            filters = Kernel{mode_S,mode_R,mode_P};
            padsize=max(size(filters));
            coverPadded = padarray(I_spatial, [padsize padsize], 'symmetric');% add padding
            residual = conv2(coverPadded, filters, 'same');
            W1 = abs(residual);
            if mod(size(filters, 1), 2) == 0, W1= circshift(W1, [1, 0]); end;
            if mod(size(filters, 2), 2) == 0, W1 = circshift(W1, [0, 1]); end;
            W1 = W1(((size(W1, 1)-sizeCover(1))/2)+1:end-((size(W1, 1)-sizeCover(1))/2), ((size(W1, 2)-sizeCover(2))/2)+1:end-((size(W1, 2)-sizeCover(2))/2));
            residuals = residuals + W1;
        end      
    end       
end
avr_residuals =  residuals/(sp*ss*sr);

end





















