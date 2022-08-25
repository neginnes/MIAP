%% Question 1 
clear all
close all
clc
% Part A 

Im = phantom('Modified Shepp-Logan',500);
noisy_Im = imnoise(Im,'gaussian',0,0.05^2);

figure("Name",'Part A')
subplot(1,2,1)
imshow(Im)
title(" main image ",'interpreter' ,'latex')
subplot(1,2,2)
imshow(noisy_Im)
title(" noisy image ",'interpreter' ,'latex')

% Part B
n = 3 ;
denoised_Im = NLM_filter(noisy_Im , n );

figure("Name",'Part B')
subplot(1,3,1)
imshow(Im)
title(" main image ",'interpreter' ,'latex')
subplot(1,3,2)
imshow(noisy_Im)
title(" noisy image ",'interpreter' ,'latex')
subplot(1,3,3)
imshow(denoised_Im)
title(" denoised image ",'interpreter' ,'latex')

% Part C 

snr_noisy = SNR(Im,noisy_Im) 
snr = SNR(Im,denoised_Im) 
epi = EPI(Im, denoised_Im) 

%% Question 2

clear all
close all
clc
% Part B 

Im = phantom('Modified Shepp-Logan',500);
noisy_Im = imnoise(Im,'gaussian',0,0.05^2);
hx = 1.2;
hg = 0.09;
denoised_Im = Bilateral_filter (noisy_Im,hx,hg);
figure("Name",'Part B')
subplot(1,3,1)
imshow(Im)
title(" main image ",'interpreter' ,'latex')
subplot(1,3,2)
imshow(noisy_Im)
title(" noisy image ",'interpreter' ,'latex')
subplot(1,3,3)
imshow(denoised_Im)
title(" denoised image ",'interpreter' ,'latex')

% Part C

snr_noisy = SNR(Im,noisy_Im) 
snr = SNR(Im,denoised_Im) 
epi = EPI(Im, denoised_Im) 

%% Question3
clear all
close all
clc
% Part A

Im = phantom('Modified Shepp-Logan',500);
noisy_Im = imnoise(Im,'gaussian',0,0.05^2);
lamda = 10 ;
iteration_number = 100 ;
dt = 0.01 ;
denoised_Im = TotalVariation_filter(noisy_Im ,lamda,iteration_number,dt);

figure("Name",'Part A')
subplot(1,3,1)
imshow(Im)
title(" main image ",'interpreter' ,'latex')
subplot(1,3,2)
imshow(noisy_Im)
title(" noisy image ",'interpreter' ,'latex')
subplot(1,3,3)
imshow(denoised_Im)
title(" denoised image ",'interpreter' ,'latex')

% Part B

snr_noisy = SNR(Im,noisy_Im) 
snr = SNR(Im,denoised_Im) 
epi = EPI(Im, denoised_Im) 

%% Question 4
clear all
close all
clc

Im = phantom('Modified Shepp-Logan',500);
noisy_Im = imnoise(Im,'gaussian',0,0.05^2);

n = 3 ;
denoised_Im1 = NLM_filter(noisy_Im , n );
snr_noisy = SNR(Im,noisy_Im)
epi_noisy = EPI(Im,noisy_Im)
snr1 = SNR(Im,denoised_Im1) 
epi1 = EPI(Im, denoised_Im1)

hx = 1.2;
hg = 0.09;
denoised_Im2 = Bilateral_filter (noisy_Im,hx,hg);
snr2 = SNR(Im,denoised_Im2) 
epi2 = EPI(Im, denoised_Im2)

lamda = 10 ;
iteration_number = 100 ;
dt = 0.01 ;
denoised_Im3 = TotalVariation_filter(noisy_Im ,lamda,iteration_number,dt);
snr3 = SNR(Im,denoised_Im3) 
epi3 = EPI(Im, denoised_Im3)
