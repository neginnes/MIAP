function ptCloudOut  = PointCloud(Im)
    Im = double(Im);
    idx = find(Im > 0);
    [row, col, page] = ind2sub(size(Im), idx);
    k = boundary([row, col, page],1);       %finding the boudary  of the image 
    index = reshape(k,1,[]);
    index = unique(index);
    ptCloud_boundary = pointCloud([row(index),col(index), page(index)],'intensity',Im(sub2ind(size(Im), row(index),col(index), page(index))));      % computing the boundary point cloud
    percentage = min(floor(ptCloud_boundary.Count*0.2),5000)/ptCloud_boundary.Count;   
    ptCloudOut = pcdownsample(ptCloud_boundary,'random',percentage);     % down sampling the boundary point cloud to apercentage of the initial amount
    ptCloudOut.Intensity = Im(sub2ind(size(Im), ptCloudOut.Location(:,1),ptCloudOut.Location(:,2),ptCloudOut.Location(:,3)));  % for not changing the initial intensities
end