%% Estudio comparativo phase shifting 3, 4, 5, 6 y 9 imagenes y Fourier Nomal y mejorado pi shifting
%% Cargamos parametros de calibracion Polinomial Delta Z
Resultadospath = '/Users/JesusPineda/Library/Mobile Documents/com~apple~CloudDocs/DC de sistemas opticos de reconstruccion 3D/Resultados MATLAB /';
Resultadosdecalibracion = 'Resultadoscalibracion3.mat';
load([Resultadospath,Resultadosdecalibracion]);
%% Obtenicion de fases por phase shifting
% Notas:
% Para phase shifting con tres imagenes necesitamos corrimientos de -2pi/3
% 0 y 2pi/3. Para phase shifting con cuatro imagenes imagenes necesitamos
% corrimiento de 0 pi/2 pi 3pi/2.
%%  FORMULA GENERAL
NT = [9 6 5 4 3];
Nombrebase = 'SemiEsfera_FS3';
pathfolder = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-11-16\Imagenes_reconstruccion\';
        
for i = 1 : size(NT,2)
    n = NT(i);
    ns=num2str(n);
    v=((2*pi/n)*((1:n)-ceil(n/2)));
    vn=sin(v);vd=cos(v); ISN=0;ISD=0;
    Nombrebase = ['SemiEsfera_FS',ns];
    
    
    for j = 1 : n
        Ia = double(imread([pathfolder,Nombrebase,'_v_paso_12_',num2str(j),'_1_toma_1.bmp']));
        ISN = Ia*vn(j)+ISN;
        ISD = Ia*vd(j)+ISD;
    end
    
    if i == 1
        Lineacentral = imread([pathfolder,'SemiEsfera_FS3_v_paso_12_cl_toma_1.bmp']);
        IC = double(imread([pathfolder,Nombrebase,'_v_paso_12_2_1_toma_1.bmp']));
        figure(1),imagesc(IC),colormap gray
        %Mask = imcomplement(roipoly);
        %Mask = roipoly;
        Mask = createMask(imfreehand);
        figure(1),imagesc(Lineacentral),colormap gray
        UWpoint = round(ginput(1));
        mod=sqrt((ISN).^2 +(ISD).^2);
        mod= (mod-min(mod(:)));
        mod= mod/max(mod(:));
        Mask2 =im2bw(mod,0.05);
    end
    phaseD(:,:,i) = atan2(ISN,ISD);
    
    
                 
    %PhaseC(:,:,i)=unwrap2DClasico(UWpoint,phaseD(:,:,i),Mask);
    PhaseC(:,:,i)=unwrap2DClasico(UWpoint,phaseD(:,:,i),Mask2);
end

%% Perfilometria de Fourier
% Calculo automatico de ventana de filtrado para la obtencion de la
% informacion tridimensional.
% IC = Imagen con corrimiento delta = 0.
phaseD(:,:,i+1) = AutoFiltre(IC,800,1);
PhaseC(:,:,i+1)=unwrap2DClasico(UWpoint,phaseD(:,:,i+1),ones(size(Mask)));
%% R3D
n0 = 19;
n = 1;
for i = n : n 
    a  = coefz(:,:,1); b  = coefz(:,:,2); c  = coefz(:,:,3);
    ax = coefx(:,:,1); bx = coefx(:,:,2); cx = coefx(:,:,3);
    ay = coefy(:,:,1); by = coefy(:,:,2); cy = coefy(:,:,3);
%     DeltaF = PhaseC(:,:,n)-Fasesx(:,:,n0);
    DeltaF = PhaseC(:,:,n);
    Zc =a.*DeltaF.^2+b.*DeltaF+c;
    %Xc = ax.*DeltaF.^2+bx.*DeltaF+cx; %Coordenada en X
    %Yc = ay.*DeltaF.^2+by.*DeltaF+cy; %Coordenada en Y
    Xc = ax.*Zc.^2+bx.*Zc+cx;%Coordenada en x;
    Yc = ay.*Zc.^2+by.*Zc+cy;%Coordenada en x;
%     Xsphere = Xc(Mask); Ysphere = Yc(Mask); Zsphere = Zc(Mask);
    Xsphere = Xc(Mask2); Ysphere = Yc(Mask2); Zsphere = Zc(Mask2);
    figure(1),plot3(Xsphere,Ysphere,Zsphere,'b.'); hold on
    %figure(2),imagesc(Yc);hold on
end
hold off

%% Ajuste de esfera 3D
X = [Xsphere,Ysphere,Zsphere];
[Center_LSE,Radius_LSE] = sphereFit(X);
figure(43);clf;
plot3(X(:,1),X(:,2),X(:,3),'r.')
hold on;daspect([1,1,1]);
[Base_X,Base_Y,Base_Z] = sphere(20);
surf(Radius_LSE*Base_X+Center_LSE(1),...
    Radius_LSE*Base_Y+Center_LSE(2),...
    Radius_LSE*Base_Z+Center_LSE(3),'faceAlpha',0.3,'Facecolor','b')
title({['Sphere fit with ' num2str(size(X,1))];...
    ['Predicted Center: ' num2str(Center_LSE) ', Radius: ' num2str(Radius_LSE)]});
view([45,28])
legend({'Data','Actual Sphere','LSE Sphere'},'location','W')
Zt = Center_LSE(3)-sqrt(Radius_LSE^2-(Xc-Center_LSE(1)).^2 - (Yc-Center_LSE(2)).^2);
ind  = ones(size(Zt)); ind2 = ind; ind(abs(imag(Zt))>0) = NaN;
ind2(Mask<1) = NaN;
Emap = Zt-Zc;
figure(454), imagesc(real(Emap).*ind.*ind2);%improfile;

%% Ajuste de esfera 2D
figure(453),imagesc(IC),colormap gray
POI = round(ginput(2));
%%
%C = Zc(POI(1,2),POI(1,1):POI(2,1));
%X = Xc(POI(1,2),POI(1,1):POI(2,1));
C = Zc(POI(1,2):POI(2,2),POI(1,1));
Y = Yc(POI(1,2):POI(2,2),POI(1,1));
%figure,plot(X,C);axis equal;
figure,plot(Y,C);axis equal
%%
%XC = X;
XC = Y;
YC = C;
figure,plot(XC,YC);
[xc,yc,Re,a] = circfit(XC,YC);

Yt = yc - sqrt(Re^2-(XC-xc).^2);
figure(1212),plot(XC,YC-Yt)
th = linspace(0,2*pi,20)';

xe = Re*cos(th)+xc; ye = Re*sin(th)+yc;
plot(XC,YC,'o',[xe;xe(1)],[ye;ye(1)],'-.'),
title(' measured fitted and true circles')
legend('measured','fitted','true')
%text(xc-R*0.9,yc,sprintf('center (%g , %g );  R=%g',xc,yc,Re))
xlabel x, ylabel y
axis equal
Re