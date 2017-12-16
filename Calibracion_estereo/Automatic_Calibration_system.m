%% Intrinsecos Con cuadricula Blanco y negro
% 
nomb = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-07-28\Imagenes_calibracion\Ajedrez_bn_';
n_imagen = 10;
squareSize = 9.45;
[cPoints,CP_BN,I,Ind]=CalibrarCamara([dir_principal,nomb],n_imagen,squareSize);
ucPoints = Compensar_Distorsion(cPoints,CP_BN);
images = find(Ind);
for i=1:size(cPoints,3)
    figure(900+2*i),imagesc(imread(I{images(i),1})); 
    hold on, plot(cPoints(:,1,i),cPoints(:,2,i),'*r');
    figure(900+2*i+1),imagesc(undistortImage(imread(I{images(i),1}),CP_BN)); 
    hold on, plot(ucPoints(:,1,i),ucPoints(:,2,i),'*r');
end
%% Calculo de Parametros Extrinsecos 
%
dir = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-09-12\Imagenes_calibracion\';
nombase = 'Corresp';
nomb2 = [dir,nombase,'_Fondo_c_'];
n_imagen = 15; squareSize =10.00;
[cPointsCO,ucPointsCO,CP_CO,uCP_CO,I,Ind]  = CalibrarCamara(nomb2,n_imagen,squareSize);

images = find(Ind);
for i=1:2%size(cPointsCO,3)
    figure(800+i),imagesc(undistortImage(imread(I{images(i),1}),CP_CO)); 
    hold on, plot(ucPointsCO(:,1,i),ucPointsCO(:,2,i),'*r');
end
%%
nom_base= [dir,nombase];
tomas = find(Ind); 
method = 'FTP';
% method = 'Clasic';
[Fasesxu,Fasesyu,Maskxu,PIu] = ExtraerFaseHV(nom_base,tomas,method,CP_CO);
%% Calculo de la fase absoluta

%Maskxx= Maskx;
Maskxx = zeros(size(Maskx));
for i=1:size(Maskx,3)
    for k =1:size(cPointsCO,1)
        a = round(cPointsCO(k,2,i));
        b= round(cPointsCO(k,1,i));
        Maskxx(a-2:a+2,b-2:b+2,i)=1;
    end
end
Maskxx=logical(Maskxx);
%% Calculo de la Fase de los planos
[Fasesxau,FX1] =  PhaseAdj(Fasesxu,Maskxu,3,1,[],1);
[Fasesyau,FY1] =  PhaseAdj(Fasesyu,Maskxu,3,1,[],1);
Maskx2u = Maskxu.*(FX1>-0.04 & FX1<0.04);
Masky2u = Maskxu.*(FY1>-0.04 & FY1<0.04);
[Fasesxau,FXu] =  PhaseAdj(Fasesxu,Maskx2u,3,1,[],1);
[Fasesyau,FYu] =  PhaseAdj(Fasesyu,Masky2u,3,1,[],1);
%
% Maskx3 = double((FX>-0.1 & FX<0.1));
% Masky3 = double((FY>-0.1 & FY<0.1));
% Maskx3(Maskx3<1)=NaN;
% Masky3(Masky3<1)=NaN;

for i=1:size(FX,3)
figure(700+2*i)  , imagesc(FXu(:,:,i)), title(['Error Ajuste3 imagen ',num2str(i),' Franjas V']), colorbar, colormap gray
figure(700+2*i+1), imagesc(FYu(:,:,i)), title(['Error Ajuste3 imagen ',num2str(i),' Franjas H']), colorbar, colormap gray
end
%% Fase de las esquinas del patron a color 
%PI2 =reshape([PI(:,1),PI(:,2)]',[1 2 6]);
%ucPointsCO(:,:,7)=[];
cPoints2=cat(1,cPointsCO,PI);
%PI =Compensar_Distorsion(PI,cameraParams2);
% Fxref = PhaseAdj(Fasesx,Maskx2,6,1,PI);
% Fyref = PhaseAdj(Fasesy,Masky2,6,1,PI);
FasexaP = PhaseAdj(Fasesx,Maskx2,3,1,cPoints2,1); % Fase de los puntos con variacion en x
FaseyaP = PhaseAdj(Fasesy,Masky2,3,1,cPoints2,1); % Fase de los puntos con variacion en y
%%
Fxref = FasexaP(end,:,:);
Fyref = FaseyaP(end,:,:);
FasexabsP = FasexaP(1:end-1,:,:) - repmat(Fxref,[size(FasexaP,1)-1,1,1]); %Fase absoluta de puntos en direccion x
FaseyabsP = FaseyaP(1:end-1,:,:) - repmat(Fyref,[size(FaseyaP,1)-1,1,1]); %Fase absoluta de puntos en direccion y
%%
Fasesxabs = Fasesxa - repmat(Fxref,[size(Fasesxa,1),size(Fasesxa,2),1]);
Fasesyabs = Fasesya - repmat(Fyref,[size(Fasesxa,1),size(Fasesxa,2),1]);
%% Conversion de fase a pixel del proyector
paso =12; Ancho = 1280; Alto = 1024;
Xp = paso*FasexabsP/(2*pi)+Ancho/2;
Yp = paso*FaseyabsP/(2*pi)+Alto/2;

Xpc = paso*Fasesxabs/(2*pi)+Ancho/2;
Ypc = paso*Fasesyabs/(2*pi)+Alto/2;

%% Calculo de matriz de intrinsecos y extrinsecos del proyecto
pPoints =cPointsCO;
wPoints =CP_CO.WorldPoints;
pPoints(:,1,:)=Xp; pPoints(:,2,:)=Yp;

PP_CO = estimateCameraParameters(pPoints(:,:,:),wPoints,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true,'EstimateSkew',false);
uPP_CO = estimateCameraParameters(Compensar_Distorsion(pPoints(:,:,:),PP_CO),wPoints,'NumRadialDistortionCoefficients',3,'EstimateTangentialDistortion',true,'EstimateSkew',true);
%pPoints =Compensar_Distorsion(pPoints,cameraParams_p);
%%
for i=1:size(Xpc,3)
    [uc,vc]=meshgrid(1:size(Xpc,2),1:size(Xpc,1));
    up=Xpc(:,:,i);
    vp=Ypc(:,:,i); 
    Hh(:,:,i) = homography2d([uc(:)';vc(:)';ones(size(up(:)))'],[up(:)';vp(:)';ones(size(up(:)))']);
end
%%
for im = 1:size(cPoints,3)
    Ic = double(imread([dir_principal,'\Imagenes_calibracion\Planos_corresp_Fondo_c_' ,num2str(toma),'.bmp']));
end
%%
%pPoints2 =Compensar_Distorsion(pPoints,cameraParams_p);
%cPoints=Compensar_Distorsion(cPoints,cameraParams2);
centroides = cell([1,size(cPointsCO,3)]);
for im = 1:15%size(cPointsCO,3)
%for im = 1:1
x_p =[pPoints(:,:,im)';ones([1,size(cPointsCO(:,:,1),1)])];
x_c =[cPointsCO(:,:,im)';ones([1,size(cPointsCO(:,:,1),1)])];
%H = homography2d(x_c,x_p);
H =Hh(:,:,im);
toma = tomas(im);
[X,Y] = meshgrid(1:20:Ancho,1:20:Alto);
%undistoredP = undistortPoints([X(:),Y(:)],CP_CO);
 
Ih = double(imread([dir,nombase,'_Fr_h_paso_12_pl_toma_' ,num2str(toma),'.bmp']));
Io = double(imread([dir,nombase,'_Fr_v_paso_12_obj_toma_',num2str(toma),'.bmp']));
Iv = double(imread([dir,nombase,'_Fr_v_paso_12_pl_toma_' ,num2str(toma),'.bmp']));
Ic = double(imread([dir,nombase,'_Fondo_c_' ,num2str(toma),'.bmp']));
Im = (Ih-Io).*(Iv-Io);%.*Maskx(:,:,im);
%Im = Ic;
%Im = undistortImage(Im,CP_CO); % Compensamos la distorsion de la cam
%Im = undistortImage(Im,PP_CO);
%Im = (Ih-Io).*(Iv-Io); % Compensamos la distorsion de la cam
im_reg = (((Iv-Io)>12)&((Ih-Io)>12));

centr = Centroides_malla(im_reg,Maskx(:,:,im))';
centroides{im} = homoTrans(H,makehomogeneous(centr));


%imnew = imTransD(Iv,H,[Alto Ancho]);
imnew = imTransD(Im,H,[Alto Ancho]);
%imnew = imTransD(Ic,H,[Alto Ancho]);

%figure(500+im), imagesc(imnew), hold on, plot(x_p(1,:),x_p(2,:),'+b')
%imnew = undistortImage(imnew,cameraParams_p);
%figure(500+im), imagesc(imnew),hold on, plot(X(:),Y(:),'+r') 
%figure(500+im), imagesc(imnew),hold on, plot(centroides{im}(1,:),centroides{im}(2,:),'+r') 
figure(600+im), imagesc(imnew),hold on, plot(X(:),Y(:),'oy'), plot(centroides{im}(1,:),centroides{im}(2,:),'+r') 
%plot(x_c(1,:),x_c(2,:),'*r')
%figure(500+im), imagesc(Im>1400)
%figure, imagesc(undistortImage(imnew,cameraParams_p))
end
%%
ImageP(:,:,:,1) =  cPointsCO;
ImageP(:,:,:,2) =  pPoints;
[stereoParams,pairsUsed,estimationErrors] = estimateCameraParameters(ImageP,wPoints);
%%
save('StereoParams.mat','stereoParams')
%%
%for i=1:n_imagen
n=21;
figure(i+1), imagesc(I{i})
hold on, plot(Xc{i}(1:n*(boardSize(1)-1),1),Xc{i}(1:n*(boardSize(1)-1),2),'*r')
%plot(x_2(1,:)+1,x_2(2,:)+1,'ob')
%end
 




