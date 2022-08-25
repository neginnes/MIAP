function filtered_Im = TotalVariation_filter (Im,lamda,iteration_number,dt)
    epsilon = 0.0018;
    filtered_Im = Im ;
    fraction1 = zeros(size(Im));
    fraction2 = zeros(size(Im));
    for n = 1 : iteration_number
        percentage_of_process = 100* (n / iteration_number)
        for i = 1 : size(Im,1)
            for j = 1 : size(Im,2)
                if ( i>2 && j>2 && i<size(Im,1) && j<size(Im,2))
                    left_deriv_x = filtered_Im(i,j) - filtered_Im(i-1,j);
                    right_deriv_x = filtered_Im(i+1,j) - filtered_Im(i,j);
                    left_deriv_y = filtered_Im(i,j) - filtered_Im(i,j-1);
                    right_deriv_y = filtered_Im(i,j+1) - filtered_Im(i,j);

                    Dem1 = sqrt((right_deriv_x)^2 + (m(right_deriv_y , left_deriv_y))^2 + epsilon);
                    Dem2 = sqrt((right_deriv_y)^2 + (m(right_deriv_x , left_deriv_x))^2 + epsilon);
                    
                    fraction1(i,j) = right_deriv_x / Dem1 ;
                    fraction2(i,j) = right_deriv_y / Dem2 ;
               
                    filtered_Im(i,j) = filtered_Im(i,j) + dt *( ( fraction1(i,j) - fraction1(i-1,j)) + (fraction2(i,j) - fraction2(i,j-1)) ) + dt*lamda*(Im(i,j) - filtered_Im(i,j));
                elseif( i==2 || i==size(Im,1))
                    filtered_Im(i,j) = filtered_Im(i-1,j);
                elseif( j==2 || j==size(Im,2))
                    filtered_Im(i,j) = filtered_Im(i,j-1);
                end

            end
        end
    end


end