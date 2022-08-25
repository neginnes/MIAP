function [center,u,J,num]=FCM(data,k,q,init_u,iter_num)
[m,N]=size(data);
center=zeros(m,k);
u1=zeros(N,k);  
% error=1;
num=0;
if (isnan(init_u))
    u = rand(N,k) ;
else
    u = init_u ;
end
while(num<iter_num)
    center=(data*(u.^q))./(ones(m,1)*sum(u.^q));  
    u1=u;
    for i=1:N
        d=distance_Norm2(data(:,i)*ones(1,k),center);
        a=1./d.^(2/(q-1));
        b=sum(a); 
        u(i,:)=a/b;
    end  
%     error=max(max(abs(u-u1)));
    num=num+1;
end

price=zeros(N,k);
for j=1:k
    price(:,j)=u(:,j).*(sum((data-center(:,j)*ones(1,N)).^2))';
end 
J=sum(sum(price));   