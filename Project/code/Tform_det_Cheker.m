function Det = Tform_det_Cheker(Tform) % gives the determinant of the jacubian matrix given
    Tform(find(isnan(Tform))) = 0 ;
    G = gradient(Tform);               % gradian matrix
    J = [G(:,1)';G(:,2)';G(:,3)'];     % Jacbian matrix
    Det = sqrt(abs(det(J*J')));        % computing the deteminant of a non squre Jacubian matrix

end