%% Question 1

clear all
close all
clc

% part A
A = imread('Brain_MRI.png');
gray_A = rgb2gray(A);
figure('Name','Part A // RGB_GRAY')
montage({A,gray_A})
title(" RGB vs GRAY ",'interpreter' ,'latex')


% part B
my_gray_A = my_rgb2gray(A);
figure('Name','Part B // My_Gray vs Matlab Gray')
montage({my_gray_A,gray_A})
title(" my GRAY image vs matlab GRAY image ",'interpreter' ,'latex')



% part C
imwrite(my_gray_A ,'gray_Brain_MRI.png');


%% Question 2
clear all
close all
clc


A = imread('Hist.tif');
A1 = histeq(A);
A2 = adapthisteq(A,'NumTiles',[7 7]);
montage({ A , A1 , A , A2 })
title("results of HE and AHE on the image ",'interpreter' ,'latex')

figure()
subplot(3,1,1)
imhist(A)
title("image histogram",'interpreter' ,'latex')
subplot(3,1,2)
imhist(A1)
title("HE histogram",'interpreter' ,'latex')
subplot(3,1,3)
imhist(A2)
title("AHE histogram", 'interpreter' ,'latex')


%% Question 3
close all
clear all
clc

% part A
A = imread('heart_ct.jpg');

% part B
B1 = imnoise(A,'gaussian', 0 ,0.01);
B2 = imnoise(A,'gaussian', 0 , 0.02);
B3 = imnoise(A,'gaussian', 0.1 , 0.05);
C1 = imnoise(A,'salt & pepper', 0.01);
C2 = imnoise(A,'salt & pepper', 0.02);
C3 = imnoise(A,'salt & pepper', 0.05);



figure()
subplot(2,3,1)
imshow(B1)
title("Gaussian , mean =0  var = 0.01 ",'interpreter' ,'latex')
subplot(2,3,2)
imshow(B2)
title("Gaussian , mean =0  var = 0.02 ",'interpreter' ,'latex')
subplot(2,3,3)
imshow(B3)
title("Gaussian , mean =0.1  var = 0.05 ",'interpreter' ,'latex')
subplot(2,3,4)
imshow(C1)
title("salt and pepper , density = 0.01 ",'interpreter' ,'latex')
subplot(2,3,5)
imshow(C2)
title("salt and pepper , density = 0.02 ",'interpreter' ,'latex')
subplot(2,3,6)
imshow(C3)
title("salt and pepper , density = 0.05 ",'interpreter' ,'latex')


% part C

h_3 = ones(3)/9;
B1_3 = imfilter(B1,h_3,'conv');
B2_3 = imfilter(B2,h_3,'conv');
B3_3 = imfilter(B3,h_3,'conv');
C1_3 = imfilter(C1,h_3,'conv');
C2_3 = imfilter(C2,h_3,'conv');
C3_3 = imfilter(C3,h_3,'conv');
figure()
montage({ B1_3 , B2_3 , B3_3 , C1_3 ,C2_3 ,C3_3 })
title('filtered with mean filter of size(3)' , 'interpreter' , 'latex')


h_5 = ones(5)/25;
B1_5 = imfilter(B1,h_5,'conv');
B2_5 = imfilter(B2,h_5,'conv');
B3_5 = imfilter(B3,h_5,'conv');
C1_5 = imfilter(C1,h_5,'conv');
C2_5 = imfilter(C2,h_5,'conv');
C3_5 = imfilter(C3,h_5,'conv');
figure()
montage({ B1_5 , B2_5 , B3_5 , C1_5 ,C2_5 ,C3_5 })
title('filtered with mean filter of size(5)' , 'interpreter' , 'latex')


h_7 = ones(7)/49;
B1_7 = imfilter(B1,h_7,'conv');
B2_7 = imfilter(B2,h_7,'conv');
B3_7 = imfilter(B3,h_7,'conv');
C1_7 = imfilter(C1,h_7,'conv');
C2_7 = imfilter(C2,h_7,'conv');
C3_7 = imfilter(C3,h_7,'conv');
figure()
montage({ B1_7 , B2_7 , B3_7 , C1_7 ,C2_7 ,C3_7 })
title('filtered with mean filter of size(7)' , 'interpreter' , 'latex')

%%  Question 4 

close all
clear all
clc

A = imread('retina.png');

A = double(A);

A_logscaled = uint8( (255/log10(256)) * log10( A + ones(size(A))) ) ;


montage({ uint8(A) , A_logscaled })
title( " logscaled ", 'interpreter' , 'latex')

A_powscaled = uint8( 255* ( A / 255 ).^1.6 ) ;

figure()
montage({ uint8(A) , A_powscaled })
title( " powerscaled gamma = 1.6 ", 'interpreter' , 'latex')

%% Question 4 _ investigating which parameter is suitable for power scaling transformation

close all
clear all
clc

A = imread('retina.png');

A = double(A);
for i = 0.5 : 0.1 : 3   
    A_powscaled = uint8( 255* ( A / 255 ).^i ) ;
    subplot(1,2,1)
    imshow(uint8(A))
    title( " before transformation ", 'interpreter' , 'latex')
    subplot(1,2,2)
    imshow(A_powscaled)
    title( [" powerscaled gamma =" ,num2str(i)] , 'interpreter' , 'latex')
    pause(0.5);

end


%% Question 5

close all
clear all
clc

A = imread('retina.png');
B = A;
C = A;
D = A; 

B(find(B>=200)) = 255 ;
B(find(B<200)) = 0 ;
montage({ D , B })
title(" only seting a threshold ", 'interpreter' , 'latex');

h = ones(3)/9;
A = imfilter(A,h,'conv');
A(find(A>=200)) = 255 ;
A(find(A<200)) = 0 ;
figure()
montage({ D , A })
title("seting a threshold after mean filtering ", 'interpreter' , 'latex');

C(find(C>=200)) = 255 ;
C(find(C<200)) = 0 ;
C = imfilter(C,h,'conv');
figure()
montage({ D , C })
title(" mean filtering after seting a threshold ", 'interpreter' , 'latex');



