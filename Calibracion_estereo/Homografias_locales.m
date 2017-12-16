function Pp = Homografias_locales(Pc,fx,fy)
%%
% Pc : Esquinas de la cuadricula en precisión subpixel
% fx : Coordenadas X de proyector (precision pixel-cam)
% fy : Coordenadas Y de proyector (precision pixel-cam)
% Pp : Correspondencia de Pc en el proyector con precision subpixel

Pp=zeros(size(Pc));
for j=1:size(Pc,3)
    ffx=fx(:,:,j);ffy=fy(:,:,j);
    %figure(900+j), imagesc(ffx)
    for i=1:size(Pc,1)
        P = round(Pc(i,:,j));                            % Redondeamos al pixel mas cercano
        X = repmat( P(1)+(-5:5)  ,[21 01]);
        Y = repmat((P(2)+(-5:5))',[01 21]);
        % hold on, plot(X(:),Y(:),'.b'),drawnow
        % [X,Y] = meshgrid(P(1)+(-10:10),P(2)+(-10:10)); % obtenemos una cuadricula de pixeles en varias direcciones
        ind = sub2ind(size(ffx),Y(:),X(:));             % Obtenemos el Index de  la cuadricula
        H=homography2d(makehomogeneous([X(:)'; Y(:)']),makehomogeneous([ffx(ind)';ffy(ind)']));
        Pb= H*makehomogeneous(Pc(i,:,j)');
        Pp(i,:,j) = (Pb(1:2)/Pb(3))';
    end
end

end