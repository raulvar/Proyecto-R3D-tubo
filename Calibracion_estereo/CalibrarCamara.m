function [cPoints,ucPoints,cameraParams,ucameraParams,I,Ind,boardSize] = CalibrarCamara(nomb,n_imagen,squareSize)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
I = Active_image(nomb,'.bmp',n_imagen);
%I1 = imread(I{1,1});
[cPoints,boardSize,Ind]  = detectCheckerboardPoints(I);
wPoints = generateCheckerboardPoints(boardSize, squareSize);
cameraParams = estimateCameraParameters(cPoints,wPoints,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true);
ucPoints = Compensar_Distorsion(cPoints,cameraParams);
ucameraParams= estimateCameraParameters(ucPoints,wPoints,'NumRadialDistortionCoefficients',2,'EstimateTangentialDistortion',true);
% fc = cameraParams.FocalLength;
% cc = cameraParams.PrincipalPoint;
% kc = [cameraParams.RadialDistortion cameraParams.TangentialDistortion];
% alpha_c = cameraParams.EstimateSkew;

end

