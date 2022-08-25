function OUT = ASD(Im_surface,GT_surface)  % the input is an Image surface and a groundtruth surfac

    di = zeros(size(Im_surface,1),1);

    for i = 1:size(Im_surface,1)           % measuring all the minimum distances
          di(i) = min (sqrt(sum((ones(size(GT_surface,1),1)*Im_surface(i,:) - GT_surface).^2 , 2)),[],'all');       
    end


    OUT = mean(di);                        %  the out put is ASD ( average of all minimum distances)

end