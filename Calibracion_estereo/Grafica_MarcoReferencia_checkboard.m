a=1; b=6;
figure, imshow(imread(I{a}),[]), colormap gray
hold on, plot(MP(:,:,1,a),MP(:,:,2,a),'ok','LineWidth',2)
hold on, plot(MP(:,:,1,a),MP(:,:,2,a),'xw','LineWidth',1.5)
n=40;


%annotation('arrow',[0.01 0.01],[0.1280 0.9],'Linewidth',3,'color','y')
%line([1 1],[1 300],'Linewidth',3,'color','b')
%line([1 300],[1 1],'Linewidth',3,'color','r')
axis off
m = (MP(1,1,2,a)-MP(1,1,2,n))/(MP(1,1,1,a)-MP(1,1,1,n));
f =  m*(290-MP(1,1,1,a))+MP(1,1,2,a);

%line([MP(1,1,1,a) MP(1,b,1,a)],[MP(1,1,2,a) MP(1,b,2,a)],'Linewidth',3,'color','r')
%line([MP(1,1,1,a) MP(b,1,1,a)],[MP(1,1,2,a) MP(b,1,2,a)],'Linewidth',3,'color','b')
%line([MP(1,1,1,a) 290], [MP(1,1,2,a)  f],'Linewidth',3,'color','g')

% text(MP(1,b,1,a),MP(1,b,2,a)-25   ,'$X^m$','Interpreter','Latex','color','k','FontSize',15,'FontWeight','Normal')
% text(MP(b,1,1,a)+10,MP(b,1,2,a)   ,'$Y^m$','Interpreter','Latex','color','k','FontSize',15,'FontWeight','Normal')
% text(MP(1,1,1,n)+10,MP(1,1,2,n)+20,'$Z^m$','Interpreter','Latex','color','k','FontSize',15,'FontWeight','Normal')

% text(MP(1,b,1,a),MP(1,b,2,a)-25   ,'$X^m$','Interpreter','Latex','color','y','FontSize',13,'FontWeight','Bold')
% text(MP(b,1,1,a)+10,MP(b,1,2,a)   ,'$Y^m$','Interpreter','Latex','color','r','FontSize',13,'FontWeight','Bold')
% text(290+10,f+20,'$Z^m$','Interpreter','Latex','color','g','FontSize',13,'FontWeight','Bold')
% xlim([30 1225.5])
% ylim([81.29 938.25])
%%

figure, imagesc(Nx(:,:,1)), colorbar, colormap gray
hold on, plot(MP(:,:,1,a),MP(:,:,2,a),'ok','LineWidth',2)
hold on, plot(MP(:,:,1,a),MP(:,:,2,a),'xw','LineWidth',1.5)
line([MP(1,1,1,a) MP(1,b,1,a)],[MP(1,1,2,a) MP(1,b,2,a)],'Linewidth',3,'color','y')
line([MP(1,1,1,a) MP(b,1,1,a)],[MP(1,1,2,a) MP(b,1,2,a)],'Linewidth',3,'color','r')
line([MP(1,1,1,a) 290], [MP(1,1,2,a)  f],'Linewidth',3,'color','g')
xlim([30 1225.5])
ylim([81.29 938.25])

figure, imagesc(Ny(:,:,1)), colorbar, colormap gray
hold on, plot(MP(:,:,1,a),MP(:,:,2,a),'ok','LineWidth',2)
hold on, plot(MP(:,:,1,a),MP(:,:,2,a),'xw','LineWidth',1.5)
line([MP(1,1,1,a) MP(1,b,1,a)],[MP(1,1,2,a) MP(1,b,2,a)],'Linewidth',3,'color','y')
line([MP(1,1,1,a) MP(b,1,1,a)],[MP(1,1,2,a) MP(b,1,2,a)],'Linewidth',3,'color','r')
line([MP(1,1,1,a) 290], [MP(1,1,2,a)  f],'Linewidth',3,'color','g')
xlim([30 1225.5])
ylim([81.29 938.25])



