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
figure, imshow(I), title('Imagem original');

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
[centers,radii] = imfindcircles(I,[60 100], 'ObjectPolarity','bright','Sensitivity',0.96);
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

% Caso tenha duas regioes apenas, � o caso mais f�cil, iremos analisar se a
% bola est� acima ou abaixo da linha do gol, atrav�s do c�lculo da
% circularidade

if (qtd_regioes == 2)
%     fprintf('duas regioes');
    dados = regionprops(croppedImage,'Area','Centroid','Perimeter','PixelList');
    tam_fonte = 12;
    circularidade = 1:2;
    [B,L] = bwboundaries(croppedImage,'noholes');
    figure, imshow(croppedImage), title('');
    hold on
    for k = 1 : qtd_regioes
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
        circularidade(k) = (4*3.14*(dados(k).Area))/((dados(k).Perimeter)^2);
        pos_Centroid = dados(k).Centroid;
        text(pos_Centroid(1), pos_Centroid(2), num2str(circularidade(k)), 'FontSize', tam_fonte, 'FontWeight', 'Bold','Color', 'Red');
    end
    
% Notamos que o .Centroid(2) de quem est� por cima � menor do que o quem
% est� por baixo, portanto, usaremos isso para ver se a maior circularidade
% (da bola) est� acima ou abaixo da linha do gol

    if (dados(1).Centroid(2) > dados(2).Centroid(2))
        objeto_por_cima = circularidade(2);
        objeto_por_baixo = circularidade(1);
    else
        objeto_por_cima = circularidade(1);
        objeto_por_baixo = circularidade(2);
    end
    
    if (objeto_por_cima > objeto_por_baixo)
        msg = msgbox('GOL V�LIDO!');
    else
        msg = msgbox('GOL N�O V�LIDO!');
    end
end

% No caso de possuir apenas uma regi�o, temos mais duas deriva��es
% O primeiro caso, onde a bola est� minimamente em cima da linha e pode ser gol ainda
% O segundo caso onde a bola est� muito em cima da linha e realmente n�o
% foi gol

% Portanto, se tiver apenas uma regi�o, iremos aplicar uma eros�o em cima
% da imagem para ver se conseguimos separar a bola da linha
if (qtd_regioes == 1)
%     fprintf('Possui apenas uma regi�o!');
    se = strel('sphere',10);
    img_erodida = imerode(croppedImage,se);
    figure, imshow(img_erodida), title('Imagem com eros�o aplicada');
    tam_fonte = 12;
    img_erodida = imfill(img_erodida,'holes');
    figure, imshow(img_erodida), title('Imagem erodida com imfill');
    rotulada_erodida = bwlabel(img_erodida);
    qtd_regioes_atual = max(max(rotulada_erodida));
    
% Ap�s a eros�o iremos analisar novamente a quantidade de regi�es da
% imagem, se for um, significa que n�o foi gol, pois a bola n�o se
% separou da linha

    if (qtd_regioes_atual == 1)
            msg = msgbox('GOL N�O V�LIDO!');
     else if (qtd_regioes_atual == 2)
% Se for dois, significa que a bola se separou da linha, mas
% novamente precisamos analisar a circularidade dos objetos
% fprintf('ENTROU, 2 REGIOES');
            dados = regionprops(img_erodida,'Area','Centroid','Perimeter','PixelList');
            [B,L] = bwboundaries(img_erodida,'noholes');
            circularidade = 1:2;
            figure, imshow(img_erodida), title('');
            hold on
            for k = 1 : qtd_regioes_atual
                boundary = B{k};
                plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
                circularidade(k) = (4*3.14*(dados(k).Area))/((dados(k).Perimeter)^2);
                pos_Centroid = dados(k).Centroid;
                text(pos_Centroid(1), pos_Centroid(2), num2str(k), 'FontSize', tam_fonte, 'FontWeight', 'Bold','Color', 'Red');
            end
           
            if (dados(1).Centroid(2) > dados(2).Centroid(2))
                objeto_por_cima = circularidade(2);
                objeto_por_baixo = circularidade(1);
            else
                objeto_por_cima = circularidade(1);
                objeto_por_baixo = circularidade(2);
            end
    
            if (objeto_por_cima > objeto_por_baixo)
                msg = msgbox('GOL V�LIDO!');
            else
                msg = msgbox('GOL N�O V�LIDO!');
            end
         end
     end
end
