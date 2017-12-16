function [a,b,c] = Fit2_3D(Z,DeltaF)
nn = numel(Z);
Z1=sum(Z);
Z2=sum(Z.*Z);
Z3=sum(Z.*Z.*Z);
Z4=sum(Z.^2.*Z.^2);
N=size(DeltaF,3);

DZ2=sum(DeltaF.*repmat(reshape(Z.*Z,1,1,nn),size(DeltaF,1),size(DeltaF,2),1),3);
DZ =sum(DeltaF.*repmat(reshape(Z   ,1,1,nn),size(DeltaF,1),size(DeltaF,2),1),3);
D=sum(DeltaF,3);


u=(Z3*Z2-Z1*Z4)/(Z2+eps);
v=(Z2*Z2-N*Z4)/(Z2+eps);
m=(Z2*Z2-Z1*Z3)/(Z2+eps);
n=(Z1*Z2-N*Z3)/(Z2+eps);

x=(DZ2*Z2-D*Z4)/(Z2+eps);
y=(DZ *Z2-D*Z3)/(Z2+eps);

b=(y*v-x*n)/(m*v-n*u);
c=(x*m-y*u)/(m*v-n*u);
a=(D-N*c-Z1*b)/(Z2+eps);

end