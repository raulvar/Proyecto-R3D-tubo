% dir = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-09-18\Imagenes_calibracion\';
% nombase = 
% tomas=1:60;
% for i=tomas
%     I{i} = [dir,nombase,'_Fondo_c',num2str(i),'.bmp'];
% end
% 
% dirc = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-09-12\Imagenes_calibracion\';
% nombasec = 'Corresp';
% nombc = [dirc,nombasec,'_Fondo_c_'];
% n_imagenc = 15; squareSizec =10.00;
% [cPointsCO,ucPointsCO,CP_CO,uCP_CO]  = CalibrarCamara(nombc,n_imagenc,squareSizec);
% 
% wP=CP_CO.WorldPoints;
%%
for iio=1:3
clearvars -except iio
load('17-11-16_ESTEREO.mat')
dir = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-11-16\Imagenes_calibracion\';
%dir = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-09-18\Imagenes_calibracion\';

nombase = 'DeltaZ';
nomb2 = [dir,nombase,'_Fondo_c'];
%n_imagen = 60; 
n_imagen = 38;
squareSize =10.00;

I = Active_image(nomb2,'.bmp',n_imagen);
%I1 = imread(I{1,1});
[cP,boardSize,Ind]  = detectCheckerboardPoints2(I);
wP = generateCheckerboardPoints(boardSize, squareSize);
kkk = '023';

    if (iio==1)
        cameraParams=[];
    elseif (iio==2)
        cameraParams=stereoParams2.CameraParameters1;
    elseif(iio==3)
        cameraParams=stereoParams3.CameraParameters1;
    end
    
cP = Compensar_Distorsion(cP,cameraParams);
tomas = find(Ind); 
MP  = reshape( cP,[boardSize-1 2 sum(Ind)]);
Mask  = createMaskCB(I,tomas,MP,30);
% 
nom_base= [dir,nombase];
[Fasesx,PI ] = ExtraerFaseV(nom_base,tomas,Mask,cameraParams);
Ind = Mask;
Ind(~Mask)=NaN;

%
nn = 38; n0=19; Z=3.2*((1:nn)-n0);
%nn = 60; n0=30; Z=1.6*((1:nn)-n0);

%DeltaF = (Fasesx.*Ind - repmat(Fasesx(:,:,n0).*Ind(:,:,n0),[1 1 nn]));
DeltaF = (Fasesx.*Ind);
DZ = repmat(reshape(Z,[1 1 numel(Z)]),[size(DeltaF(:,:,1)),1]);
%[a,b,c] = Fit3_3D1(Z,DeltaF); % Z = a(i,j)*fi(i,j)^2+b(i,j)*fi(i,j)+c(i,j)
tic
%[coefz5,errorz5] = Polyfit5_3D(DeltaF,DZ);
%[coefz3,errorz3] = Polyfit3_3D(DeltaF,DZ);
[coefz2,errorz2] = Polyfit2_3D(DeltaF,DZ);

toc
%
% 
% for i=1:25
%     figure(80), imagesc(DeltaF(:,:,1))
%     [ux,uy]=ginput(1);
%     ux=round(ux); uy=round(uy);
%     f = shiftdim(DeltaF(uy,ux,:));
%     a = coef(uy,ux,1); b = coef(uy,ux,2); c = coef(uy,ux,3); d = coef(uy,ux,4); e = coef(uy,ux,5); g = coef(uy,ux,6);
%     figure(81), hold off, plot(Z,f,'*'), hold on, plot(a*f.^5+b*f.^4+c*f.^3+d*f.^2+e*f+g,f)
%     figure(82), hold off, plot(f,Z'-(a*f.^5+b*f.^4+c*f.^3+d*f.^2+e*f+g))
% end


% %% Ajuste en el plano por homografia
% uc=wP(:,1);vc=wP(:,2);
% a=coefz2(:,:,1);
% Ind  = find(~isnan(a));
% % Ind = find(ones(size(a)));
% [Iy,Ix] = ind2sub([size(a,1) size(a,2)],Ind);
% 
% Mx=NaN*ones(size(a))             ;My=NaN*ones(size(a));
% Nx2=NaN*ones([size(a) size(MP,4)]);Ny2=NaN*ones([size(a) size(MP,4)]);
% Ex2=ones([size(MP,1),size(MP,2),size(MP,4)]);
% Ey2=Ex2;
% for i = 1:size(MP,4)
%     up= MP(:,:,1,i);
%     vp= MP(:,:,2,i);
%     Hxy(:,:,i) = homography2d([up(:)';vp(:)';ones(size(up(:)))'],[uc(:)';vc(:)';ones(size(up(:)))']);
%     Np=Hxy(:,:,i)*makehomogeneous([Ix(:)';Iy(:)']);
%     
%     Ee=Hxy(:,:,i)*makehomogeneous([up(:)';vp(:)']);
%     Ex2(:,:,i) =  reshape(uc(:)'-Ee(1,:)./Ee(3,:),[size(MP,1),size(MP,2)]); %Errores transversal del modelo
%     Ey2(:,:,i) =  reshape(vc(:)'-Ee(2,:)./Ee(3,:),[size(MP,1),size(MP,2)]); %Errores transversal del modelo
%     
%     Xi = Np(1:2,:)./repmat(Np(3,:),[2,1]);
%     Mx(Ind)=Xi(1,:); My(Ind)=Xi(2,:);
%     Nx2(:,:,i)=Mx;    Ny2(:,:,i)=My;
% end
% Ajuste del plano por polinomio
uc=wP(:,1);vc=wP(:,2);
a=coefz2(:,:,1);
Ind  = find(~isnan(a));
% Ind = find(ones(size(a)));
[Iy,Ix] = ind2sub([size(a,1) size(a,2)],Ind);

Mx=NaN*ones(size(a))             ;My=NaN*ones(size(a));
Nx=NaN*ones([size(a) size(MP,4)]);Ny=NaN*ones([size(a) size(MP,4)]);
Ex = ones(size(MP,1),size(MP,2),size(MP,4));
Ey=Ex;
for i = 1:size(MP,4)
    up= MP(:,:,1,i);
    vp= MP(:,:,2,i);
    
    TT = Polyfit2D(uc(:),ones(size(up(:))),up(:),vp(:),3);
    Np=PolyVal2D_1(TT,1:size(Mx,2),1:size(Mx,1),3);
    Ex(:,:,i) = reshape(uc(:)-PolyVal2D_2(TT,up(:),vp(:),3),[size(Ex,1) size(Ex,2)]);
    Mx(Ind)=Np(Ind);
    
    TT = Polyfit2D(vc(:),ones(size(vp(:))),up(:),vp(:),3);
    Np=PolyVal2D_1(TT,1:size(Mx,2),1:size(Mx,1),3);
    Ey(:,:,i) = reshape(vc(:)-PolyVal2D_2(TT,up(:),vp(:),3),[size(Ex,1) size(Ex,2)]);
    My(Ind)=Np(Ind);
    Nx(:,:,i)=Mx;    Ny(:,:,i)=My;
end

%
Nxx=Nx;%-repmat(Nx(end/2,end/2,:),[size(Nx,1) size(Nx,2) 1]);
Nyy=Ny;%-repmat(Ny(end/2,end/2,:),[size(Nx,1) size(Nx,2) 1]);


 %[coefx5,errorx5] = Polyfit5_3D(DeltaF,Nxx);
%  [coefx3,errorx3] = Polyfit3_3D(DeltaF,Nxx);
tic
 [coefx2,errorx2] = Polyfit2_3D(DeltaF,Nxx);
 toc
 
 tic
 % [coefy5,errory5] = Polyfit5_3D(DeltaF,Nyy);
%  [coefy3,errory3] = Polyfit3_3D(DeltaF,Nyy);
 [coefy2,errory2] = Polyfit2_3D(DeltaF,Nyy);

toc
% %%
% errorx = errorx2;
% errory = errory2;
% errorz = errorz2;
% meanex=mean(abs(errorx),3); maex=max(errorx,[],3); miex=min(errorx,[],3);
% meaney=mean(abs(errory),3); maey=max(errory,[],3); miey=min(errory,[],3);
% meanez=mean(abs(errorz),3); maez=max(errorz,[],3); miez=min(errorz,[],3);
% %%
% Ermsx = sum((errorx-repmat(meanex,[1 1 size(errorx,3)])).^2/size(errorx,3),3);
% Ermsy = sum((errory-repmat(meaney,[1 1 size(errorx,3)])).^2/size(errorx,3),3);
% Ermsz = sum((errorz-repmat(meanez,[1 1 size(errorx,3)])).^2/size(errorx,3),3);
% %%
% paso = 3.2;
% figure, plot(paso*((1:nn)-n0),shiftdim(errorx(500,500,:))), hold on,plot(paso*((1:nn)-n0),shiftdim(errory(500,500,:)))
% plot(paso*((1:nn)-n0),shiftdim(errorz(500,500,:)))
% xlabel('Z [mm]')
% ylabel('Error [mm]')
% legend('X-calibration','Y-calibration','Z-calibration')
% printFig('E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\ARTICULO ENO\Errores_estimacion')
% 
% %%
% figure, imagesc(Ermsx), colorbar, colormap jet, xlabel('X-Pixels'), ylabel('Y-Pixels')
% xlim([130 1160]), ylim([100 860])
% %printFig('E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\ARTICULO ENO\ErmsX_calib')
% figure, imagesc(Ermsy), colorbar, colormap jet, xlabel('X-Pixels'), ylabel('Y-Pixels')
% xlim([130 1160]), ylim([100 860])
% %printFig('E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\ARTICULO ENO\ErmsY_calib')
% figure, imagesc(Ermsz), colorbar, colormap jet, xlabel('X-Pixels'), ylabel('Y-Pixels')
% xlim([130 1160]), ylim([100 860])
% %printFig('E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\ARTICULO ENO\ErmsZ_calib')
% %%
% figure, imagesc(meanex), colormap gray ;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')
% figure, imagesc(meaney), colormap gray;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')
% figure, imagesc(meanez), colormap gray;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')
% %%
% figure, imagesc(maex), colormap gray ;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')
% figure, imagesc(maey), colormap gray;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')
% figure, imagesc(maez), colormap gray;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')
% %%
% figure, imagesc(miex), colormap gray ;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')
% figure, imagesc(miey), colormap gray;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')
% figure, imagesc(miez), colormap gray;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')
% %%
% figure, imagesc(meanex), colormap gray ;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')
% figure, imagesc(meaney), colormap gray;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')
% figure, imagesc(meanez), colormap gray;colorbar
% xlabel('X-Pixels'),ylabel('Y-Pixels')

% %%
% % 
% % 
% for i=1:25
%     figure(80), imagesc(Nxx(:,:,1))
%     [ux,uy]=ginput(1);
%     %ux=500;uy=500;
%     ux=round(ux); uy=round(uy);
%     N = shiftdim(    Nxx(uy,ux,:));
%     f = shiftdim(DeltaF(uy,ux,:));
%     a = coefx(uy,ux,1); b = coefx(uy,ux,2); c = coefx(uy,ux,3); d = coefx(uy,ux,4); 
%     e = coefx(uy,ux,5); g = coefx(uy,ux,6);
%     figure(81), hold off, plot(N,f,'*'), 
%     hold on, plot(a*f.^5+b*f.^4+c*f.^3+d*f.^2+e*f+g,f)
%     figure(82), hold off, plot(f,N-(a*f.^5+b*f.^4+c*f.^3+d*f.^2+e*f+g))
% end
% %%
% imagen = zeros(size(DeltaF));
% for i=1:size(DeltaF,3)
%     if(~isempty(cameraParams))
%         imagen(:,:,i) = undistortImage(imread(I{i}),cameraParams);
%     else
%         imagen(:,:,i) = imread(I{i});
%     end
% end

coefx = coefx2; coefy = coefy2; coefz = coefz2;

save(['POLY2_XYZ_FA_',kkk(iio),'.mat'],'coefz','coefx','coefy')

disp(num2str(iio))


end













