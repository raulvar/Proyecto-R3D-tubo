function Puntos = CalibracionDeltaPhaseN(Fases,Delta,coex,coey,coez)
%%
% Fases : Fase de los objetos a reconstruir por medio de calibracion
%          stereo
% Mask : Mascara de los objetos que se desean reconstruir
% res : Resolucion del sistema de proyeccion res = [W H P]; donde W y H son
%       el ancho y la altura de la imagen proyectada y P es el paso de las
%       franjas proyectadas.
% StereoParams: Parametros estereos del sistema. 
%
Puntos = NaN*zeros([size(Fases) 3]);
DeltaF = Fases - repmat(Delta,[1 1 size(Fases,3)]);
N = size(coex,3);
Ind = coex(:,:,1);
Ind(~isnan(Ind))=1;
for i=1:size(Fases,3)
    XX = zeros([size(DeltaF(:,:,1)) 3]);
    for j=1:N
        XX(:,:,1) = XX(:,:,1)+ coex(:,:,j).*DeltaF(:,:,i).^(N-j);
        XX(:,:,2) = XX(:,:,2)+ coey(:,:,j).*DeltaF(:,:,i).^(N-j);
        XX(:,:,3) = XX(:,:,3)+ coez(:,:,j).*DeltaF(:,:,i).^(N-j);
    end
    %XX(isnan(XX))=[];
    Xc=XX(:,:,1); Yc=XX(:,:,2); Zc=XX(:,:,3);
    Puntos(:,:,i,1) = Xc;
    Puntos(:,:,i,2) = Yc;
    Puntos(:,:,i,3) = Zc;
    disp(num2str(i));
end


%figure(88),hold off,plot3(Xc,Yc,Zc,'r.');

end