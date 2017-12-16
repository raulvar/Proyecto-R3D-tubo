function TT=polyfit2D_1(mat,Mask,x,y,N)
%TT=polyfit2D_1(mat,Mask,x,y,N);
%Function pour obtenir le polinome de N degree 2D selon les suivantes ordres
%
%xN xN-1y xN-2y2.....xyN-1 yN
%.......
%x4 x3y x2y2 xy3 y4
%x3 x2y xy2 y3
%x2 xy y2
%x y
%1
%La matrix es vecteurisée dans le sens verticalle. On utilise Mask pour valider les points 
%Le vecteur de sortie TT donne les coefficients:
%m=length(TT);
%TT(m)=const
%TT(m-1)=y;  TT(m-2)=x;
%TT(m-3)=y2;  TT(m-4)=xy; TT(m-5)=x2;
%......
width=size(mat,2);
height=size(mat,1);
if ischar(x) | ischar(y) | ischar(Mask) | ischar(mat) | ischar(N)
   error('Datos de entrada no validos...'); 
   return;
end
if (size(x,1)*size(x,2) == 1) | (size(y,1)*size(y,2) == 1)
   error('dimension de x y y  no valida.');
   return;
end

if (size(N,1)*size(N,2) ~= 1 | N<=0)
    error('dimension de N  no valida.');
   return;
end

if (size(mat)~=size(Mask))
    error('dimension de matrices  no valida.');
   return;
end

if ( prod(size(x))== size(x,1) | prod(size(x))== size(x,2) ) & ( prod(size(y))== size(y,1) | prod(size(y))== size(y,2) )
    if (length(x)~=width | length(y)~=height)
        error('dimension de matrices  no valida.'); 
        return;
    end
    [X,Y]=meshgrid(x,y);
    x=[];y=[];
elseif ( size(x)==size(y) & size(x)==size(mat) )
    X=x;Y=y;
    x=[];y=[];
end

LM=reshape(Mask,[width*height 1]);
indVal=find(LM==1);clear LM;
clear Mask;
LX=reshape(X,[width*height 1]);X=[];
X=LX(indVal);clear LX;
LY=reshape(Y,[width*height 1]);Y=[];
Y=LY(indVal);clear LY;
LI=reshape(mat,[width*height 1]);
I=LI(indVal);clear LI;clear mat;
NDA=(N+1)*(N+2)/2;
A=zeros(length(Y),NDA);
cont=1;
for n=N:-1:0
    for l=n:-1:0
        a=(X.^l).*(Y.^(n-l));
        A(:,cont)=a;
        cont=cont+1;
    end
end
% TT=inv(A'*A)*A'*I;
AA=A'*A;
b=A'*I;
TT=AA\b;
clear A;clear X;clear Y;clear I;clear indVal;
