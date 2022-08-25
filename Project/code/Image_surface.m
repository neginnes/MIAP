function surface = Image_surface(Im)                     % the input is a valumetric image

    idx = find(Im > 0);
    [row, col, page] = ind2sub(size(Im), idx);
    k = boundary([row, col, page],1);                    % finding the boudary of the image
    index = reshape(k,1,[]);
    index = unique(index);
    r = row(index);
    c = col(index);
    p = page(index);
    surface = [r,c,p];                                  % the out put is a n by 3 matrix re presenting the n boudary points x , y and z

end