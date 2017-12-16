% dir = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-09-12\Imagenes_calibracion\';
dir = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-09-18\Imagenes_calibracion\';
nombase = 'BN';
nomb2 = [dir,nombase,'_bn_'];
n_imagen = 15; squareSize =9.4500;
[cPb,ucPb,CPb,uCPb,Ib,Indb,boardsizeb]  = CalibrarCamara(nomb2,n_imagen,squareSize);
%%
% figure(500), hold on
% title('Errores de reproyección - cuadricula BN')
% k=0;
% %dd=num2str(zeros(size([1:sum(Indb(:))]')));
% for i=[1:sum(Indb(:))]
%     k=k+1;
%     plot(CPb.ReprojectionErrors(:,1,i),CPb.ReprojectionErrors(:,2,i),'.w')
%     text(CPb.ReprojectionErrors(:,1,i),CPb.ReprojectionErrors(:,2,i),num2str(i))
% %     pause()
%     dx = CPb.ReprojectionErrors(:,1,i);
%     dy = CPb.ReprojectionErrors(:,2,i);
%     dd{k} = [num2str(i),'- ',num2str(mean(sqrt(dx.^2+dy.^2)))];
% end
% legend(dd)
% 
% figure(501), hold on
% title('Errores de reproyección con distorsion corregida - cuadricula BN')
% k=0;
% %dd=num2str(zeros(size([1:sum(Indb(:))]')));
% for i=[1:sum(Indb(:))]
%     k=k+1;
%     plot(uCPb.ReprojectionErrors(:,1,i),uCPb.ReprojectionErrors(:,2,i),'.w')
%     text(uCPb.ReprojectionErrors(:,1,i),uCPb.ReprojectionErrors(:,2,i),num2str(i))
% %     pause()
%     dx = uCPb.ReprojectionErrors(:,1,i);
%     dy = uCPb.ReprojectionErrors(:,2,i);
%     dd{k} = [num2str(i),'- ',num2str(mean(sqrt(dx.^2+dy.^2)))];
% end
% legend(dd)

%%
%dir = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-11-16\Imagenes_calibracion\';
dir= 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-09-18\Imagenes_calibracion\';                 
nombase = 'Corresp';
nomb2 = [dir,nombase,'_Fondo_c_'];
n_imagen = 15; squareSize =10.00;
[cP,ucP,CP,uCP,I,Ind,boardsize]  = CalibrarCamara(nomb2,n_imagen,squareSize);
ind = find(Ind);
imagen = imread(I{ind(1)});
for i=2:sum(Ind)
   imagen(:,:,i) = imread(I{ind(i)});
end

%  for i=1:15
%     imagen(:,:,i) = imread(I{i});
%  end

%%
% figure(503), hold on
% title('Errores de reproyección - cuadricula color')
% k=0;
% %dd=num2str(zeros(size([1:sum(Indb(:))]')));
% for i=[1:sum(Ind(:))]
%     k=k+1;
%     plot(CP.ReprojectionErrors(:,1,i),CP.ReprojectionErrors(:,2,i),'.w')
%     text(CP.ReprojectionErrors(:,1,i),CP.ReprojectionErrors(:,2,i),num2str(i))
% %     pause()
%     dx = CP.ReprojectionErrors(:,1,i);
%     dy = CP.ReprojectionErrors(:,2,i);
%     dd{k} = [num2str(i),'- ',num2str(mean(sqrt(dx.^2+dy.^2)))];
% end
% legend(dd)
% 
% figure(504), hold on
% title('Errores de reproyección con distorsion corregida - cuadricula color')
% k=0;
% %dd=num2str(zeros(size([1:sum(Indb(:))]')));
% for i=[1:sum(Ind(:))]
%     k=k+1;
%     plot(uCP.ReprojectionErrors(:,1,i),uCP.ReprojectionErrors(:,2,i),'.w')
%     text(uCP.ReprojectionErrors(:,1,i),uCP.ReprojectionErrors(:,2,i),num2str(i))
% %     pause()
%     dx = uCP.ReprojectionErrors(:,1,i);
%     dy = uCP.ReprojectionErrors(:,2,i);
%     dd{k} = [num2str(i),'- ',num2str(mean(sqrt(dx.^2+dy.^2)))];
% end
% legend(dd)
%% Mascaras de las imagenes con cuadriculas
% Ip = imread(I{tomas(6)});
tomas = find(Ind); 
MP  = reshape( cP,[boardsize-1 2 sum(Ind)]);
uMP = reshape(ucP,[boardsize-1 2 sum(Ind)]);

Mask  = createMaskCB(I,tomas,MP);
%% 

nom_base= [dir,nombase];

[Fasesx ,Fasesy ,PI ] = ExtraerFaseHV(nom_base,tomas,Mask ,[]);
%%
% paso =12; Ancho = 1280; Alto = 1024;
% fx  = paso* Fasesx /(2*pi)+Ancho/2;
% fy  = paso* Fasesy /(2*pi)+Alto /2;
% 
% fxu = paso* Fasesxu /(2*pi)+Ancho/2;
% fyu = paso* Fasesyu /(2*pi)+Alto /2;


%% Homografias locales a la fase
%  wP =CP.WorldPoints;
%  Pp_l = Homografias_locales( cP,fx ,fy ); % Correspondencia de los puntos por homografia local
% uPp_l = Homografias_locales(ucP,fxu,fyu); % Correspondencia de los puntos (sin distorsion) por homografia local
%  PPl = estimateCameraParameters( Pp_l,wP,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true,'EstimateSkew',false);
% uPPl = estimateCameraParameters(uPp_l,wP,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true,'EstimateSkew',false);
% %%
%  Pp_g = Homografia_global( cP,fx,fy,Mask);  % Correspondencia de los puntos por homografia global
% uPp_g = Homografia_global(ucP,fx,fy,Masku); % Correspondencia de los puntos (sin distorision) por homografia global
%  PPg = estimateCameraParameters( Pp_g,wP,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true,'EstimateSkew',false)
% uPPg = estimateCameraParameters(uPp_g,wP,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true,'EstimateSkew',false);

%% Eliminar la presencia de la cuadricula en la fase
[Fasesxa ,Fasesya ,Maskx ,Masky ] = CleanPhase(Fasesx ,Fasesy ,Mask ,1);

% Estimar la fase de los puntos de la cuadricula
FasesxaP = PhaseAdj(Fasesxa,Maskx,3,1,cP,1); % Calcular la fase de los puntos de 
FasesyaP = PhaseAdj(Fasesya,Maskx,3,1,cP,1); % la cuadricula

paso =12; Ancho = 1280; Alto = 1024;

Xp = paso* FasesxaP /(2*pi)+Ancho/2; %coordenadas en X del proyector sin CAM-compensada
Yp = paso* FasesyaP /(2*pi)+Alto /2; %coordenadas en Y del proyector sin CAM-compensada


 Pp_a = cat(2,Xp ,Yp); % Correspondencia de los puntos por ajuste polinomial


 wP =CP.WorldPoints;
% PPa = estimateCameraParameters( Pp_a,wP,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true,'EstimateSkew',false);
%uPPa = estimateCameraParameters(uPp_a,wP,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true,'EstimateSkew',false);

%% Homografia global a la fase
% Xu = paso* Fasesxa /(2*pi)+Ancho/2; %coordenadas en X del proyector sin CAM-compensada
% Yu = paso* Fasesya /(2*pi)+Alto /2; %coordenadas en Y del proyector sin CAM-compensada
% 
% Xuu = paso*Fasesxau/(2*pi)+Ancho/2; %coordenadas en X del proyector con CAM-compensada
% Yuu = paso*Fasesyau/(2*pi)+Alto /2; %coordenadas en Y del proyector con CAM-compensada
% 
%  Pp_g = Homografia_global( cP,Xu ,Yu ,Mask);  % Correspondencia de los puntos por homografia global
% uPp_g = Homografia_global(ucP,Xuu,Yuu,Masku); % Correspondencia de los puntos (sin distorision) por homografia global
%  PPg = estimateCameraParameters( Pp_g,wP,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true,'EstimateSkew',false);
% uPPg = estimateCameraParameters(uPp_g,wP,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true,'EstimateSkew',false);

%% Homografias locales 
% for k=1:size(Xp,3)
%     for i = 1:size(Xp,1)
%           R = round(ucP(i,:,k));
%           [Uc,Vc] = meshgrid(R(1)-10:R(1)+10,R(2)-10:R(2)+10);
%           Phix = Fasesxau(:,:,k);
%           Up = paso*Phix(sub2ind(size(Phix),Vc(:),Uc(:)))/(2*pi)+Ancho/2;
%           Phiy = Fasesyau(:,:,k);
%           Vp = paso*Phiy(sub2ind(size(Phiy),Vc(:),Uc(:)))/(2*pi)+ Alto/2;
%           Hl(:,:,i,k) = homography2d([Uc(:)';Vc(:)';ones(size(Up(:)))'],[Up(:)';Vp(:)';ones(size(Up(:)))']);
%           Xp_hl = Hl(:,:,i,k)*[ucP(i,:,k)';1];
%           
%           uXp(i,1,k)=Xp_hl(1)/Xp_hl(3);
%           uYp(i,1,k)=Xp_hl(2)/Xp_hl(3);
%           
%     end
% end
% 
% Xp_local = cat(2,uXp,uYp);
%%
clear H

paso =12; Ancho = 1280; Alto = 1024;

Xu = paso* Fasesxa /(2*pi)+Ancho/2; %coordenadas en X del proyector sin CAM-compensada
Yu = paso* Fasesya /(2*pi)+Alto /2; %coordenadas en Y del proyector sin CAM-compensada


for i=1:size(Xu,3)
    [uc,vc]=meshgrid(1:size(Xu,2),1:size(Xu,1));
    up=Xu(:,:,i);
    vp=Yu(:,:,i); 
    Hh(:,:,i) = homography2d([uc(:)';vc(:)';ones(size(up(:)))'],[up(:)';vp(:)';ones(size(up(:)))']);
    Xxpa = Hh(:,:,i)*[cP(:,:,i)';ones(size(cP(:,1,i)))'];
    Xp_global(:,:,i) = (Xxpa(1:2,:)./repmat((Xxpa(3,:)),[2 1]))';
end

%%

figure, plot(Pp_a(:,1,1),Pp_a(:,2,1),'*r')
hold on, plot(Pp_l(:,1,1),Pp_l(:,2,1),'sb')
hold on, plot(Pp_g(:,1,1),Pp_g(:,2,1),'og')

%%
centroides = cell([1,size(cP,3)]);
for im = 1:size(cP,3)
%for im = 1:1
%x_p =[upP(:,:,im)';ones([1,size(ucP(:,:,1),1)])];
%x_c =[ucP(:,:,im)';ones([1,size(ucP(:,:,1),1)])];
%x_p =[pP(:,:,im)';ones([1,size(ucP(:,:,1),1)])];
%x_c =[cP(:,:,im)';ones([1,size(ucP(:,:,1),1)])];
%H = homography2d(x_c,x_p); % Homografia entre los puntos de la camara y el proyector
H =Hh(:,:,im);
toma = tomas(im);

[X,Y] = meshgrid(1:20:Ancho,1:20:Alto); % Pixeles del proyector
 
Ih = double(imread([dir,nombase,'_Fr_h_paso_12_pl_toma_' ,num2str(toma),'.bmp']));
Io = double(imread([dir,nombase,'_Fr_v_paso_12_obj_toma_',num2str(toma),'.bmp']));
Iv = double(imread([dir,nombase,'_Fr_v_paso_12_pl_toma_' ,num2str(toma),'.bmp']));

%Ih = double(imread([dir,nombase,'_Fr_h_paso_12_2_1_toma_' ,num2str(toma),'.bmp']));
% Io = double(imread([dir,nombase,'_Fr_v_paso_12_obj_toma_',num2str(toma),'.bmp']));
%Iv = double(imread([dir,nombase,'_Fr_v_paso_12_2_1_toma_' ,num2str(toma),'.bmp']));
Io= 0*Iv;

Ic = double(imread([dir,nombase,'_Fondo_c_' ,num2str(toma),'.bmp']));

Im = (Ih-Io).*(Iv-Io).*Mask(:,:,im);
imnew = imTransD(Im,H,[Alto Ancho]);

%Imh = paso*Fasesx(:,:,im)/(2*pi)+Ancho/2;
%Imv = paso*Fasesy(:,:,im)/(2*pi)+Alto/2;

%im_reg = (((Iv-Io)>12)&((Ih-Io)>12));
%Masku = Maskx(:,:,im);

%Im = undistortImage(Im,CP); % Compensamos la distorsion de la cam
%  im_reg = undistortImage(im_reg,CP); % Compensamos la distorsion de la cam
%  Masku = undistortImage(Masku,CP); % Compensamos la distorsion de la cam
 

%centr = Centroides_malla(Im,Masku)';
%centroides{im} = homoTrans(H,makehomogeneous(centr)); %centroides de la regilla 

%imnewv = imTransD(Imv,H,[Alto Ancho]);
%imnewh = imTransD(Imh,H,[Alto Ancho]);
%imnewm = imTransD(Masku,H,[Alto Ancho]);
%[Xn,Yn]= meshgrid(1:Ancho,1:Alto);
% imnew = undistortImage(imnew,PP);
%imnew = imTransD(Ic,H,[Alto Ancho]);

%figure(500+im), imagesc(imnew), hold on, plot(x_p(1,:),x_p(2,:),'+b')
%imnew = undistortImage(imnew,cameraParams_p);
figure(600+im), imagesc(imnew),hold on, plot(X(:),Y(:),'+r') , drawnow
%figure(600+im), imagesc((imnewv).*imnewm)
%figure(700+im), imagesc((imnewh).*imnewm)
%figure(500+im), imagesc(imnew),hold on, plot(centroides{im}(1,:),centroides{im}(2,:),'+r') 
%figure(700+im), imagesc(imnew),hold on, plot(X(:),Y(:),'oy'), plot(centroides{im}(1,:),centroides{im}(2,:),'+r') 
%plot(x_c(1,:),x_c(2,:),'*r')
%figure(500+im), imagesc(Im>1400)
%figure, imagesc(undistortImage(imnew,cameraParams_p))
end

%%
ImageP(:,:,:,1) =  cP;
ImageP(:,:,:,2) =  Pp_a;
wP = generateCheckerboardPoints(boardsize, squareSize);
%[stereoParams0,pairsUsed,estimationErrors0] = estimateCameraParameters(ImageP,wP);
[stereoParams2,pairsUsed,estimationErrors2] = estimateCameraParameters(ImageP,wP,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true);
[stereoParams3,pairsUsed,estimationErrors3] = estimateCameraParameters(ImageP,wP,'NumRadialDistortionCoefficients',3,'EstimateTangentialDistortion',true);
%%
Ac = stereoParams.CameraParameters1.IntrinsicMatrix';
Ap = stereoParams.CameraParameters2.IntrinsicMatrix';
Tp = [stereoParams.RotationOfCamera2;stereoParams.TranslationOfCamera2]';
Pc = Ac*[eye(3) zeros(3,1)]; %Pc=Pc/Pc(end,end);
Pp = Ap*Tp;Pp=Pp/Pp(end,end);
%%

%%

return
%%
PhaseC = Fasesx(:,:,1);
up = 12*PhaseC(logical(Maskx(:,:,1)))/(2*pi)+640;
[uc,vc]=meshgrid(1:size(Fasesx(:,:,1),2),1:size(Fasesx(:,:,1),1));
uc=uc(logical(Maskx(:,:,1))); vc=vc(logical(Maskx(:,:,1)));
k=1;
for a=1:1:numel(uc)
    ucx=uc(a);vcx=vc(a); upx=up(a);
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
figure(88),hold off,plot3(Xc,Zc,-Yc,'r.');









