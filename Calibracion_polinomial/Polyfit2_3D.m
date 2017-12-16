function [coef,e] = Polyfit2_3D(X,Y)

F1=sum(X,3);
F2=sum(X.*X,3);
F3=sum(X.*X.*X,3);
F4=sum(X.^2.*X.^2,3);
N=size(X,3);

dete = -F4.*F1.^2+2.*F1.*F2.*F3-F2.^3+N*F4.*F2-N*F3.^2;

Z2 = sum(Y.*X.*X,3);
Z1 = sum(Y.*X,3);
Z0 = sum(Y,3);

aa = - Z2.*F1.^2 + Z1.*F1.*F2 + F3.*Z0.*F1 - Z0.*F2.^2 + N*Z2.*F2 - N*F3.*Z1;

a= aa./(dete+eps);

bb = F1.*F2.*Z2 - F2.^2.*Z1 - F1.*F4.*Z0 + F2.*F3.*Z0 - N.*F3.*Z2 + N*F4.*Z1;

b = bb./(dete+eps);

c = (Z0 - a.*F2 - b.*F1)/N;

coef = cat(3,a,b,c);

XX = zeros(size(X));
n=size(coef,3);
for j=1:n
  XX(:,:,:) = XX+repmat(coef(:,:,j),[1,1,size(X,3)]).*X.^(n-j);  
end
e = Y-XX;



end