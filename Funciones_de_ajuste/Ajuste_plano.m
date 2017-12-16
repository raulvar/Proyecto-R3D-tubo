function e = Ajuste_plano(XX,mask)
    e=zeros(size(XX(:,:,:,1)));
    if(nargin<2)
        mask=1;
    end
    figure(80),hold off
    for i=1:size(XX,3)
        if(mask==1)
            Ind = find(~isnan(XX(:,:,i,1)));
        else
            Ind = find(~isnan(XX(:,:,i,1).*mask(:,:,i)));
        end
        x = XX(:,:,i,1);
        y = XX(:,:,i,2);
        z = XX(:,:,i,3);
        A= [x(Ind),y(Ind),ones(size(x(Ind)))];
        AA = A'*A;
        B = A'*z(Ind);
        TT = AA\B;
        ze = (TT(1)*x+TT(2)*y+TT(3));
        ze2 = (TT(1)*x+TT(3));
        e(:,:,i)=z-ze;
        figure(80), plot(x(:),ze2(:),'LineWidth',1),hold on
    end
    plot(-30:230,-48.0*ones(size(-30:230)),'k','LineWidth',1)
    plot(-30:230, 46.4*ones(size(-30:230)),'k','LineWidth',1)
end