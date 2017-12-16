PP = Puntos;%Puntos2;
Io = imagen;%Z.imagen;
for toma=1:1:15

Xc=PP(:,:,toma,1); Yc=PP(:,:,toma,2); Zc=PP(:,:,toma,3);
Xc = Xc(:);Yc = Yc(:);Zc = Zc(:);
%figure(88),hold off,plot3(Xc,Yc,Zc,'r.');
% 
% zlabel('\DeltaZ')
% xlabel('\DeltaX')
% ylabel('\DeltaY')
% axis equal


Ind = ~isnan(PP(:,:,toma,1));
M =[];
M(:,1)=Xc(Ind(:));
M(:,2)=Yc(Ind(:));
M(:,3)=Zc(Ind(:));
nubep=pointCloud(M);
 op = uint8(Io(:,:,toma));%255*imnormalize(Io);
%op = imread(I{toma});
nubep.Color = repmat(op(Ind(:)),[1 3]);
%[file,path] = uiputfile('*.ply','','E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-09-18\Imagenes_calibracion\');
pcwrite(nubep,['E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-09-18\Resultados_reconstruccion\PlanosRotados_XyY_depFase',num2str(toma)],'PLYFormat','binary')

%pcwrite(nubep,[path,file],'PLYFormat','binary')
end



