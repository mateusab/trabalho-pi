% Integrantes
% Nome 1: Diego Tenório de Araújo, RA 552143
% Nome 2: Mateus de Abreu Antunes, RA 612618

% Implementado no MATLAB

% Limpando a área de trabalho
clear all
close all
clc

% % Carregando a imagem
I = imread('img1.jpg');

gray_image = rgb2gray(I);
imshow(gray_image);

level = graythresh(I);
bw = (im2bw(I, level));
preenchida = imfill(bw,'holes');
figure, imshow(preenchida);

[centers,radii] = imfindcircles(I,[60 100], 'ObjectPolarity','bright','Sensitivity',0.92);
bola_perim = viscircles(centers, radii,'Color','r');

xc = centers(1);
yc = centers(2);
r = radii;

x = 1:size(I,2);
y = 1:size(I,1);
[xx,yy] = meshgrid(x,y);

mask = hypot(xx - xc, yy - yc) <= r;

imshow(mask)
title('Mask image')

