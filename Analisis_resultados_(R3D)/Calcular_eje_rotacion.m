dir = 'E:\Documentos\UTB\MAESTRIA\TESIS Y PROYECTOS\PROYECTO CALIBRACION STEREO Y R3D-360\17-07-28\Reconstrucciones_mesh\';
nomb = 'Planos_360_h_paso_12_';
%%
for i=1:1
clear A;
pc = nubep; %pcread([dir,nomb,num2str(i),'.ply']);
Planos{i} = pc.Location;
x{i} = Planos{i}(:,1);
y{i} = Planos{i}(:,2);
z{i} = Planos{i}(:,3);
A= [x{i},y{i},ones(size(Planos{i}(:,1)))];
AA = A'*A;
B = A'*z{i};
TT{i} = AA\B;
end
%%
for i=1:1
ze{i} = (TT{i}(1)*x{i}+TT{i}(2)*y{i}+TT{i}(3));
err{i}=z{i} - ze{i}; 
figure(200+i), plot3(x{i},y{i},z{i},'.r'), hold on
plot3(x{i},y{i},ze{i},'.b')

g{i} = zeros(size(Maskh));
m = MaskC(:,:,i);
g{i}(logical(m(:)))=err{i}(:);
%xx = cPointsCO(:,1,:);
%yy = cPointsCO(:,2,:);
indi=NaN*ones(size(g{i}));
%indi(MMM(:,:,i))=1;
% figure(300+i), imagesc(g{i}.*indi-mean2(g{i}(indi==1))), hold on, plot(xx(:),yy(:),'.r')
figure(300+i), mesh(g{i}.*indi-mean2(g{i}(indi==1)))
%MMM(:,:,i) = roipoly;
end


%%
clc
for a=1:5
ax(a)=  acosd(TT{a}(1)/norm([TT{a}(1:2);1]));
ay(a)=  acosd(TT{a}(2)/norm([TT{a}(1:2);1]));
az(a)=  acosd(      1/norm([TT{a}(1:2);1]));
end
ax,ay,az

%% Analisis de eje de rotacion

for i=1:5
n{i} = [TT{i}(1) TT{i}(2) -1]; 
n{i} = n{i}/norm(n{i});
if i>1
    ejes{i-1} = cross(n{1},n{i}); 
    ejes{i-1} = ejes{i-1}/norm(ejes{i-1}); 
    angulos{i-1} = acosd(ejes{i-1});
end
end

%%
for i=1:4
puntos{i} = [TT{1}(1) -1;TT{i+1}(1) -1]^-1*[-TT{1}(3);-TT{i+1}(3)];
end
%
R = rotationVectorToMatrix(pi/180*angulos{1}')^-1;
t = [puntos{1}(1);0;puntos{1}(2)];
%%
nomb = 'Gatico360_';
figure(8), hold off
ax=0;az=0;
while(1)
    for i=1:5
        pc = pcread([dir,nomb,num2str(i),'_x20.ply']);
        poin = pc.Location;
        npuntos = poin'- repmat(t+[ax,0,az]',[1,size(poin',2)]) ;
        npuntos = rotu(npuntos(1:3,:),[0 -1 0],18*(20-i));
        %npuntos = roty(360-i*18)*R*npuntos;
        pc2 = pointCloud(npuntos');
        pc2.Color = pc.Color;
        pcwrite(pc2,[dir,nomb,num2str(i),'_rot','.ply']);
        figure(8), hold on, pcshow(pc2)
       
    end
     pause()
     ax = ax-0.1;
     az = az+0.1;
end






