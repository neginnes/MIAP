function filtered_Im = Bilateral_filter (Im,hx,hg)
    filtered_Im = Im ;
    for Xi = 1 : size(Im,1)
        percentage_of_process = 100* (Xi / size(Im,1))
        for Xj = 1 : size(Im,2)
            Num = 0;
            Dem = 0;
            for Yi = 1 : size(Im,1)
                for Yj = 1 : size(Im,2)
                    Ghx = exp(-((Xi - Yi)^2 + (Xj - Yj)^2)/(2*hx^2));
                    Ghg = exp(-((Im(Xi,Xj)-Im(Yi,Yj))^2)/(2*hg^2));
                    
                    Num = Num + Im(Yi,Yj)*Ghx*Ghg ;
                    Dem = Dem + Ghx*Ghg ;
                end
                filtered_Im(Xi,Xj) = Num / Dem ;
            end
            
        end
    end



end