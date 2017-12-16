function Puntos = CalibracionDeltaPhase(Fases,Delta,coex,coey,coez)
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
a  = coez(:,:,1); b  = coez(:,:,2); c  = coez(:,:,3);
ax = coex(:,:,1); bx = coex(:,:,2); cx = coex(:,:,3);
ay = coey(:,:,1); by = coey(:,:,2); cy = coey(:,:,3);
for i=1:size(Fases,3)
    XX = zeros([size(DeltaF(:,:,1)) 3]);
    %mask = double((b.^2-4*a.*(c-DeltaF(:,:,i)))>0);
    %mask(mask==0)=NaN;
%     XX(:,:,3) = (-b + sqrt(b.^2-4*a.*(c-DeltaF(:,:,i))))./(2*a)  ;%Coordenada en z;
    
    XX(:,:,3) =a.*DeltaF(:,:,i).^2+b.*DeltaF(:,:,i)+c; 
    Zc=XX(:,:,3);
    XX(:,:,1) = ax.*Zc.^2+bx.*Zc+cx;%Coordenada en x;
    XX(:,:,2) = ay.*Zc.^2+by.*Zc+cy;%Coordenada en x;
    
    %XX(isnan(XX))=[];
    Xc=XX(:,:,1); Yc=XX(:,:,2); 
    Puntos(:,:,i,1) = Xc;
    Puntos(:,:,i,2) = Yc;
    Puntos(:,:,i,3) = Zc;
    disp(num2str(i));
end


%figure(88),hold off,plot3(Xc,Yc,Zc,'r.');

end