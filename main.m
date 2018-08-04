% Integrantes
% Nome 1: Diego Ten�rio de Ara�jo, RA 552143
% Nome 2: Mateus de Abreu Antunes, RA 612618

% Implementado no MATLAB

% Limpando a �rea de trabalho
clear all
close all
clc

% % Carregando a imagem
I = imread('img1.jpg');

% BINARIZA��O
% Binariza a imagem para ser usada mais pra frente e tenta preencher alguns
% holes
level = graythresh(I);
bw = (im2bw(I, level));
preenchida = imfill(bw,'holes');
figure, imshow(preenchida);

% IMFINDCIRCLES
% Essa fun��o ir� retornar o raio e o centro (x,y) do c�rculo encontrado
% Optamos por circulos claros, pois a bola � branca e o raio entre 60 e 100
[centers,radii] = imfindcircles(I,[60 100], 'ObjectPolarity','bright','Sensitivity',0.92);
bola_perim = viscircles(centers, radii,'Color','r');

% CRIA��O DE M�SCARA
% Atribuimos os centros (x,y) respectivamente para as vari�veis xc e yc
xc = centers(1);
yc = centers(2);

% E o raio para a vari�vel r
r = radii;

% Dessa maneira podemos criar uma m�scara do c�rculo encontrado
x = 1:size(I,2);
y = 1:size(I,1);
[xx,yy] = meshgrid(x,y);

bola = hypot(xx - xc, yy - yc) <= r;
imshow(bola), title('M�scara da bola');

% ARITM�TICA DE IMAGENS
% bw_filled recebe uma soma da imagem inicial binarizada com a m�scara da
% bola
% Dessa maneira, teremos uma figura completa da bola e da linha do gol
% binarizadas
bw_filled = bw+bola;
figure, imshow(bw_filled);

% IMCROP
% Cropped image receber� o corte da imagem de maneira que todo o resto
% da imagem ser� eliminado e nos restar� apenas o que nos interessa
% Isso �, a linha e a m�scara da bola.
croppedImage = imcrop(bw_filled);
figure, imshow(croppedImage);

% Iremos rotular a imagem cortada com o bwlabel
rotulada = bwlabel(croppedImage);

% E contar quantas regioes foram obtidas
qtd_regioes = max(max(rotulada));



