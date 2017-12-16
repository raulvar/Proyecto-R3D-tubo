function Puntos = CalibracionStereo(Fases,Mask,res,stereoParams,tt)
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
Temp = NaN*zeros(size(Fases(:,:,1)));
for i=1:size(Fases,3)
    tic
    Maskx = logical(Mask(:,:,i));
    if(tt)
        Fasesx = undistortImage(Fases(:,:,i),stereoParams.CameraParameters1);
        Maskx(isnan(Fasesx))=0;
        %    ucx = u(1);vcx = u(2);
       
    else
        Fasesx= Fases(:,:,i);
    end
    
Ac = stereoParams.CameraParameters1.IntrinsicMatrix';
Ap = stereoParams.CameraParameters2.IntrinsicMatrix';
Tp = [stereoParams.RotationOfCamera2;stereoParams.TranslationOfCamera2]';

Pc = Ac*[eye(3) zeros(3,1)]; %Pc=Pc/Pc(end,end);
Pp = Ap*Tp;Pp=Pp/Pp(end,end);

up = res(3)*Fasesx(Maskx)/(2*pi)+res(1)/2;
[uc,vc]=meshgrid(1:size(Fasesx,2),1:size(Fasesx,1));
uc=uc(logical(Maskx)); vc=vc(logical(Maskx));
k=1;
XX=zeros([4 numel(uc)]);
for a=1:1:numel(uc)
    %if(tt)
    %    u = undistortPoints([uc(a),vc(a)],stereoParams.CameraParameters1);
    %    ucx = u(1);vcx = u(2);
    %else
        ucx=uc(a);vcx=vc(a); 
    %end
    upx=up(a);
    n=size(ucx(:));
    PP = [zeros(n),-ones(n),vcx(:);ones(n),zeros(n),-ucx(:);-vcx(:),ucx(:),zeros(n)];
    Px1 = PP*Pc;
    Px2 = [ones(n) zeros(n) -upx]*Pp;
    Px  = [Px1;Px2];
    
    [dummy,dummy,X] = svd(Px,0);
    
    X = X(:,end);
    X=X/(X(end));
    XX(:,k)=X;
    k=k+1;
end
Xc=XX(1,:); Yc=XX(2,:);Zc=XX(3,:);
Temp(Maskx) = Xc(:);
Puntos(:,:,i,1) = Temp;
Temp(Maskx) = Yc(:);
Puntos(:,:,i,2) = Temp;
Temp(Maskx) = Zc(:);
Puntos(:,:,i,3) = Temp;
tiempo =toc;
disp([num2str(i),' Falta : ',num2str((size(Fases,3)-i)*tiempo),'seg'])

end


%figure(88),hold off,plot3(Xc,Yc,Zc,'r.');

end