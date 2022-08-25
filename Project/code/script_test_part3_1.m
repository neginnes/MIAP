%%%%%%%
%%%%% TO START PLEASE WRITE THE LABELED INPUT IMAGE OF THE MASK AND THE
%%%%% PATIANT FULL NAME ( AND ADRESS ONLY IF IT IS NOT IN THE SAME FOLDER WITH THIS SCRIPT) IN FROT OF 'input_mask' AND 'input_paitiant' AND THEN
%%%%% JUST RUN THIS SECTION AND AFTER THAT THE NEXT SECTION 

% change the input healthy mask labels
input_mask = "00_mask.nii";

% change the input patiant image labels
input_paitiant = "pat2_label.nii";

%% Part3_1
close all 
clc 

healthy_mask = niftiread(input_mask);   % reading  the image and mask
% healthy = niftiread("00.nii");        % reading the mask background

pat_label = niftiread(input_paitiant);  % reading the patiant image label
% pat = niftiread("pat2.nii");          % reading the patiant image background


% P1 = imrotate3(pat1_label,90,[0 0 1]);
% moving = imrotate3(P1,90,[0 1 0]);    % only for when initial rotation is needed

moving = double(pat_label);                    % the patiant image is moving image and the mask is fxed image
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

% Interpolating the out put of 3_1 and reconstruction the image
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
CV1 = commonValume(total_registerd_moving_ptCloud1,moving)                               % measuring the common valume bitween vertebras
Det1 = Tform_det_Cheker(Tform1)                                                          % measuring the jacubian determinant of transform function


% computing CV , ASD , DS, HD for par 3_1 results

registered_Im1_surface = Image_surface(registered_Im1);    % finding the registerd image surface
mask_surface = Image_surface(fixed);                       % finding the fixed image or mask surface
Hd1 = HD(registered_Im1_surface,mask_surface)              % measuring the Hasdorf distance bitween the registered image and the mask
Asd1 = ASD(registered_Im1_surface,mask_surface)            % measuring the Average surface distance bitween the registered image and the mask
Ds1 = DS(registered_Im1,fixed)                             % measuring the Dice score bitween the registered image and the mask
