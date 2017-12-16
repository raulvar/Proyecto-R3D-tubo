function Franjas = Create_franges(Alto,Ancho,Intensidad,Paso,NI,n,str)
%UNTITLED2 Summary of this function goes here
%   Ancho y Alto: Dimensiones de la imagen de franjas
%   Paso : Paso de las franjas en la imagen
%   NI   : numero de imagenes en 2pi
%   n    : numero de corrimiento en 2pi
%  str : si str=='gamma' se hace la correccion del factor gamma
  
     
x=(1:Ancho)-(Ancho/2); y=(1:Alto)-(Alto/2);
[X,Y]=meshgrid(x,y); clear Y
DELTAFASE=2*pi/NI; 
L=ceil(NI/2);

Franjas1=Intensidad*0.5*(1+cos(2*pi*X/Paso-DELTAFASE*(n-L)));

if(strcmp(str,'gamma'))
   %gamma= [38 38 41 42 44 45 47 48 48 49 51 57 58 58 59 59 60 60 61 62 62 63 63 64 64 64 65 65 66 66 66 67 67 68 68 68 69 69 69 69 70 70 70 70 70 70 71 71 71 71 71 71 72 72 72 72 73 73 73 74 74 75 75 78 78 78 78 79 79 79 80 80 80 80 81 81 81 82 82 82 82 83 83 83 83 83 84 84 84 84 85 85 85 85 85 85 86 86 86 86 86 86 86 87 87 87 87 87 87 88 88 88 88 89 89 91 91 91 92 92 92 92 93 93 93 93 94 94 94 94 94 95 95 95 95 96 96 96 96 96 96 97 97 97 97 97 97 97 97 98 98 98 98 98 98 98 98 99 99 99 99 99 100 100 101 102 102 105 105 106 107 107 107 107 108 108 108 108 108 108 109 109 109 109 109 110 110 110 111 111 112 112 113 113 113 113 114 114 114 114 115 115 116 117 117 117 117 118 118 118 118 118 118 119 119 119 119 119 120 120 120 120 122 122 122 122 122 122 122 123 123 123 123 123 123 123 123 123 123 123 124 124 124 124 124 124 124 125 125 125 125 126 126 126 126 126];
   load('Fgamma.mat'); 
   Franjas = Fgamma(round(255*Franjas1)+1);
else
     Franjas = round(255*Franjas1);
end

%Franjas(1,1)=0; Franjas(end,end)=255;

end

