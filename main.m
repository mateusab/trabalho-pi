% Integrantes
% Nome 1: Diego, RA
% Nome 2: Mateus de Abreu Antunes, RA 612618

% Limpando a área de trabalho
clear all
close all
clc

% Carregando a imagem
I = imread('img1.jpg');

% Transforma a imagem em preto e branco
level = graythresh(I); %define um nível de cinza melhor de acordo com a imagem
bw = (im2bw(I, level));
figure, imshow(bw);
