[XC,YC] = meshgrid(0:10:100,0:10:100);
colors = 'brgkcm';
aux=[XC(:)';YC(:)';ones(size(XC(:)))']; 
figure(5); hold on
YYx = zeros(size(XC));
YYy = zeros(size(XC));
YYz = zeros(size(XC));
pa = CP_CO;
for i=1:6
    T = pa.TranslationVectors(i,:)';
    R = pa.RotationMatrices(:,:,i);
    Tp= [R,T;[0,0,0,1]];
    XW(:,:,i) = Tp*[aux(1,:);aux(2,:);zeros(size(XC(:)))';aux(3,:)]; 
    figure(5);
    YYx(:)=XW(1,:,i);
    YYy(:)=XW(2,:,i);
    YYz(:)=XW(3,:,i);
    
    hhh= mesh(YYx,YYz,-YYy);
    set(hhh,'edgecolor',colors(rem(i-1,6)+1),'linewidth',1); %,'facecolor','none');
    
    %plot3(XW(1,:,i),XW(3,:,i),-XW(2,:,i),'*'), hold on
end
ylim([0 660])
%%
cpp=PPg;
cpc=CP;
inde=1:13;
for i=1:13
    
    T = cpc.TranslationVectors(inde(i),:)';
    R = cpc.RotationMatrices(:,:,inde(i));
    Tp{i}= [R,T;[0,0,0,1]];
    
    T = cpp.TranslationVectors(i,:)';
    R = cpp.RotationMatrices(:,:,i);
    Tp2{i}= [R,T;[0,0,0,1]];
    
    TT(:,:,i) = (Tp{i}^-1)*Tp2{i};
    
end
%%

StereoP(:,:,:,1) = cPointsCO;
StereoP(:,:,:,2) = pPoints;
[cameraParams,imagesUsed,estimationErrors] = estimateCameraParameters(StereoP,wPoints);







