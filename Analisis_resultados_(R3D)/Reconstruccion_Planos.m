
S = load('CalibracionS.mat');
Z = load('CalibracionZ.mat');
Z2 =load('CalibracionZU2.mat');
Z3 =load('CalibracionZU3.mat');

%% Reconstruccion estereo de Planos rotados
Puntos  = CalibracionStereo(S.Fasesx,S.Maskx,[1280 1024 12],S.stereoParams,0);
Puntosu = CalibracionStereo(S.Fasesx,S.Maskx,[1280 1024 12],S.stereoParams,1);
save('R3D_S_PR.mat','Puntos','Puntosu')
%% Reconstruccion estereo de Planos perpendiculares Distorsionados
Mask = repmat(~isnan(Z.DeltaF(:,:,1)),[1 1 size(Z.DeltaF,3)]);
Puntos2  = CalibracionStereo(Z.Fasesx,Mask,[1280 1024 12],S.stereoParams,0);

Mask = repmat(~isnan(Z2.DeltaF(:,:,1)),[1 1 size(Z.DeltaF,3)]);
Puntos2u2 = CalibracionStereo(Z2.Fasesx,Mask,[1280 1024 12],S.stereoParams,0);

Mask = repmat(~isnan(Z3.DeltaF(:,:,1)),[1 1 size(Z.DeltaF,3)]);
Puntos2u3 = CalibracionStereo(Z3.Fasesx,Mask,[1280 1024 12],S.stereoParams,0);
save('R3D_S_PP.mat','Puntos2','Puntos2u2','Puntos2u3')
%% Reconstruccion DeltaZ de planos rotados y perpendiculaer sin compensar
coex = cat(3,Z.ax,Z.bx,Z.cx);
coey = cat(3,Z.ay,Z.by,Z.cy);
coez = cat(3,Z.a,Z.b,Z.c);
Ind=S.Maskx; Ind(Ind<1)=NaN;
Puntos3 = CalibracionDeltaPhase(S.Fasesx.*Ind,Z.Fasesx(:,:,31),coex,coey,coez);
Puntos4 = CalibracionDeltaPhase(Z.Fasesx,Z.Fasesx(:,:,31),coex,coey,coez);
save('PuntosD0c.mat','Puntos3','Puntos4')
%%  Reconstruccion DeltaZ de planos rotados y perpendiculaer compensando 2coef
coex = cat(3,Z2.ax,Z2.bx,Z2.cx);
coey = cat(3,Z2.ay,Z2.by,Z2.cy);
coez = cat(3,Z2.a ,Z2.b ,Z2.c);
Ind=S.Maskx; Ind(Ind<1)=NaN;
Puntos5 = CalibracionDeltaPhase(S.Fasesx.*Ind,Z2.Fasesx(:,:,31),coex,coey,coez);
Puntos6 = CalibracionDeltaPhase(Z2.Fasesx,Z2.Fasesx(:,:,31),coex,coey,coez);
save('PuntosD2c.mat','Puntos5','Puntos6')
%%  Reconstruccion DeltaZ de planos rotados y perpendiculaer compensando 3coef
coex = cat(3,Z3.ax,Z3.bx,Z3.cx);
coey = cat(3,Z3.ay,Z3.by,Z3.cy);
coez = cat(3,Z3.a ,Z3.b ,Z3.c);
Ind=S.Maskx; Ind(Ind<1)=NaN;
Puntos7 = CalibracionDeltaPhase(S.Fasesx.*Ind,Z3.Fasesx(:,:,31),coex,coey,coez);
Puntos8 = CalibracionDeltaPhase(Z3.Fasesx,Z3.Fasesx(:,:,31),coex,coey,coez);
save('PuntosD3c.mat','Puntos7','Puntos8')








