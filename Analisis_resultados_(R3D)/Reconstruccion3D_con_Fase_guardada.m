dir_imag = 'C:\Users\OPILAB\Documents\Proyecto_interno_tuboR3D\17-07-13';
nombasev= 'plano_v_paso_12';
nombaseh= 'plano_h_paso_12';
toma = 'toma_5';
load([dir_imag,'\Resultados_reconstruccion\',nombasev,'_',toma,'_fase.mat']);
load([dir_imag,'\Resultados_reconstruccion\',nombaseh,'_',toma,'_fase.mat']);
eval(['Fx = ',nombasev,'_PhaseC;'])
eval(['Fy = ',nombaseh,'_PhaseC;'])
eval(['Mx = ',nombasev,'_Mask;'])
eval(['My = ',nombaseh,'_Mask;'])
mask = Mx.*My;

lcv = double(imread([dir_imag,'\Imagenes_reconstruccion\',nombasev,'_cl_',toma,'.bmp']));
lch = double(imread([dir_imag,'\Imagenes_reconstruccion\',nombaseh,'_cl_',toma,'.bmp']));

ob = double(imread([dir_imag,'\Imagenes_reconstruccion\',nombasev,'_obj_',toma,'.bmp']));

[m,ind] = max((lcv(:)-ob(:)).*(lch(:)-ob(:)));
[uy,ux]= ind2sub(size(lcv),ind); 
Im = ((lcv-ob).*(lch-ob))>0.6*m;
PIobj = round(Centroides_malla(Im,ones(size(Im))));
figure, imagesc((lcv-ob).*(lch-ob)), colormap gray
hold on, plot(ux,uy,'*r'), plot(PIobj(1),PIobj(2),'bs')
%%
a = 1;
Fxa = Fx - Fx(PIobj(2),PIobj(1));
Fya = Fy - Fy(PIobj(2),PIobj(1));
paso = 12; Ancho = 1280; Alto=1024;
Xp = paso*Fxa/(2*pi)+Ancho/2;
Yp = paso*Fya/(2*pi)+Alto/2;
[Xc,Yc] = meshgrid(1:size(Fx,2),1:size(Fy,1)); 
mask = logical(mask);
mask=mask(:);
worldP = triangulate([Xc(mask(1:a:end)),Yc(mask(1:a:end))],[Xp(mask(1:a:end)),Yp(mask(1:a:end))],stereoParams);
figure(88),hold off,plot3(worldP(:,1),worldP(:,3),-worldP(:,2),'r.');

M =[];
M(:,1)=worldP(:,1);
M(:,2)=worldP(:,2);
M(:,3)=worldP(:,3);
nubep=pointCloud(M);
nubep.Color = uint8(repmat(ob(mask(1:a:end)),[1 3]));
[file,path] = uiputfile('*.ply','','');
pcwrite(nubep,[path,file],'PLYFormat','binary')








