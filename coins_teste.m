clear all
close all
clc

I = imread('coins.jpg');
figure, imshow(I);

xc = 175;
yc = 120;
r = 33;

x = 1:size(I,2);
y = 1:size(I,1);
[xx,yy] = meshgrid(x,y);

mask = hypot(xx - xc, yy - yc) <= r;

imshow(mask)
title('Mask image')