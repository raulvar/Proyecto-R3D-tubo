%% Extraemos las fases de los planos para reconstruir
nombv= 'Corres2_Fr_v_paso_12_';
nombh= 'Corres2_Fr_h_paso_12_';
S = load('CalibracionS.mat');
load('ExtraccionFase_PlanosRotados_PhaseShif.mat')
Z = load('Calibracion_Polinomio2_UD0.mat','coefx','coefy','coefz','Fasesx','Mask');
Z3 =load('Calibracion_Polinomio2_UD3.mat','coefx','coefy','coefz','Fasesx');
nomd = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-09-18\Imagenes_calibracion\';
%[Fasescx,Maskx,Fasescy,Masky,imagen] = ExtraccionFase4(nomd,nombh,nombv,1:15);
%[imagen] = ExtraccionFase4(nomd,nombh,nombv,1:15);

Fas  = Fasescx; %
Mask = Maskx;   %

% Fas  = S.Fasesx;%Fasescx; %
% Mask = S.Maskx;%Maskx;   %
% Fas  = Z.Fasesx;%Fasescx; %
% Mask = Z.Mask;%Maskx;   %


%% Errores por calibracion DZ sin compensar
coex = Z.coefx; coey = Z.coefy; coez = Z.coefz;
Ind=Mask; Ind(Ind<1)=NaN;
Puntos  = CalibracionDeltaPhaseN(Fas.*Ind,Z.Fasesx(:,:,31),coex,coey,coez);


MaskZ = Puntos(:,:,:,3)<46.4 & Puntos(:,:,:,3)>-48 & ~isnan(Puntos(:,:,:,3)); 
%MaskZ(~logical(MaskZ)) =  NaN;
 [X,Y] = meshgrid(1:size(Mask,2),1:size(Mask,1));
% for i=1:size(Mask,3)
%     figure(90), imagesc(Puntos(:,:,i,3)), colormap gray
%     xi = X(MaskZ(:,:,i)); yi = Y(MaskZ(:,:,i));
%     hold on, plot(xi(1:15:end),yi(1:15:end),'.'), hold off
%     Masku = double(roipoly); Masku(logical(~Masku))=NaN;
%     Maskuu(:,:,i) = Masku;
% end
e1 = Ajuste_plano(Puntos,Maskuu);
regions1=regionprops(~isnan(Maskuu(:,:,13)),'BoundingBox');
regions2=regionprops(~isnan(e1(:,:,13)),'BoundingBox');
%%
figure(800), imagesc((e1(:,:,13))), colormap gray; colorbar, hold on
rec2=regions2.BoundingBox;
rec1=regions1.BoundingBox;
rectangle('Position',rec1,'LineWidth',1.5,'EdgeColor','r')
rectangle('Position',rec2,'LineWidth',1.5,'EdgeColor','b')
xlim([rec2(1)-90 90+rec2(1)+rec2(3)])
ylim([rec2(2)-90 90+rec2(2)+rec2(4)])
text(rec2(1)+rec2(3)-280,rec2(2)+rec2(4)-25,'erms = 1.10 mm','Color','b','Fontsize',12)
text(rec1(1)+rec1(3)-280,rec1(2)+rec1(4)-30,'erms = 0.13 mm','Color','r','Fontsize',12)
xlabel('X-Pixels')
ylabel('Y-Pixels')
hold off
%%
% e1 = Ajuste_plano(Puntos);
e=e1;
ei = reshape(e,[size(e,1)*size(e,2) size(e,3)]);
erms1=zeros([1,size(ei,2)]);
for i=1:size(ei,2)
    in1 = ~isnan(ei(:,i));
    erms1(i) = sqrt(sum((ei(in1,i)-mean(ei(in1,i))).^2)/numel(ei(in1,i)));
end

%% Errores por calibracion DZ 3 coeficientes
coex = Z3.coefx; coey = Z3.coefy; coez = Z3.coefz;
uF   = Fas; Ind2 = Ind;

for i = 1:size(uF,3)
    uF(:,:,i)   = undistortImage( uF(:,:,i),S.stereoParams3.CameraParameters1);
    Ind2(:,:,i) = undistortImage(Ind(:,:,i),S.stereoParams3.CameraParameters1);
end

Puntos3 = CalibracionDeltaPhaseN(uF.*Ind2,Z3.Fasesx(:,:,31),coex,coey,coez);

%e3 = Ajuste_plano(Puntos3);
% e3= Ajuste_plano(Puntos3.*repmat(Maskuu,[1 1 1 3]));
e3= Ajuste_plano(Puntos3,Maskuu);
e=e3;
ei = reshape(e,[size(e,1)*size(e,2) size(e,3)]);
erms2=zeros([1,size(ei,2)]);
for i=1:size(ei,2)
    in1 = ~isnan(ei(:,i));
    erms2(i) = sqrt(sum((ei(in1,i)-mean(ei(in1,i))).^2)/numel(ei(in1,i)));
end
disp(num2str([erms1' erms2']))
%% Errores por calibracion stereo 
Ps2  = CalibracionStereo(Fas,Mask,[1280 1024 12],S.stereoParams3 ,0);
Psu = CalibracionStereo(Fas,Mask,[1280 1024 12],S.stereoParams,1);
Ps2u = CalibracionStereo(Fas,Mask,[1280 1024 12],S.stereoParams3,1);

Ps2(~Mask) = NaN;
Masku = Mask;
for i = 1:size(Mask,3)
%     Masku(:,:,i)   = undistortImage(Mask(:,:,i),S.stereoParams.CameraParameters1);
Masku(:,:,i) = imerode(Mask(:,:,i),strel('disk',10));
end

Ps2u(~Masku) = NaN;
MaskZ = ~isnan(Ps2(:,:,:,3)); 

 [X,Y] = meshgrid(1:size(Mask,2),1:size(Mask,1));
for i=1:size(Mask,3)
    figure(90), imagesc(Ps2(:,:,i,3)), colormap gray
    xi = X(MaskZ(:,:,i)); yi = Y(MaskZ(:,:,i));
    hold on, plot(xi(1:15:end),yi(1:15:end),'.'), hold off
    Masku = double(roipoly); Masku(logical(~Masku))=NaN;
    Maskuu(:,:,i) = Masku;
end




e6 = Ajuste_plano(Ps2,Maskuu);
e7 = Ajuste_plano(Ps2u,Maskuu);
e8 = Ajuste_plano(Psu,Maskuu);
%%

p1= e6(:,:,4); p2=e7(:,:,4); p3=e8(:,:,4);
%p2(1,1) = min(p1(:)); p2(end,end)=max(p1(:)); 
figure, imagesc(p1)
figure, imagesc(p2)
figure, imagesc(p3)
%%

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

%%
save('PuntosYErrores_PlanosRotadosPS_AjusteDeSoloDentro.mat','Puntos','Puntos3','Maskuu','e1','e3','erms1','erms2')
%%
a=4; b=4;
figure,
for i=1:size(Maskuu,3) 
    subplot(a,b,i), imagesc(Maskuu(:,:,i))
    title(num2str(i))
end



