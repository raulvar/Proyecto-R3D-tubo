function [coef,e]=Polyfit3_3D(X,Y)
n=3;
X2=1;
for i=1:2*n
    X2 = X2.*X;
    eval(['F',num2str(i),'= sum(X2,3);']);
end
 F0  = size(X,3);
 
X2=1;
for i=1:n
    X2=X2.*X;
    eval(['Z',num2str(i),'= sum(Y.*X2,3);']);
end
%  Z5 = sum(Y.*X5,3);
%  Z4 = sum(Y.*X4,3);
%  Z3 = sum(Y.*X3,3);
%  Z2 = sum(Y.*X2,3);
%  Z1 = sum(Y.*X,3);
 Z0 =  sum(Y,3);

dete = - F6.*F1.^2.*F4 + F1.^2.*F5.^2 + 2.*F6.*F1.*F2.*F3 - 2.*F1.*F2.*F4.*F5 - 2.*F1.*F3.^2.*F5 + 2.*F1.*F3.*F4.^2 - F6.*F2.^3 + 2.*F2.^2.*F3.*F5 + F2.^2.*F4.^2 - 3.*F2.*F3.^2.*F4 + F0.*F6.*F2.*F4 - F0.*F2.*F5.^2 + F3.^4 - F0.*F6.*F3.^2 + 2.*F0.*F3.*F4.*F5 - F0.*F4.^3;
a = - Z3.*F1.^2.*F4 + F5.*Z2.*F1.^2 + 2.*Z3.*F1.*F2.*F3 - Z2.*F1.*F2.*F4 - F5.*Z1.*F1.*F2 - Z2.*F1.*F3.^2 + Z1.*F1.*F3.*F4 - F5.*Z0.*F1.*F3 + Z0.*F1.*F4.^2 - Z3.*F2.^3 + Z2.*F2.^2.*F3 + Z1.*F2.^2.*F4 + F5.*Z0.*F2.^2 - Z1.*F2.*F3.^2 - 2.*Z0.*F2.*F3.*F4 + F0.*Z3.*F2.*F4 - F0.*F5.*Z2.*F2 + Z0.*F3.^3 - F0.*Z3.*F3.^2 + F0.*Z2.*F3.*F4 + F0.*F5.*Z1.*F3 - F0.*Z1.*F4.^2;
a=a./dete;
b = F3.^3.*Z1 - F0.*F4.^2.*Z2 + F2.*F4.^2.*Z0 - F1.*F3.^2.*Z3 - F2.*F3.^2.*Z2 - F3.^2.*F4.*Z0 + F2.^2.*F3.*Z3 - F2.^2.*F6.*Z0 + F1.^2.*F5.*Z3 - F1.^2.*F6.*Z2 - F0.*F2.*F5.*Z3 + F0.*F2.*F6.*Z2 + F0.*F3.*F4.*Z3 - F0.*F3.*F6.*Z1 + F0.*F4.*F5.*Z1 - F1.*F2.*F4.*Z3 + F1.*F2.*F6.*Z1 + 2.*F1.*F3.*F4.*Z2 - F1.*F3.*F5.*Z1 + F1.*F3.*F6.*Z0 - F1.*F4.*F5.*Z0 - F2.*F3.*F4.*Z1 + F2.*F3.*F5.*Z0;
b=b./dete;
c = F3.^3.*Z2 - F0.*F5.^2.*Z1 + F1.*F5.^2.*Z0 - F0.*F4.^2.*Z3 + F3.*F4.^2.*Z0 - F2.*F3.^2.*Z3 - F3.^2.*F4.*Z1 - F3.^2.*F5.*Z0 + F2.^2.*F4.*Z3 - F2.^2.*F6.*Z1 + F0.*F3.*F5.*Z3 - F0.*F3.*F6.*Z2 + F0.*F4.*F5.*Z2 + F0.*F4.*F6.*Z1 - F1.*F2.*F5.*Z3 + F1.*F2.*F6.*Z2 + F1.*F3.*F4.*Z3 - F1.*F3.*F5.*Z2 - F1.*F4.*F6.*Z0 - F2.*F3.*F4.*Z2 + 2.*F2.*F3.*F5.*Z1 + F2.*F3.*F6.*Z0 - F2.*F4.*F5.*Z0;
c=c./dete;
d = Z3.*F2.^2.*F5 - F6.*Z2.*F2.^2 - 2.*Z3.*F2.*F3.*F4 + Z2.*F2.*F3.*F5 + F6.*Z1.*F2.*F3 + Z2.*F2.*F4.^2 - Z1.*F2.*F4.*F5 + F6.*Z0.*F2.*F4 - Z0.*F2.*F5.^2 + Z3.*F3.^3 - Z2.*F3.^2.*F4 - Z1.*F3.^2.*F5 - F6.*Z0.*F3.^2 + Z1.*F3.*F4.^2 + 2.*Z0.*F3.*F4.*F5 - F1.*Z3.*F3.*F5 + F1.*F6.*Z2.*F3 - Z0.*F4.^3 + F1.*Z3.*F4.^2 - F1.*Z2.*F4.*F5 - F1.*F6.*Z1.*F4 + F1.*Z1.*F5.^2;
d=d./dete;


x = shiftdim(X(500,500,:));
y = shiftdim(Y(500,500,:));
figure, plot(x,y,'*')
hold on, plot(x,a(500,500)*x.^3+b(500,500)*x.^2+c(500,500)*x+d(500,500))
coef = cat(3,a,b,c,d);

XX = zeros(size(X));
n=size(coef,3);
for j=1:n
  XX(:,:,:) = XX+repmat(coef(:,:,j),[1,1,size(X,3)]).*X.^(n-j);  
end
e = Y-XX;

end