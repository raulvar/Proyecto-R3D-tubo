MP = reshape(cP,[boardsize-1 2 sum(Ind)]);
uMP = reshape(ucP,[boardsize-1 2 sum(Ind)]);
images = find(Ind);
for i=1:2%size(cPointsCO,3)
    figure(900+i),imagesc(imread(I{images(i),1})); 
    hold on, plot(cP(:,1,i),cP(:,2,i),'*b');
    
    for k=1:size(m,1)
    dx = linspace(MP(1,k,1,i),MP(end,k,1,i),100);
    hold on, plot(dx,m(k,i)*dx+b(k,i),'k')
    hold on, plot(MP(:,k,1,i),MP(:,k,2,i),'y')
    end
    %hold on, plot([MP(1,1,1,i),MP(end,1,1,i)],[MP(1,1,2,i) MP(end,1,2,i)],'y')
    
    figure(800+i),imagesc(undistortImage(imread(I{images(i),1}),CP)); 
    hold on, plot(ucP(:,1,i),ucP(:,2,i),'*r');
    
    for k=1:size(um,1)
    dx = linspace(uMP(1,k,1,i),uMP(end,k,1,i),100);
    hold on, plot(dx,um(k,i)*dx+ub(k,i),'k')
    hold on, plot(uMP(:,k,1,i),uMP(:,k,2,i),'y')
    end
end


%% Calculo de lineas paralelas verticales para puntos con distorsión y compensados
m = (MP(end,:,2,:)-MP(1,:,2,:))./(MP(end,:,1,:)-MP(1,:,1,:));
b = MP(1,:,2,:)- MP(1,:,1,:).*m;
b = reshape(b,[size(m,2),size(m,4)]);
m = reshape(m,[size(m,2),size(m,4)]);

um = (uMP(end,:,2,:)-uMP(1,:,2,:))./(uMP(end,:,1,:)-uMP(1,:,1,:));
ub = uMP(1,:,2,:)- uMP(1,:,1,:).*um;
ub = reshape(ub,[size(um,2),size(um,4)]);
um = reshape(um,[size(um,2),size(um,4)]);
%% Calculo de distancias entre las rectas y los datos
talla = size(MP);
Xmn = reshape(MP(:,:,1,:),talla([1 2 4]));
Ymn = reshape(MP(:,:,2,:),talla([1 2 4]));
m_ = repmat(reshape(m,[1,size(m)]),[15,1,1]);
b_ = repmat(reshape(b,[1,size(b)]),[15,1,1]);
bc = Ymn+Xmn./m_;
X_mn = (bc-b_).*m_./(m_.^2+1);
Y_mn = m_.*X_mn+b_;
dmn = sqrt((Xmn-X_mn).^2+(Ymn-Y_mn).^2);
%% Calculo de distancias entre las rectas y los datos compensados
talla = size(uMP);
Xmn = reshape(uMP(:,:,1,:),talla([1 2 4]));
Ymn = reshape(uMP(:,:,2,:),talla([1 2 4]));
m_ = repmat(reshape(um,[1,size(um)]),[15,1,1]);
b_ = repmat(reshape(ub,[1,size(ub)]),[15,1,1]);
bc = Ymn+Xmn./m_;
X_mn = (bc-b_).*m_./(m_.^2+1);
Y_mn = m_.*X_mn+b_;
udmn = sqrt((Xmn-X_mn).^2+(Ymn-Y_mn).^2);
%%
rg = 'rgbkymcrgbkymcrgbkymc';
for k = 1:size(dmn,3)
    figure(105), hold on
    plot(mean(dmn(:,:,k),1),rg(k))
    
    figure(106), hold on
    plot(max(dmn(:,:,k)),rg(k))
    
    figure(103), hold on
    plot(mean(udmn(:,:,k),1),rg(k))
    
    figure(104), hold on
    plot(max(udmn(:,:,k)),rg(k))
end




