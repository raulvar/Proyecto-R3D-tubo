function erms2 = RMS(errores)
%%
% Calcula los errores RMS de un bloque de matrices mxnxp
% en dirección de p
e=errores;
ei = reshape(e,[size(e,1)*size(e,2) size(e,3)]);
erms2=zeros([1,size(ei,2)]);
for i=1:size(ei,2)
    in1 = ~isnan(ei(:,i));
    erms2(i) = sqrt(sum((ei(in1,i)-mean(ei(in1,i))).^2)/numel(ei(in1,i)));
end

end