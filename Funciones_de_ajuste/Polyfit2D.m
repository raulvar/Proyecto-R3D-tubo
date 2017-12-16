%TT=Polyfit2D(mat,Mask,X,Y,N);
% OPCIONES VALIDAS:
% ==>mat,Mask,Matrices y X,Y Vectores posicion
% ==>mat,Mask,X,Y todas matrices
% ==>mat,Mask,X,Y todas vectores
% 
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

function TT=Polyfit2D(varargin)
iptchecknargin(1,5,nargin,mfilename);
mat=[];Mask=[];X=[];Y=[];N=[];TT=[];
mat = varargin{1};
iptcheckinput(mat, {'double'}, {'real', '2d','vector','nonsparse', 'nonempty',...
    'finite'},mfilename, 'mat', 1);
Mask = varargin{2};
iptcheckinput(Mask, {'numeric','logical'}, {'real', '2d','vector','nonsparse', 'nonempty',...
    'finite'},mfilename, 'Mask', 2);
X = varargin{3};
iptcheckinput(X, {'numeric'}, {'real', '2d','vector','nonsparse', 'nonempty',...
    'finite'},mfilename, 'X', 3);
Y = varargin{4};
iptcheckinput(Y, {'numeric'}, {'real', '2d','vector','nonsparse', 'nonempty',...
    'finite'},mfilename, 'Y', 4);
N = varargin{5};
iptcheckinput(N, {'double'}, {'real', 'scalar', 'integer', 'positive',...
    'finite'},mfilename, 'N', 5);

if ~(size(mat)==size(Mask))
    errordlg('DImensiones de Mask y mat diferentes','polyfit2D');
    return;
end
if ~(size(X)==size(Y))
    errordlg('Dimensiones de X y Y diferentes','polyfit2D');
    return;
end

if ~(size(mat)==size(X))
    errordlg('Dimensiones de mat y X diferentes','polyfit2D');
    return;
end
if isvector(Mask) && isvector(mat) && isvector(Y) && isvector(X)
    %SON VECTORES TODOS Y NO SE REQUIERE MASK
    if numel(Y)==numel(X) && numel(mat)==numel(X) && numel(mat)==numel(Y)
        I=mat;
        X=shiftdim(X);I=shiftdim(mat);Y=shiftdim(Y);
     else
        errordlg('DIMENSIONES NO CORRECTAS; Se asume Mask,mat,X y Y son vectores','PolyFit2D');
        TT=[];
        return;
    end
elseif ~isvector(Mask) && ~isvector(mat) && isvector(Y) && isvector(X)
    %SON VECTORES TODOS X y Y (Se asume que corresponden a coordenadas x y y)
    %Y Mask y mat son matrices
    if numel(Mask)==numel(mat) && numel(Mask)==numel(X) && numel(Y)==numel(X) && numel(mat)==numel(X) ...
            numel(Mask)==numel(Y) && numel(mat)==numel(Y)
        width=size(mat,2);
        height=size(mat,1);
        LM=reshape(Mask,[width*height 1]);
        indVal=find(LM==1);
        clear('LM','Mask');
        LI=reshape(mat,[width*height 1]);
        I=LI(indVal);clear LI;clear mat;
    else
        errordlg('DIMENSIONES NO CORRECTAS; Se asume Mask y mat son matrices y X y Y son vectores','PolyFit2D');
        TT=[];
        return;
    end
elseif ~isvector(Mask) && ~isvector(mat) && ~isvector(Y) && ~isvector(X)
    %OPCION TODOS SON MATRICES
    if numel(Mask)==numel(mat) && numel(Mask)==numel(X) && numel(Y)==numel(X) && numel(mat)==numel(X) ...
            numel(Mask)==numel(Y) && numel(mat)==numel(Y)
        width=size(mat,2);
        height=size(mat,1);
        LM=reshape(Mask,[width*height 1]);
        indVal=find(LM==1);
        clear('LM','Mask');
        LI=reshape(mat,[width*height 1]);
        I=LI(indVal);clear LI;clear mat;
        LX=reshape(X,[width*height 1]);X=[];
        X=LX(indVal);clear LX;
        LY=reshape(Y,[width*height 1]);Y=[];
        Y=LY(indVal);clear LY;
    else
        errordlg('DIMENSIONES NO CORRECTAS; Se asume Mask y mat son matrices y X y Y son vectores','PolyFit2D');
        TT=[];
        return;
    end
else
    errordlg('OPCION NO CORECTA','PolyFit2D');
    TT=[];
    return;
    
end
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
TT=inv(A'*A)*A'*I;

