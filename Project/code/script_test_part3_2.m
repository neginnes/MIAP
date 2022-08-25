%%%%%%%
%%%%% TO START PLEASE WRITE THE LABELED INPUT IMAGE OF THE MASK AND THE
%%%%% PATIANT FULL NAME ( AND ADRESS ONLY IF IT IS NOT IN THE SAME FOLDER WITH THIS SCRIPT) IN FROT OF 'input_mask' AND 'input_paitiant' AND THEN
%%%%% JUST RUN THIS SECTION AND AFTER THAT THE NEXT SECTION 

% change the input healthy mask labels
input_mask = "00_mask.nii";

% change the input patiant image labels
input_paitiant = "pat2_label.nii";


%% Part3_2 _ registering vertebras seperatly

healthy_mask = niftiread(input_mask);   % reading the mask label
% healthy = niftiread("00.nii");        % reading the mask background

pat_label = niftiread(input_paitiant);  % reading the patiant image label
% pat = niftiread("pat2.nii");          % reading the patiant image background

moving = double(pat_label);                    % the patiant image is moving image and the mask is fxed image
fixed = double(healthy_mask);


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

% Interpolating the out put of 3_2 and reconstruction the image
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

registered_Im2 = valume_reconstructor(total_registerd_moving_ptCloud2,moving);   % reconstructiong the valumetic image from the point cloud
CV2 = commonValume(total_registerd_moving_ptCloud2,moving)                       % measuring the common valume bitween vertebras
Det2 = Tform_det_Cheker(Tform2)                                                  % measuring the jacubian determinant of transform function

% computing CV , ASD , DS, HD for par 3_2 results

registered_Im2_surface = Image_surface(registered_Im2);    % finding the registerd image surface
mask_surface = Image_surface(fixed);                       % finding the fixed image or mask surface
Hd2 = HD(registered_Im2_surface,mask_surface)              % measuring the Hasdorf distance bitween the registered image and the mask
Asd2 = ASD(registered_Im2_surface,mask_surface)            % measuring the Average surface distance bitween the registered image and the mask
Ds2 = DS(registered_Im2,fixed) 



