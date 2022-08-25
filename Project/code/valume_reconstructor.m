function Valume = valume_reconstructor(total_ptCloud,moving)                        % gets the final overall point cloud of the moving image and the moving image itself
    V = total_ptCloud.Location;
    Intnsity = total_ptCloud.Intensity;
    Valume = zeros(size(moving));
    for i = 1 : size(V,1)
        if (isnan(V(i,1))==0 && isnan(V(i,2))==0 && isnan(V(i,3))==0)               % this part is not necesery , only for checking and ignoring if there is any NaN element
            if(round(V(i,1))>size(Valume,1))
                V(i,1) = V(i,1) -1;
            elseif(round(V(i,2))>size(Valume,2))
                V(i,1) = V(i,2) -1;
            elseif(round(V(i,3))>size(Valume,3))
                V(i,1) = V(i,3) -1;
            end
            Valume(round(V(i,1)),round(V(i,2)),round(V(i,3))) = Intnsity(i);        % filling the valume in the registered data position with the coresponding label
        end                                                                         % the output is the valumetric registered image
    end
end