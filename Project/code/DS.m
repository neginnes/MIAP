function OUT = DS(Im,GT)            % the input is the valumetric image and the groundtruth

    Im = double(Im);
    GT = double(GT);
    Im(find(Im>0)) = 2;         
    GT(find(GT>0)) = 1;
    D = size(find(Im-GT == 1),1);   % D shows the true estimated voxels
    A = size(find(Im == 2),1);      % A and B are both shows the true fulse voxels
    B = size(find(GT == 1),1);
    OUT = 2*D/(A + B);              % the output is the dice score

end