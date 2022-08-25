function Im_label = vertebra(Im_label,label)        % gets a labeled image and one specific label
    Im_label = double(Im_label);
    if (label~=0)
        Im_label(find(Im_label~=label))=0;          % gives an image with all voxels zero except the voxels with the label mentioned
    else
        Im_label(:,:,:) = 0;
    end
    
end