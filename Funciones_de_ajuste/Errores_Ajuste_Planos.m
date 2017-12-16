%% Extraemos las fases de los planos para reconstruir
nombv= 'Corres2_Fr_v_paso_12_';
nombh= 'Corres2_Fr_h_paso_12_';
S = load('CalibracionS.mat');
Z = load('CalibracionZ.mat');
Z2 =load('CalibracionZU2.mat');
Z3 =load('CalibracionZU3.mat');
nomd = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-09-18\Imagenes_calibracion\';
%[Fasescx,Maskx,Fasescy,Masky,imagen] = ExtraccionFase4(nomd,nombh,nombv,1:15);
%[imagen] = ExtraccionFase4(nomd,nombh,nombv,1:15);
Fas = Z.Fasesx; %Fasescx; %S.Fasesx;
Mask = Z.Mask ; %Maskx;

%% Errores por calibracion DZ sin compensar
coex = cat(3,Z.ax,Z.bx,Z.cx);
coey = cat(3,Z.ay,Z.by,Z.cy);
coez = cat(3,Z.a ,Z.b ,Z.c );

Ind=Mask; 
Ind(Ind<1)=NaN;
Puntos  = CalibracionDeltaPhase(Fas.*Ind,Z.Fasesx(:,:,31),coex,coey,coez);
e1 = Ajuste_plano(Puntos);

e=e1;
ei = reshape(e,[size(e,1)*size(e,2) size(e,3)]);
for i=1:size(ei,2)
    in1 = ~isnan(ei(:,i));
    erms1(i) = sqrt(sum((ei(in1,i)-mean(ei(in1,i))).^2)/numel(ei(in1,i)));
end
%% Errores por calibracion DZ 2 coeficientes
coex = cat(3,Z2.ax,Z2.bx,Z2.cx);
coey = cat(3,Z2.ay,Z2.by,Z2.cy);
coez = cat(3,Z2.a ,Z2.b ,Z2.c );

uF=Fas;
Ind2 = Ind;
for i = 1:size(uF,3)
    uF(:,:,i)   = undistortImage(uF (:,:,i),S.stereoParams.CameraParameters1);
    Ind2(:,:,i) = undistortImage(Ind(:,:,i),S.stereoParams.CameraParameters1);
end

Puntos2 = CalibracionDeltaPhase(uF.*Ind2,Z2.Fasesx(:,:,31),coex,coey,coez);
e2 = Ajuste_plano(Puntos2);
in2 = ~isnan(e2);

e=e2;
ei = reshape(e,[size(e,1)*size(e,2) size(e,3)]);
for i=1:size(ei,2)
    in1 = ~isnan(ei(:,i));
    erms2(i) = sqrt(sum((ei(in1,i)-mean(ei(in1,i))).^2)/numel(ei(in1,i)));
end

%% Errores por calibracion DZ 3 coeficientes
coex = cat(3,Z3.ax,Z3.bx,Z3.cx);
coey = cat(3,Z3.ay,Z3.by,Z3.cy);
coez = cat(3,Z3.a ,Z3.b ,Z3.c );

uF   = Fas;
Ind2 = Ind;
for i = 1:size(uF,3)
    uF(:,:,i)   = undistortImage( uF(:,:,i),S.stereoParams3.CameraParameters1);
    Ind2(:,:,i) = undistortImage(Ind(:,:,i),S.stereoParams3.CameraParameters1);
end

Puntos3 = CalibracionDeltaPhase(uF.*Ind2,Z3.Fasesx(:,:,31),coex,coey,coez);
e3 = Ajuste_plano(Puntos3);

e=e3;
ei = reshape(e,[size(e,1)*size(e,2) size(e,3)]);
for i=1:size(ei,2)
    in1 = ~isnan(ei(:,i));
    erms3(i) = sqrt(sum((ei(in1,i)-mean(ei(in1,i))).^2)/numel(ei(in1,i)));
end
disp(num2str([erms1' erms2' erms3']))
%% Errores por calibracion stereo 

Ps1  = CalibracionStereo(Fas,Mask,[1280 1024 12],S.stereoParams,0);
Ps1u = CalibracionStereo(Fas,Mask,[1280 1024 12],S.stereoParams,1);

Ps1(~Mask) = NaN;
Ind=Mask; Ind(~Mask)=NaN;

Masku = Mask;
for i = 1:size(Mask,3)
%     Masku(:,:,i)   = undistortImage(Mask(:,:,i),S.stereoParams.CameraParameters1);
Masku(:,:,i) = imerode(Mask(:,:,i),strel('disk',10));
end
Ps1u(~Masku) = NaN;

e4 = Ajuste_plano(Ps1);
e5 = Ajuste_plano(Ps1u);

e=e4;
ei = reshape(e,[size(e,1)*size(e,2) size(e,3)]);
for i=1:size(ei,2)
    in1 = ~isnan(ei(:,i));
    erms4(i) = sqrt(sum((ei(in1,i)-mean(ei(in1,i))).^2)/numel(ei(in1,i)));
end

e=e5;
ei = reshape(e,[size(e,1)*size(e,2) size(e,3)]);
for i=1:size(ei,2)
    in1 = ~isnan(ei(:,i));
    erms5(i) = sqrt(sum((ei(in1,i)-mean(ei(in1,i))).^2)/numel(ei(in1,i)));
end

disp(num2str([round(erms4,4)' round(erms5,4)']))
%%
Ps2  = CalibracionStereo(Fas,Mask,[1280 1024 12],S.stereoParams3,0);
Ps2u = CalibracionStereo(Fas,Mask,[1280 1024 12],S.stereoParams3,1);

Ps2(~Mask) = NaN;
Masku = Mask;
for i = 1:size(Mask,3)
%     Masku(:,:,i)   = undistortImage(Mask(:,:,i),S.stereoParams.CameraParameters1);
Masku(:,:,i) = imerode(Mask(:,:,i),strel('disk',10));
end

Ps2u(~Masku) = NaN;
e6 = Ajuste_plano(Ps2);
e7 = Ajuste_plano(Ps2u);

e=e6;
ei = reshape(e,[size(e,1)*size(e,2) size(e,3)]);
for i=1:size(ei,2)
    in1 = ~isnan(ei(:,i));
    erms6(i) = sqrt(sum((ei(in1,i)-mean(ei(in1,i))).^2)/numel(ei(in1,i)));
end


e=e7;
ei = reshape(e,[size(e,1)*size(e,2) size(e,3)]);
for i=1:size(ei,2)
    in1 = ~isnan(ei(:,i));
    erms7(i) = sqrt(sum((ei(in1,i)-mean(ei(in1,i))).^2)/numel(ei(in1,i)));
end


disp(num2str([round(erms6,4)' round(erms7,4)']))




