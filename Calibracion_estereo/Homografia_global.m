function Pp = Homografia_global(Pc,fx,fy,m)
%%
% Pc : Esquinas de la cuadricula en precisión subpixel
% fx : Coordenadas X de proyector (precision pixel-cam)
% fy : Coordenadas Y de proyector (precision pixel-cam)
% Pp : Correspondencia de Pc en el proyector con precision subpixel

Pp=zeros(size(Pc));
% [X,Y] = meshgrid(1:size(fx,2),1:size(fy,1));
% 
% for j=1:size(Pc,3)
%         ind = find(m(:,:,j));             % Obtenemos el Index de  la cuadricula
%         j;
%         %[Y,X]= ind2sub(size(fx),ind);
%         fxx=fx(:,:,j);fyy=fy(:,:,j);
%         H=homography2d(makehomogeneous([X(:)';Y(:)']),makehomogeneous([fxx(:)';fyy(:)']));
%         Pb= H*makehomogeneous(Pc(:,:,j)');
%         Pp(:,:,j) = (Pb(1:2,:)./Pb(3))';
% end

for i=1:size(fx,3)
    ind = find(m(:,:,i));  
    [uc,vc]=meshgrid(1:size(fx,2),1:size(fx,1));
    up=fx(:,:,i);
    vp=fy(:,:,i); 
    Hh(:,:,i) = homography2d([uc(ind)';vc(ind)';ones(size(up(ind)))'],[up(ind)';vp(ind)';ones(size(up(ind)))']);
    Xxpa = Hh(:,:,i)*[Pc(:,:,i)';ones(size(Pc(:,1,i)))'];
    Pp(:,:,i) = (Xxpa(1:2,:)./repmat((Xxpa(3,:)),[2 1]))';
end


end

