function kernel = gaborkernel(sigma, theta, phi, gamma)
lambda = sigma / 0.56;
gamma2 = gamma^2;
s = 1 / (2*sigma^2);
f = 2*pi/lambda;
% sampling points for Gabor function
[x,y]=meshgrid([-7/2:-1/2,1/2:7/2],[-7/2:-1/2,1/2:7/2]);
y = -y;
xp =  x * cos(theta) + y * sin(theta);
yp = -x * sin(theta) + y * cos(theta);
kernel = exp(-s*(xp.*xp + gamma2*(yp.*yp))) .* cos(f*xp + phi);
% normalization
kernel = kernel- sum(kernel(:))/sum(abs(kernel(:)))*abs(kernel);