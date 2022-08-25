function OUT = HD(Im_surface,GT_surface)        % the input is an Image surface and a groundtruth surface

    di = zeros(size(Im_surface,1),1);
    dprimei = zeros(size(GT_surface,1),1);

    for i = 1:size(Im_surface,1)       % measuring HD(Im,GT)
          di(i) = min (sqrt(sum((ones(size(GT_surface,1),1)*Im_surface(i,:) - GT_surface).^2 , 2)),[],'all');       
    end

    for i = 1:size(GT_surface,1)       % measuring HD(GT,Im)
          dprimei(i) = min (sqrt(sum((ones(size(Im_surface,1),1)*GT_surface(i,:) - Im_surface).^2 , 2)),[],'all');       
    end
    OUT = max(max(dprimei,[],'all') , max(di,[],'all')) ;       % the output is max {HD(Im,GT),HD(GT,Im)}

end