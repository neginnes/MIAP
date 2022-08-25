%% Question 1

clear all
close all
clc

% part A

Original_Im = imread('city_orig.jpg');
Noisy_Im = imread('city_noise.jpg');

Original_region1 = Original_Im(1:265,1:375);
Original_region3 = Original_Im(266:530,1:375);
Original_region4 = Original_Im(266:530,376:750);
Noisy_region1 = Noisy_Im(1:265,1:375);
Noisy_region3 = Noisy_Im(266:530,1:375);
Noisy_region4 = Noisy_Im(266:530,376:750);


SNR_region1 = SNR(Original_region1,Noisy_region1);
SNR_region3 = SNR(Original_region3,Noisy_region3);
SNR_region4 = SNR(Original_region4,Noisy_region4);

h1 = ones(3)/9;
mean_filtered_Im = imfilter(Noisy_Im,h1,'conv');
SNR_region1_after_meanfilter = SNR(Original_region1,mean_filtered_Im(1:265,1:375));
SNR_region3_after_meanfilter = SNR(Original_region3,mean_filtered_Im(266:530,1:375));
SNR_region4_after_meanfilter = SNR(Original_region4,mean_filtered_Im(266:530,376:750));

h2 = [1,2,1;2,4,2;1,2,1]/16 ;
gaussian_filtered_Im = imfilter(Noisy_Im,h2,'conv');
SNR_region1_after_gaussianfilter = SNR(Original_region1,gaussian_filtered_Im(1:265,1:375));
SNR_region3_after_gaussianfilter = SNR(Original_region3,gaussian_filtered_Im(266:530,1:375));
SNR_region4_after_gaussianfilter = SNR(Original_region4,gaussian_filtered_Im(266:530,376:750));

median_filtered_Im = medfilt2(Noisy_Im,[3 3]);

SNR_region1_after_medianfilter = SNR(Original_region1,median_filtered_Im(1:265,1:375));
SNR_region3_after_medianfilter = SNR(Original_region3,median_filtered_Im(266:530,1:375));
SNR_region4_after_medianfilter = SNR(Original_region4,median_filtered_Im(266:530,376:750));

montage({Noisy_Im,mean_filtered_Im ,gaussian_filtered_Im , median_filtered_Im})
title("left,up:main noisy image  *  right,up:mean filtered image  *  left,down:gaussian filtered image  *  right,down:median filtered image" , 'interpreter' , 'latex');


%% Question 2

Im = imread('hand_xray.jpg');

% Part A
spectrum = abs(fftshift(fft2(Im)));
subplot(1,2,1)
imshow((0.1*log10(spectrum)))
title(" spectrum (logaritmic) " , 'interpreter' , 'latex')
subplot(1,2,2)
imagesc(log10(spectrum))
colorbar
title(" spectrum (logaritmic) " , 'interpreter' , 'latex')

% Part B
s = abs(fft2(Im));
light_level_Image = mean(mean(Im))
scaled_F00 = s(1,1)/size(Im,1)/size(Im,2)


%% Question 3
clear all
close all
clc

Im = imread('chessboard.jpg');

% Part A
h1 = [1 , -1];
h2 = [1 , 0];
h3 = [1 ,0, -1];
h4 = h3';
h5 = [-1,-1,-1;-1,8,-1;-1,-1,-1];

FilteredIm1 = imfilter(Im,h1,'conv');
FilteredIm2 = imfilter(Im,h2,'conv');
FilteredIm3 = imfilter(Im,h3,'conv');
FilteredIm4 = imfilter(Im,h4,'conv');
FilteredIm5 = imfilter(Im,h5,'conv');
montage({Im , FilteredIm1 , FilteredIm2 ,FilteredIm3 , FilteredIm4, FilteredIm5 });
title(" from left to right an up to down , filter 1 to 5 " , 'interpreter' , 'latex');

% Part B

Edge1 = edge(rgb2gray(Im),'sobel');
Edge2 = edge(rgb2gray(Im),'canny');
Edge3 = edge(rgb2gray(Im),'log');
figure()
subplot(2,2,1)
imshow(Im)
title(" main image " , 'interpreter' , 'latex')
subplot(2,2,2)
imshow(Edge1)
title(" sobel edge detector " , 'interpreter' , 'latex')
subplot(2,2,3)
imshow(Edge2)
title(" canny edge detector " , 'interpreter' , 'latex')
subplot(2,2,4)
imshow(Edge3)
title(" laplacian of gaussian edge detector " , 'interpreter' , 'latex')

%% Question 4
clc
close all
clear all 
Im = imread('hand_xray.jpg');
IM = fft2(Im);
IM = abs(IM) .* exp(i*(-angle(IM)));
Im2 = uint8(ifft2(IM));
montage({Im , Im2});

%% Question 5
clc
close all
clear all
Im1 = imread('hand_xray.jpg');
Im2 = imread('brain_xray.jpg');
IM1 = fft2(Im1);
IM2 = fft2(Im2);

IM_Final1 = abs(IM1) .* exp(i*angle(IM2));
Im_Final1 = uint8(ifft2(IM_Final1));

IM_Final2 = abs(IM2) .* exp(i*angle(IM1));
Im_Final2 = uint8(ifft2(IM_Final2));

montage({Im_Final1 , Im_Final2});
title("* * *  * * *   * * *   *  * * * brain phase , hand amplitiude   * * *  * * * * *   * * *   *  * * *   * hand phase , brain amplitiude  * * *  * * *   * * *   *  * * *" , 'interpreter' , 'latex');


%% Question 6
clc
close all
clear all
Im = imread('wall.jpg');

% Part A
IM = fftshift(fft2(Im));
imshow(uint8(20*log10(abs(IM))))
title(" Fourier Transform Amplitude " , 'interpreter' , 'latex')

% Part B
M = size(Im,1);
N = size(Im,2);
u = (0:(M-1))-M/2;
v = (0:(N-1))-N/2;
[V, U] = meshgrid(v, u);
D0 = 50;
D = sqrt(U.^2+V.^2);
F = D0/max(max(D));
H = double(D <= D0);
G1 = H.*IM;
filtered_Im1 = ifft2(ifftshift(G1));
figure()
montage({Im , uint8(real(filtered_Im1))});
title ("Ideal LPF" , 'interpreter','latex');

% Part C
NOT_H = 1-H;
G2 = NOT_H.*IM;
filtered_Im2 = ifft2(ifftshift(G2));
figure()
montage({Im , uint8(real(filtered_Im2))});
title ("Ideal HPF" , 'interpreter','latex');

% Part D
filtered_Im3 = imgaussfilt(Im,1, 'FilterSize' , [253,251]);
filtered_Im4 = uint8(double(Im) - double(filtered_Im3));
figure()
montage({Im ,filtered_Im3});
title (" gaussian LPF" , 'interpreter','latex');
figure()
montage({Im ,filtered_Im4});
title (" gaussian HPF" , 'interpreter','latex');

H = fspecial('laplacian');
filtered_Im5 = imfilter(Im,H,'replicate');
filtered_Im6 = uint8(double(Im) + double(filtered_Im5));
figure()
montage({Im , uint8(filtered_Im5)});
title (" laplacian HPF" , 'interpreter','latex');
figure()
montage({Im , uint8(filtered_Im6)});
title (" laplacian LPF" , 'interpreter','latex');

n = 10;
Hb = 1./(1 + (D./D0).^(2*n));
Gb = Hb.*IM;
filtered_Im7 = ifft2(ifftshift(Gb));
figure()
montage({Im , uint8(real(filtered_Im7))});
title ("butterworth LPF" , 'interpreter','latex');
figure()
montage({Im ,Im-uint8(real(filtered_Im7))});
title ("butterworth HPF" , 'interpreter','latex');





