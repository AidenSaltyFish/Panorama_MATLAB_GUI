clear 
close all
clc

im1 = imread('p1.jpg'); % 读入图像1
im2 = imread('p2.jpg'); % 读入图像2

Bim1=rgb2gray(im1); %转化为灰度图像
Bim2=rgb2gray(im2); 

[H1 W1 k1]=size(Bim1);
[H2 W2 k2]=size(Bim2);


P1=imresize(Bim1,[H2,W2]); %重定义像素
P2=Bim2;

points1 = detectHarrisFeatures(P1);%Find the corners.
points2 = detectHarrisFeatures(P2);

[f1,vpts1] = extractFeatures(P1,points1);%Extract the neighborhood features.
[f2,vpts2] = extractFeatures(P2,points2);

figure(1);
imshow(P1); 
hold on;
title('Harris Features');
plot(points1.selectStrongest(500));
figure(2);
imshow(P2); 
hold on;
title('Harris Features');
plot(points1.selectStrongest(500));
    
indexPairs = matchFeatures(f1,f2);%Match the features.  
% matcFeatures returns indices of the matching features in the two input feature sets. The input feature must be either binaryFeatures objects or matrices.

matchedPoints1 = vpts1(indexPairs(:,1));%Retrieve the locations of the corresponding points for each image.
matchedPoints2 = vpts2(indexPairs(:,2));

%des1=matchedPoints1,matchedPoints2];1,des2]
   
%des1=[des1(:,2),des1(:,1)];%左右（x和y）交换 为基础矩阵F 过滤匹配准备参数
%des2=[des2(:,2),des2(:,1)];%

figure(3); 
showMatchedFeatures(P1,P2,matchedPoints1,matchedPoints2);
legend('matched points 1','matched points 2');

tform = fitgeotrans(matchedPoints1.Location,matchedPoints2.Location,'projective');% takes the pairs of control points, movingPoints and fixedPoints, and uses them to infer the geometric transformation, specified by transformationType.
%B = imwarp(A,tform) transforms the image A according to the geometric transformation defined by tform, which is a geometric transformation object. B is the transformed image.

  %重定义像素
im1_trans = imwarp(Bim1,tform);
[H1trans W1trans k1trans]=size(im1_trans);
im1_trans=imresize(im1_trans,[H2,W2]);
%P2=imresize(P2,[H1trans W1trans]);

figure(4)
imshow(im1_trans);

des1_matrix=matchedPoints1.Location(1,:);
des2_matrix=matchedPoints2.Location(1,:);
des1=des1_matrix(1,1);
des2=des2_matrix(1,1);


[H,W,k]=size(P2);%图像大小
Overlap=W-des1+des2;%只取水平方向（第一个匹配点）重叠宽度
%直接拼接图

im=[im1_trans(:,1:round(des1),:),P2(:,round(des2):W,:)];%1全图+2的后面部分
figure(5);
imshow(im);title('直接拼接图');