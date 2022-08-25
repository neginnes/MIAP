function Tform = tform_inerpolation(reduced_tform,known_coordinates,interpolation_r,interpolation_c,interpolation_p)
    % interpolating the tform in x = r y = c z = p of the image

    tx = griddata(known_coordinates(:,1),known_coordinates(:,2),known_coordinates(:,3),reduced_tform(:,1),interpolation_r,interpolation_c,interpolation_p,'nearest');       % x , y and z parameters are sepratly interpolated
    ty = griddata(known_coordinates(:,1),known_coordinates(:,2),known_coordinates(:,3),reduced_tform(:,2),interpolation_r,interpolation_c,interpolation_p,'nearest');
    tz = griddata(known_coordinates(:,1),known_coordinates(:,2),known_coordinates(:,3),reduced_tform(:,3),interpolation_r,interpolation_c,interpolation_p,'nearest');

    Tform = [tx,ty,tz];

    
end