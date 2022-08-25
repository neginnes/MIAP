function V = commonValume(total_PC,moving)  % gets the final overall point cloud of the moving image and the moving image itself
    L = total_PC.Location;
    Intnsity = total_PC.Intensity;
    V = 0;
    Valume = -1*ones(size(moving));
    for i = 1 : size(L,1)
        if (isnan(L(i,1))==0 && isnan(L(i,2))==0 && isnan(L(i,3))==0)       % this part is not necesery , only for checking and ignoring if there is any NaN element
            if(round(L(i,1))>size(Valume,1))
                L(i,1) = L(i,1) -1;
            elseif(round(L(i,2))>size(Valume,2))
                L(i,1) = L(i,2) -1;
            elseif(round(L(i,3))>size(Valume,3))
                L(i,1) = L(i,3) -1;
            end
            if (Valume(round(L(i,1)),round(L(i,2)),round(L(i,3))) ==-1)            % filling the valume in the registered data position with the coresponding label
                Valume(round(L(i,1)),round(L(i,2)),round(L(i,3)))= Intnsity(i);
            elseif(Intnsity(i)~=Valume(round(L(i,1)),round(L(i,2)),round(L(i,3)))) % if any voxelwas filled more than one time with different labels , take it as a common vaxel
                V = V + 1;                                                         % the output is the common vaxels
            end
        end
    end

end