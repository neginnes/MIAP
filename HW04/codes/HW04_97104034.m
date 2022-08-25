%% Question 1 _ Part 1
clear all
close all
clc 

Im1 = imread('Mri1.bmp');
Im2 = imread('Mri2.bmp');
Im3 = imread('Mri3.bmp');
Im4 = imread('Mri4.bmp');
Im5 = imread('Mri5.bmp');

Im123 = zeros(size(Im1,1) , size(Im1,2) , 3);
Im234 = zeros(size(Im1,1) , size(Im1,2) , 3);
Im345 = zeros(size(Im1,1) , size(Im1,2) , 3);
Im135 = zeros(size(Im1,1) , size(Im1,2) , 3);

Im123(:,:,1) = Im1 ;
Im123(:,:,2) = Im2 ;
Im123(:,:,3) = Im3 ;
Im234(:,:,1) = Im2 ;
Im234(:,:,2) = Im3 ;
Im234(:,:,3) = Im4 ;
Im345(:,:,1) = Im3 ;
Im345(:,:,2) = Im4 ;
Im345(:,:,3) = Im5 ;
Im135(:,:,1) = Im1 ;
Im135(:,:,2) = Im3 ;
Im135(:,:,3) = Im5 ;


montage({uint8(Im123),uint8(Im234) ,uint8(Im345), uint8(Im135) })
title(" TOPLEFT: MRI123 , TOPRIGHT: MRI234 , BUTTOMLEFT: MRI345 , BUTTOMRIGHT: MRI135",'interpreter' ,'latex')


%% Question 1 _ Part 2 _ soft clustering
clear all
close all
clc 

Im1 = imread('Mri1.bmp');
% Im2 = imread('Mri2.bmp');
% Im3 = imread('Mri3.bmp');
% Im4 = imread('Mri4.bmp');
% Im5 = imread('Mri5.bmp');

Nc = 5 ;
fuzzy_param = 5 ;
init_u = NaN ;
iter_num = 100 ;

data = reshape(double(Im1),[1,size(double(Im1),1)*size(double(Im1),2)]);
% [centers,U] = fcm(data,Nc,[5 NaN NaN 0]);
[center,u,J,num] = FCM(data,Nc,fuzzy_param,init_u,iter_num);
U = reshape(u,[256,256,Nc]);
for i = 1:Nc
    subplot(1,Nc,i)
    imshow(uint8(255*U(:,:,i)));
    title(string("CLUSTER"+num2str(i)),'interpreter' ,'latex');
end

%% Question 1 _ Part 2 _ hard clustering
clear all
close all
clc 

Im1 = imread('Mri1.bmp');
% Im2 = imread('Mri2.bmp');
% Im3 = imread('Mri3.bmp');
% Im4 = imread('Mri4.bmp');
% Im5 = imread('Mri5.bmp');

Nc = 5 ;
fuzzy_param = 5;
init_u = NaN ;
iter_num = 100 ;

data = reshape(double(Im1),[1,size(double(Im1),1)*size(double(Im1),2)]);
% [centers,U] = fcm(data,Nc,[5 NaN NaN 0]);
[center,u,J,num] = FCM(data,Nc,fuzzy_param,init_u,iter_num);
u = hard_treshloding(u);
U = reshape(u,[256,256,Nc]);

for i = 1:Nc
    subplot(1,Nc,i)
    imshow(uint8(255*U(:,:,i)));
    title(string("CLUSTER"+ num2str(i)),'interpreter' ,'latex');
end

%% Question 1 _ Part 3 _ soft clustering
clear all
close all
clc

Im1 = imread('Mri1.bmp');
% Im2 = imread('Mri2.bmp');
% Im3 = imread('Mri3.bmp');
% Im4 = imread('Mri4.bmp');
% Im5 = imread('Mri5.bmp');

Nc = 5;
data1 = reshape(double(Im1),[size(double(Im1),1)*size(double(Im1),2),1]);

idx = kmeans(data1,Nc);
init_u = zeros(size(double(Im1),1)*size(double(Im1),2),Nc);
L = 0 : Nc : (size(double(Im1),1)*size(double(Im1),2)-1)* Nc  ;
Idx = L' + idx ;
init_u_prime = init_u' ;
init_u_prime(Idx) = 1 ;
init_u = init_u_prime';

fuzzy_param = 1.4;
iter_num = 100 ;

data = reshape(double(Im1),[1,size(double(Im1),1)*size(double(Im1),2)]);
[center,u,J,num] = FCM(data,Nc,fuzzy_param,init_u,iter_num);
U = reshape(u,[256,256,Nc]);

for i = 1:Nc
    subplot(1,Nc,i)
    imshow(uint8(255*U(:,:,i)));
    title(string("CLUSTER"+ num2str(i)),'interpreter' ,'latex');
end

%% Question 1 _ Part 3 _ hard clustering
clear all
close all
clc

Im1 = imread('Mri1.bmp');
% Im2 = imread('Mri2.bmp');
% Im3 = imread('Mri3.bmp');
% Im4 = imread('Mri4.bmp');
% Im5 = imread('Mri5.bmp');

Nc = 5;
data1 = reshape(double(Im1),[size(double(Im1),1)*size(double(Im1),2),1]);

idx = kmeans(data1,Nc);
init_u = zeros(size(double(Im1),1)*size(double(Im1),2),Nc);
L = 0 : Nc : (size(double(Im1),1)*size(double(Im1),2)-1)* Nc  ;
Idx = L' + idx ;
init_u_prime = init_u' ;
init_u_prime(Idx) = 1 ;
init_u = init_u_prime';

fuzzy_param = 5;
iter_num = 100 ;

data = reshape(double(Im1),[1,size(double(Im1),1)*size(double(Im1),2)]);
[center,u,J,num] = FCM(data,Nc,fuzzy_param,init_u,iter_num);
u = hard_treshloding(u);
U = reshape(u,[256,256,Nc]);

for i = 1:Nc
    subplot(1,Nc,i)
    imshow(uint8(255*U(:,:,i)));
    title(string("CLUSTER"+ num2str(i)),'interpreter' ,'latex');
end

%% Question 1 _ Part 4 
clear all 
close all
clc

Im1 = double(imread('Mri1.bmp'));
Im2 = double(imread('Mri2.bmp'));
Im3 = double(imread('Mri3.bmp'));
Im4 = double(imread('Mri4.bmp'));
Im5 = double(imread('Mri5.bmp'));

data(:,1) = reshape(Im1,[size(Im1,1)*size(Im1,2) , 1]);
data(:,2) = reshape(Im2,[size(Im1,1)*size(Im1,2) , 1]);
data(:,3) = reshape(Im3,[size(Im1,1)*size(Im1,2) , 1]);
data(:,4) = reshape(Im4,[size(Im1,1)*size(Im1,2) , 1]);
data(:,5) = reshape(Im5,[size(Im1,1)*size(Im1,2) , 1]);

Nc = 5 ;

GMModel = fitgmdist(data,Nc,'RegularizationValue',0.01);
idx = cluster(GMModel,data);

u = zeros(size(double(Im1),1)*size(double(Im1),2),Nc);
L = 0 : Nc : (size(double(Im1),1)*size(double(Im1),2)-1)* Nc  ;
Idx = L' + idx ;
u_prime = u' ;
u_prime(Idx) = 1 ;
u = u_prime';

U = reshape(u,[size(double(Im1),1),size(double(Im1),2),5]);

subplot(1 , Nc , 1)
for i = 1:Nc
    subplot(1,Nc,i)
    imshow(uint8(255*U(:,:,i)));
    title(string("CLUSTER"+ num2str(i)),'interpreter' ,'latex');
end

%% Question 1 _ Part 5


for i = 1:Nc
    subplot(2,Nc,i)
    imshow(uint8(255*U(:,:,i)));
    title(string("CLUSTER"+ num2str(i)),'interpreter' ,'latex');
end

Uprime = (U >= 0.65);

for i = 1:Nc
    subplot(2,Nc,Nc+i)
    imshow(uint8(255*Uprime(:,:,i)));
    title(string("CLUSTER"+ num2str(i)),'interpreter' ,'latex');
end


%% Q2_Part1_GVF
clear all
close all
clc 

cd 'C:\Users\negin\Desktop\HW04-MIAP-2021 (2)'

Im1 = imread('Blur1.png');
Im2 = imread('Blur2.png');

cd 'C:\Users\negin\Desktop\HW04-MIAP-2021 (2)\snake_demo\snake'

mu = 0.221 ;
ITER = 200;

f = Im1 ;
[u,v] = GVF(f, mu, ITER);

subplot(2,2,1)
imshow(Im1);
title("Blur1",'interpreter' ,'latex');
subplot(2,2,2)
imshow(Im1);
hold on;
quiver(u,v);
title("GVF after 200 iterations, Mu = 0.221 ",'interpreter' ,'latex');


f = Im2 ;
[u,v] = GVF(f, mu, ITER);

subplot(2,2,3)
imshow(Im2);
title("Blur2",'interpreter' ,'latex');
subplot(2,2,4)
imshow(Im2);
hold on;
quiver(u,v);
title("GVF after 200 iterations, Mu = 0.221 ",'interpreter' ,'latex');

%% Q2_Part2_GVF
clear all
close all
clc 

cd 'C:\Users\negin\Desktop\HW04-MIAP-2021 (2)'

Im1 = double(imread('Mri1.bmp'));
Im2 = double(imread('Mri2.bmp'));
Im3 = double(imread('Mri3.bmp'));
Im4 = double(imread('Mri4.bmp'));
Im5 = double(imread('Mri5.bmp'));

cd 'C:\Users\negin\Desktop\HW04-MIAP-2021 (2)\snake_demo\snake'

mu = 0.221 ;
ITER = 50;

f(:,:,1) = Im1 ;
f(:,:,2) = Im2 ;
f(:,:,3) = Im3 ;
f(:,:,4) = Im4 ;
f(:,:,5) = Im5 ;

for i = 1 : 5
    
    [u,v] = GVF(f(:,:,i), mu, ITER);
    subplot(2,5,i)
    imshow(uint8(f(:,:,i)));
    title("MRI"+num2str(i),'interpreter' ,'latex');
    subplot(2,5,i+5)
    imshow(uint8(f(:,:,i)));
    hold on;
    quiver(u,v);
    title("GVF MRI" + num2str(i)+ " , 50 iter, Mu=0.221",'interpreter' ,'latex');

end


































