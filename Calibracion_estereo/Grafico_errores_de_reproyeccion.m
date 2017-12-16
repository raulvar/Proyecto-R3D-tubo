pec=stereoParams.CameraParameters1.ReprojectionErrors;
pep=stereoParams.CameraParameters2.ReprojectionErrors;
%%
pxc = pec(:,1,:);pyc = pec(:,2,:);
pxp = pep(:,1,:);pyp = pep(:,2,:);
color = 'rbgymcgkrbgcmk';
figure(80),hold on, xlabel('$$u_c$$','interpreter','Latex'), ylabel('$$v_c$$','interpreter','Latex')
figure(90),hold on, xlabel('$$u_p$$','interpreter','Latex'), ylabel('$$v_p$$','interpreter','Latex')
for i=1:13
figure(80), plot(pxc(:,:,i),pyc(:,:,i),['+',color(i)])
figure(90), plot(pxp(:,:,i),pyp(:,:,i),['+',color(i)])
end

figure(80)
xlim([-1 1])
ylim([-1 1])
set(gcf, 'color', 'white');
set(gca,'FontSize',16)
set(gcf,'PaperPositionMode','auto')
 print('Errores_repro_cam','-dpng','-r0')

figure(90)
xlim([-1 1])
ylim([-1 1])
set(gcf, 'color', 'white');
set(gca,'FontSize',16)
set(gcf,'PaperPositionMode','auto')
 print('Errores_repro_proj','-dpng','-r0')
