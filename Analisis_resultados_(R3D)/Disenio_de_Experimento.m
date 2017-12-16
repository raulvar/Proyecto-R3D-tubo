%% Analisis de plano para un diseño de experimento factorial 
% Se analiza la incidencia del factor gamma, la tecnica de calibracion, el
% metodo de extraccion de fase y las distorsiones de los lentes.
%%  FORMULA GENERAL
NT = 12;
v=((2*pi/NT)*((1:NT)-ceil(NT/2)));
st='C';
Nombrebase = ['Plano_',st,'G'];
pathfolder = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-11-16\Imagenes_reconstruccion\';
toma='3';
clear Ia
for i = 1 : NT
    Ia(:,:,i) = double(imread([pathfolder,Nombrebase,'_v_paso_12_',num2str(i),'_1_toma_',toma,'.bmp']));
end   

% Corrimiento a 3 imagenes
I1=  Ia(:,:,2);
I2=  Ia(:,:,6);
I3=  Ia(:,:,10);
phased_3 = -atan2(sqrt(3)*(I1-I3),2*I2-I1-I3);

% Corrimiento a 4 imagenes
I1 =  Ia(:,:,6);  
I2 =  Ia(:,:,9); 
I3 =  Ia(:,:,12);
I4 =  Ia(:,:,3);
phased_4 = -atan2(I4-I2,I1-I3);

% Transformada de Fourier

phased_1= AutoFiltre(I1,800,1);
%
Lineacentral = imread([pathfolder,Nombrebase,'_v_paso_12_cl_toma_',toma,'.bmp']);
IC = double(imread([pathfolder,Nombrebase,'_v_paso_12_2_1_toma_',toma,'.bmp']));

figure(1),imagesc(IC),colormap gray
if(~exist('Mask','var'))
    Mask = createMask(imfreehand);
end
figure(1),imagesc(Lineacentral),colormap gray
if(~exist('UWpoint','var'))
 UWpoint = round(ginput(1));
end

%UWpoint = round(ginput(1));

PhaseC1=unwrap2DClasico(UWpoint,phased_1,Mask);
PhaseC3=unwrap2DClasico(UWpoint,phased_3,Mask);
PhaseC4=unwrap2DClasico(UWpoint,phased_4,Mask);
%

if(strcmp(st,'S'))
    F3_S = NaN*PhaseC3;
    F1_S=F3_S;
    F4_S=F3_S;
    F1_S(Mask) = PhaseC1(Mask);
    F3_S(Mask) = PhaseC3(Mask);
    F4_S(Mask) = PhaseC4(Mask);
else
    F3_C = NaN*PhaseC3;
    F1_C=F3_C;
    F4_C=F3_C;
    F1_C(Mask) = PhaseC1(Mask);
    F3_C(Mask) = PhaseC3(Mask);
    F4_C(Mask) = PhaseC4(Mask);
end
%%  Calibracion polinomial
%load('FasesGS.mat');
load('17-11-16_ESTEREO.mat')
Fases = cat(3,F1_C,F1_S,F3_C,F3_S,F4_C,F4_S);
Z0=load('POLY2_XYZ_FA_0.mat');
Z2=load('POLY2_XYZ_FA_2.mat');
Z3=load('POLY2_XYZ_FA_3.mat');

P_P0 = CalibracionDeltaPhaseN(Fases,F1_C.^0,Z0.coefx,Z0.coefy,Z0.coefz);

uF2   = Fases; uF3   = Fases;
for i = 1:size(uF2,3)
    uF2(:,:,i)   = undistortImage( uF2(:,:,i),stereoParams2.CameraParameters1);
    uF3(:,:,i)   = undistortImage( uF3(:,:,i),stereoParams3.CameraParameters1);
end
P_P2 = CalibracionDeltaPhaseN(uF2,F1_C.^0,Z2.coefx,Z2.coefy,Z2.coefz);
P_P3 = CalibracionDeltaPhaseN(uF3,F1_C.^0,Z3.coefx,Z3.coefy,Z3.coefz);
% Calibracion estereo


P_S0 = CalibracionStereo(Fases,~isnan(Fases),[1280 1024 12],stereoParams3,0);
P_S2 = CalibracionStereo(Fases,~isnan(Fases),[1280 1024 12],stereoParams2,1);
P_S3 = CalibracionStereo(Fases,~isnan(Fases),[1280 1024 12],stereoParams3,1);
%
Ind = P_P0.^0;
Ind(isnan(P_P0))=NaN;

e_P0 = Ajuste_plano(P_P0);
e_P2 = Ajuste_plano(P_P2);
e_P3 = Ajuste_plano(P_P3);

e_S0 = Ajuste_plano(P_S0.*Ind);
e_S2 = Ajuste_plano(P_S2.*Ind);
e_S3 = Ajuste_plano(P_S3.*Ind);
%

RMS_P0 = RMS(e_P0);
RMS_P2 = RMS(e_P2);
RMS_P3 = RMS(e_P3);

RMS_S0 = RMS(e_S0);
RMS_S2 = RMS(e_S2);
RMS_S3 = RMS(e_S3);

%save('Puntos_plano',toma,'_disenio.mat','P_P0','P_P2','P_P3','P_S0','P_S2','P_S3')
save(['Errores_plano',toma,'.mat'],'RMS_P0','RMS_P2','RMS_P3','RMS_S0','RMS_S2','RMS_S3')
%%




























