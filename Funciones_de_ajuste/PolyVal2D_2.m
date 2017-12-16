function matA=PolyVal2D_2(TT,x,y,N)
% x,y son vectores que definen las coordenadas de los puntos donde se va a evaluar el polinomio. 
%Esta funcion asume que se desea evaluar los puntos definidos pos las coordenadas
% (x,y), para obtener un vector de valores. Si desea una matriz use la funcion 
%  PolyVal2D_1.
%Function pour evaluer le polynome TT de degree N avec x,y 
%xN xN-1y xN-2y2.....xyN-1 yN
%.......
%x4 x3y x2y2 xy3 y4
%x3 x2y xy2 y3
%x2 xy y2
%x y
%1

NDA=(N+1)*(N+2)/2;

iptcheckinput(TT, {'double'}, {'real','vector','nonsparse', 'nonempty',...
    'finite'},mfilename, 'TT', 1);
iptcheckinput(x, {'double'}, {'real','vector','nonsparse', 'nonempty',...
    'finite'},mfilename, 'x', 2);
iptcheckinput(y, {'double'}, {'real','vector','nonsparse', 'nonempty',...
    'finite'},mfilename, 'y', 3);
iptcheckinput(N, {'double'}, {'real', 'scalar', 'integer', 'positive',...
    'finite'},mfilename, 'N', 4);


if length(x) ~= length(y)
   ui=errordlg('dimension de x y y no validas','PolyVal2D_1');
   waitfor(ui);
   return;
end

if (length(TT)~=NDA)
   ui=errordlg('Dimension de TT no valida','PolyVal2D_1');
   waitfor(ui);
   return;
end
x=shiftdim(x);%Obliga a columna;
y=shiftdim(y);%Obliga a columna;

A=zeros(length(x),NDA);
cont=1;
for n=N:-1:0
    for l=n:-1:0
        a=(x.^l).*(y.^(n-l));
        A(:,cont)=a;
        cont=cont+1;
    end
end
matA=A*TT;
