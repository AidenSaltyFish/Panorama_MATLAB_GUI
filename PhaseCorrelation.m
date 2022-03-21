
clear all
close all
im1=imread('p2.jpg');
im2=imread('p1.jpg');

Bim1=rgb2gray(im1);
Bim2=rgb2gray(im2);

edge1=edge(Bim1,'sobel');
edge2=edge(Bim2,'sobel');

figure(1)
subplot(2,1,1)
imshow(edge1);
subplot(2,1,2)
imshow(edge2);

Fim1=fft2(edge1);
Fim2=fft2(edge2);

PhaseCor=(Fim1.*conj(Fim2))./abs(Fim1.*conj(Fim2));
IPhaseCor=ifft2(PhaseCor);
figure(2)
plot(IPhaseCor);

[X Y]=find((IPhaseCor)==max(max(IPhaseCor)));

im_move=zeros(size(im1,1)+X,size(im1,2)+Y,size(im1,3));
M=size(im_move,1);
N=size(im_move,2);

% im2_move=im2;
% im2_move((size(im1,1))+1:size(im_move,1),(size(im1,2)+1):size(im_move,2),:)=0;
% % im2_move = imshow(im2);
% im2_move=move(im2_move,X,Y);
%
% figure(3)
% imshow(im2_move);

im1_move=im1;
im1_move((size(im1,1))+1:size(im_move,1),(size(im1,2)+1):size(im_move,2),:)=0;


figure(4)
imshow(im1_move);

X1=X;
X2=size(im1,2);
Y1=Y;
Y2=size(im1,1);

im=zeros(size(im_move));

for row=1:X1-1
    for col=1:N
        im(row,col,:)=im1_move(row,col,:);
    end
end
figure(5)
imshow(uint8(im));

for row=(768+1):M
    for col=1:N
        im(row,col,:)=im1_move(row,col,:);
    end
end
figure(6)
imshow(uint8(im));

%%%%%%%%%%%  above all: edited 2019.7.11 morning  %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  �� not edited yet  %%%%%%%%%%%%%%%%%%%

for row=OverlapLeftX:OverlapRightX
    for col=1:OverlapTopY-1;
        im(row,col,:)=im2_move(row,col,:);
    end
    for col=OverlapBottomY+1:N
        im(row,col,:)=im1_move(row,col,:);
    end
end

for row=OverlapRightX+1:M
    for col=1:OverlapTopY-1;
        im(row,col,:)=0;
    end
    for col=OverlapTopY:N
        im(row,col,:)=im1_move(row,col,:);
    end
end

for row=OverlapLeftX:OverlapRightX
    for col=OverlapTopY:OverlapBottomY
        dx=row-X;
        dy=col-Y;
        d=sqrt(dx^2+dy^2); %�루21,76���ľ���
        OverlapDiag=sqrt(OverlapX^2+OverlapY^2);
        weight =(OverlapDiag-d)/OverlapDiag;% weightԽС������ͼ2���½�Խ����ͼ2Ȩ��ԽС
        im(row,col,:) = uint8(double(im2_move(row,col,:))*weight + double(im1_move(row,col,:))*(1-weight));
    end
end

figure
imshow(im);




