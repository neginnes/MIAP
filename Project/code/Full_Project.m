%% Part1_A
clear all
close all
clc 


healthy_mask = niftiread("00_mask.nii");   % reading the mask label
healthy = niftiread("00.nii");             % reading the mask background

pat_label = niftiread("pat2_label.nii");  % reading the patiant image label
pat = niftiread("pat2.nii");              % reading the patiant image background

%volumeViewer(pat2,pat2_label);            % 3D and colorful viewing of selected images only for matlab 2020 and higher version


% inf = niftiinfo('00_mask.nii');
% inf1 = niftiinfo('pat2_label.nii');
                                                      % a preprocessing for equlizing the valumes
% 
% pat2_label = Volume_equalizer(inf1,pat2_label);   
% pat2 = Volume_equalizer(inf1,pat2);                                       
% 
% 
% 
% healthy_mask = Volume_equalizer(inf,healthy_mask);
% healthy = Volume_equalizer(inf,healthy);


Pat = uint8(255*(double(pat) + double(pat_label))/max((double(pat) + double(pat_label)),[],'all'));
Healthy =  uint8(double(healthy) + double(healthy_mask)) ;    % changing the light level for bertter visualization


example_P_3(:,:) = Pat(:,:,130);                  %showing some exmaples in all 2d possible dimetions
example_P_2(:,:) = Pat(:,120,:);          
example_P_1(:,:) = Pat(87,:,:);

example_Healthy_3(:,:) = Healthy(:,:,130);
example_Healthy_2(:,:) = Healthy(:,120,:);
example_Healthy_1(:,:) = Healthy(87,:,:);

figure('Name','Healthy_mak')
subplot(1,3,1)
imshow(example_Healthy_2)
title("axial",'interpreter','latex')
subplot(1,3,2)
imshow(example_Healthy_3)
title("frontal",'interpreter','latex')
subplot(1,3,3)
imshow(example_Healthy_1)
title("lateral",'interpreter','latex')

figure('Name','pat2')
subplot(1,3,1)
imshow(example_P_2)
title("axial",'interpreter','latex')
subplot(1,3,2)
imshow(example_P_3)
title("frontal",'interpreter','latex')
subplot(1,3,3)
imshow(example_P_1)
title("lateral",'interpreter','latex')




%% Part1_B
close all


Im = healthy_mask;   % selecting the image
Im = double(Im);
idx = find(Im > 0);
[row, col, page] = ind2sub(size(Im), idx);
ptCloud = pointCloud([row, col, page],'intensity',Im(idx));   % point cloud of the input image
figure();
pcshow(ptCloud);
title("total valume point cloud",'interpreter','latex')

k = boundary([row, col, page],1);                              %extracting the point cloud boundary
index = reshape(k,1,[]);
index = unique(index);
ptCloud_boundary = pointCloud([row(index),col(index), page(index)],'intensity',Im(sub2ind(size(Im), row(index),col(index), page(index))));
figure();
pcshow(ptCloud_boundary);
title("surface of the point cloud",'interpreter','latex')

percentage = min(floor(ptCloud_boundary.Count*0.2),5000)/ptCloud_boundary.Count;
ptCloudOut = pcdownsample(ptCloud,'random',percentage);          % down sampling the point cloud to apercentage of the initial amount
ptCloudOut.Intensity = Im(sub2ind(size(Im), ptCloudOut.Location(:,1),ptCloudOut.Location(:,2),ptCloudOut.Location(:,3)));
figure()
pcshow(ptCloudOut);

%% Part3_1
close all 
clc

% P1 = imrotate3(pat1_label,90,[0 0 1]);
% moving = imrotate3(P1,90,[0 1 0]);    % only for when initial rotation is needed

moving = double(pat2_label);                    % selecting the image and the mask
fixed = double(healthy_mask);

moving_pc = PointCloud(moving);         % making the image and the masks point clouds
fixed_pc = PointCloud(fixed);

[tform,movingReg] = pcregistercpd(moving_pc,fixed_pc);              % running CPD registering algorithm

subplot(1,2,1)
pcshow(fixed_pc)                                            % showing registerd image and mask sepreatly
title('fixed','interpreter','latex')
subplot(1,2,2)
pcshow(movingReg)
title('moving after registeration','interpreter','latex')
figure('Name','fixed vs registered moving')
pcshowpair(movingReg,fixed_pc,'MarkerSize',80);             % showing registerd image and mask together
legend({'MovingReg ', 'Fixed'})
figure('Name','fixed vs moving')
pcshowpair(moving_pc,fixed_pc,'MarkerSize',80);             % showing the initial input registerd image and mask together
legend({'Moving ', 'Fixed'})

%% Interpolating the out put of 3_1 and reconstruction the image
close all

[r,c,p] = ind2sub(size(moving),find(moving>0));             
pos_m = moving_pc.Location;
Tform1 = tform_inerpolation(tform,pos_m,r,c,p);              % transform function interpolating

idx = find(moving > 0);
[row, col, page] = ind2sub(size(moving), idx);
initial_ptCloud_moving1 = pointCloud([row, col, page],'intensity',moving(idx));     % total point cloud of the moving Image before registration

total_registerd_moving_ptCloud1 = pctransform(initial_ptCloud_moving1,Tform1);      % applying the interpolated DDF to the total moving point cloud and finding the registerd point cloud 

idx = find(fixed > 0);
[row, col, page] = ind2sub(size(fixed), idx);
total_fixed_ptCloud =  pointCloud([row, col, page],'intensity',fixed(idx));     % total point cloud of the fixed Image


figure()                                                                
pcshow(initial_ptCloud_moving1)
title('initial point cloud moving','interpreter','latex')                   % showing the moving point cloud befor and after registeration
figure()
pcshow(total_registerd_moving_ptCloud1)
title('total registerd moving point cloud','interpreter','latex')
figure()
pcshowpair(initial_ptCloud_moving1,total_registerd_moving_ptCloud1,'MarkerSize',80);             
legend({'initial point cloud moving ', 'total registerd moving point cloud'})
figure()
pcshowpair(total_fixed_ptCloud,total_registerd_moving_ptCloud1,'MarkerSize',80);             
legend({'total fixed ptCloud ', 'total registerd moving point cloud'})

registered_Im1 = uint8(valume_reconstructor(total_registerd_moving_ptCloud1,moving));    % reconstructiong the valumetic image from the point cloud
CV1 = commonValume(total_registerd_moving_ptCloud1,moving);                              % measuring the common valume bitween vertebras
Det1 = Tform_det_Cheker(Tform1);                                                         % measuring the jacubian determinant of transform function

%% computing CV , ASD , DS, HD for par 3_1 results

registered_Im1_surface = Image_surface(registered_Im1);    % finding the registerd image surface
mask_surface = Image_surface(fixed);                       % finding the fixed image or mask surface
Hd1 = HD(registered_Im1_surface,mask_surface);             % measuring the Hasdorf distance bitween the registered image and the mask
Asd1 = ASD(registered_Im1_surface,mask_surface);           % measuring the Average surface distance bitween the registered image and the mask
Ds1 = DS(registered_Im1,fixed);                            % measuring the Dice score bitween the registered image and the mask


%% Part3_2 _ registering vertebras seperatly

m_L1 = vertebra(moving,20);     % seperating vertebras in the moving image
m_L2 = vertebra(moving,21);
m_L3 = vertebra(moving,22);
m_L4 = vertebra(moving,23);
m_L5 = vertebra(moving,24);

f_L1 = vertebra(fixed,20);      % seperating vertebras in the fixed image
f_L2 = vertebra(fixed,21);
f_L3 = vertebra(fixed,22);
f_L4 = vertebra(fixed,23);
f_L5 = vertebra(fixed,24);

m_L1_pc = PointCloud(m_L1);     % making the point clouds of each input image vertebra seperatly
m_L2_pc = PointCloud(m_L2);
m_L3_pc = PointCloud(m_L3);
m_L4_pc = PointCloud(m_L4);
m_L5_pc = PointCloud(m_L5);

f_L1_pc = PointCloud(f_L1);      % making the point clouds of each mask vertebra seperatly
f_L2_pc = PointCloud(f_L2);
f_L3_pc = PointCloud(f_L3);
f_L4_pc = PointCloud(f_L4);
f_L5_pc = PointCloud(f_L5);

[tform1,mR_L1_pc] = pcregistercpd(m_L1_pc,f_L1_pc);    % running the CPD algorithm for each vertebra  seperatly
[tform2,mR_L2_pc] = pcregistercpd(m_L2_pc,f_L2_pc);
[tform3,mR_L3_pc] = pcregistercpd(m_L3_pc,f_L3_pc);
[tform4,mR_L4_pc] = pcregistercpd(m_L4_pc,f_L4_pc);
[tform5,mR_L5_pc] = pcregistercpd(m_L5_pc,f_L5_pc);

pcshowpair(mR_L1_pc,f_L1_pc,'MarkerSize',80);
legend({'MovingReg1 ', 'Fixed1'})
figure()
pcshowpair(mR_L2_pc,f_L2_pc,'MarkerSize',80);         % showing each vertebra after registration with the mask together
legend({'MovingReg2 ', 'Fixed2'})
figure()
pcshowpair(mR_L3_pc,f_L3_pc,'MarkerSize',80);
legend({'MovingReg3 ', 'Fixed3'})
figure()
pcshowpair(mR_L4_pc,f_L4_pc,'MarkerSize',80);
legend({'MovingReg4 ', 'Fixed4'})
figure()
pcshowpair(mR_L5_pc,f_L5_pc,'MarkerSize',80);
legend({'MovingReg5 ', 'Fixed5'})

%% Interpolating the out put of 3_2 and reconstruction the image
close all

tform_L1_L5 = [tform1 ; tform2 ; tform3 ; tform4 ; tform5];
m = [m_L1_pc.Location ; m_L2_pc.Location ; m_L3_pc.Location ; m_L4_pc.Location ; m_L5_pc.Location];
[r1,c1,p1] = ind2sub(size(moving),find(m_L1>0)); 
[r2,c2,p2] = ind2sub(size(moving),find(m_L2>0)); 
[r3,c3,p3] = ind2sub(size(moving),find(m_L3>0)); 
[r4,c4,p4] = ind2sub(size(moving),find(m_L4>0)); 
[r5,c5,p5] = ind2sub(size(moving),find(m_L5>0)); 
r = [r1 ; r2 ; r3 ; r4 ; r5];
c = [c1 ; c2 ; c3 ; c4 ; c5];
p = [p1 ; p2 ; p3 ; p4 ; p5];
Tform2 = tform_inerpolation(tform_L1_L5,m,r,c,p);

idx = find(moving > 19);
[row, col, page] = ind2sub(size(moving), idx);
initial_ptCloud_moving2 = pointCloud([row, col, page],'intensity',moving(idx));
total_registerd_moving_ptCloud2 = pctransform(initial_ptCloud_moving2,Tform2);

idx = find(fixed > 0);
[row, col, page] = ind2sub(size(fixed), idx);
total_fixed_ptCloud =  pointCloud([row, col, page],'intensity',fixed(idx));     % total point cloud of the fixed Image before registration


figure()
pcshow(initial_ptCloud_moving2)
title('initial point cloud moving','interpreter','latex')
figure()
pcshow(total_registerd_moving_ptCloud2)
title('total registerd moving point cloud','interpreter','latex')
figure()
pcshowpair(initial_ptCloud_moving2,total_registerd_moving_ptCloud2,'MarkerSize',80);             
legend({'initial point cloud moving ', 'total registerd moving point cloud'})
figure()
pcshowpair(total_fixed_ptCloud,total_registerd_moving_ptCloud2,'MarkerSize',80);             
legend({'total fixed ptCloud ', 'total registerd moving point cloud'})

registered_Im2 = valume_reconstructor(total_registerd_moving_ptCloud2,moving);  % reconstructiong the valumetic image from the point cloud
CV2 = commonValume(total_registerd_moving_ptCloud2,moving);                     % measuring the common valume bitween vertebras
Det2 = Tform_det_Cheker(Tform2);                                                % measuring the jacubian determinant of transform function

%% computing CV , ASD , DS, HD for par 3_2 results

registered_Im2_surface = Image_surface(registered_Im2);    % finding the registerd image surface
mask_surface = Image_surface(fixed);                       % finding the fixed image or mask surface
Hd2 = HD(registered_Im2_surface,mask_surface);             % measuring the Hasdorf distance bitween the registered image and the mask
Asd2 = ASD(registered_Im2_surface,mask_surface);           % measuring the Average surface distance bitween the registered image and the mask
Ds2 = DS(registered_Im2,fixed);                            % measuring the Dice score bitween the registered image and the mask

