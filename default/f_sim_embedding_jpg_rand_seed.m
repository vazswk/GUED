function stego = f_sim_embedding_jpg_rand_seed(cover, costmat, payload,nz_number)

%% Get embedding costs
% inicialization
cover = double(cover);
wetCost = 10^10;
% compute embedding costs \rho
rhoA = costmat;
rhoP1 = rhoA;
rhoM1 = rhoA;

rhoP1(rhoP1 > wetCost) = wetCost; % threshold on the costs
rhoP1(isnan(rhoP1)) = wetCost; % if all xi{} are zero threshold the cost 
rhoP1(cover > 1023) = wetCost;

rhoM1(rhoM1 > wetCost) = wetCost; % threshold on the costs
rhoM1(isnan(rhoM1)) = wetCost; % if all xi{} are zero threshold the cost 
rhoM1(cover < -1023) = wetCost;
stego = f_EmbeddingSimulator_seed(cover, rhoP1, rhoM1, floor(payload*nz_number)); 

