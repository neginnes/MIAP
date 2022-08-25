function filtered_Im = NLM_filter (Image , n)
    Image = double(Image);
    L = 3*n ;
    background = mean(Image(1,:));
    if(1-background < 0.1)
        Im = ones(size(Image)+ L-1)*1;
    elseif(background < 0.1)
        Im = ones(size(Image)+ L-1)*0;
    else
        Im = ones(size(Image)+ L-1)*background;
    end
    
    %Im = ones(size(Image)+ L-1)*max(Image(1,:));
    Im(1+(L-1)/2 : size(Image,1)+(L-1)/2 , 1+(L-1)/2:size(Image,2)+(L-1)/2) = Image ;
    filtered_Im = Image ;
    s = 1+(L-1)/2;
    fi = size(Image,1)+(L-1)/2;
    fj = size(Image,2)+(L-1)/2;
    
    for i = s : fi
        percentage_of_process = 100* (i / fi)
        for j = s : fj
            currunt_patch = Im(i-(n-1)/2 : i+(n-1)/2 ,j-(n-1)/2 : j+(n-1)/2);
            dist_param = 0.3 ;
            patch_stack = currunt_patch;
            stack_depth = 1 ;
            Num = 0;
            Dem = 0;
            hx = 0.3;
            for k = i-(L-1)/2 :(n-1)/2 : i+(L-1)/2 
                for p = j-(L-1)/2 : (n-1)/2 : j+(L-1)/2
                    if(k <= i+(L-1)/2 - n  && p <= j+(L-1)/2 - n )
                        dist = sqrt(sum(sum((Im(k:k+n-1 , p:p+n-1)-currunt_patch).^2)));
                        if( dist < dist_param && ~(k==i && p==j) )
                            patch_stack(:,:,stack_depth+1) = Im(k:k+n-1 , p : p+n-1);
                            stack_depth = stack_depth + 1 ;
                            Num = Num + patch_stack((n+1)/2,(n+1)/2,stack_depth)*exp(-((dist)^2)/(2*hx^2));
                            Dem = Dem + exp(-((dist)^2)/(2*hx^2)) ;
                        end
                    end
                end            
            end
%             Sum = 0 ;
%             for l = 1 : stack_depth 
%               Sum = Sum + patch_stack((n+1)/2,(n+1)/2,l);
%             end
            %filtered_Im(i-(L-1)/2,j-(L-1)/2)= Sum /stack_depth ;
            filtered_Im(i-(L-1)/2,j-(L-1)/2)= Num /Dem ;

        end
    end

filtered_Im = cast (filtered_Im , class(Im));
end