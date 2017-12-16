% function [Fasescx,Maskx,Fasescy,Masky,images] = ExtraccionFase4(nomd,nombh,nombv,tomas)
function [Fasescx,Maskx,Fasescy,Masky,images] = ExtraccionFase4(nomd,nombh,nombv,tomas)
k=0;

for toma=tomas
k=k+1;
Ih=double(imread([nomd,nombh,'cl_toma_',num2str(toma),'.bmp']));
Iv=double(imread([nomd,nombv,'cl_toma_',num2str(toma),'.bmp']));
Io=double(imread([nomd,nombv,'obj_toma_',num2str(toma),'.bmp']));
images(:,:,k)=Io;
if (k==1)
    Maskx=zeros([size(Ih) numel(tomas)]);
    Masky= Maskx; Fasescx=Maskx; Fasescy=Maskx;
end
[m,in]=max((Ih(:)-Io(:)).*(Iv(:)-Io(:)));
[yc,xc] = ind2sub(size(Ih),in);
a=1;
I1=0;I2=0;I3=0;I4=0;
for ni=1:a
    I1=I1+double(imread([nomd,nombv,'2_',num2str(ni),'_toma_',num2str(toma),'.bmp'],'bmp'));
    I2=I2+double(imread([nomd,nombv,'1_',num2str(ni),'_toma_',num2str(toma),'.bmp'],'bmp'));
    I3=I3+double(imread([nomd,nombv,'4_',num2str(ni),'_toma_',num2str(toma),'.bmp'],'bmp'));
    I4=I4+double(imread([nomd,nombv,'3_',num2str(ni),'_toma_',num2str(toma),'.bmp'],'bmp'));
end

I1=I1/a;I2=I2/a;I3=I3/a;I4=I4/a;
FaseD=atan2(I4-I2,I1-I3);
mod=sqrt((I4-I2).^2 +(I1-I3).^2);
mod= (mod-min(mod(:)));
mod= mod/max(mod(:));

figure, imagesc(Io)
% Maskx(:,:,k)=im2bw(mod,0.1);
Maskx(:,:,k)=roipoly;
Fasescx(:,:,k)=unwrap2DClasico([xc,yc],FaseD,Maskx(:,:,k));



I1=0;I2=0;I3=0;I4=0;
for ni=1:a
    I1=I1+double(imread([nomd,nombh,'4_',num2str(ni),'_toma_',num2str(toma),'.bmp'],'bmp'));
    I2=I2+double(imread([nomd,nombh,'3_',num2str(ni),'_toma_',num2str(toma),'.bmp'],'bmp'));
    I3=I3+double(imread([nomd,nombh,'2_',num2str(ni),'_toma_',num2str(toma),'.bmp'],'bmp'));
    I4=I4+double(imread([nomd,nombh,'1_',num2str(ni),'_toma_',num2str(toma),'.bmp'],'bmp'));
end

I1=I1/a;I2=I2/a;I3=I3/a;I4=I4/a;
FaseD=atan2(I4-I2,I3-I1);
mod=sqrt((I4-I2).^2 +(I1-I3).^2);
mod= (mod-min(mod(:)));
mod= mod/max(mod(:));

Masky(:,:,k)=im2bw(mod,0.1);
Fasescy(:,:,k)=unwrap2DClasico([xc,yc],FaseD,Masky(:,:,k));



end


end