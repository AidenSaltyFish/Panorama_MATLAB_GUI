clear;
clc;
close all;

im1 = imread('p1.jpg');
im2 = imread('p2.jpg');

I1 = rgb2gray(im1);
I2 = rgb2gray(im2);

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[f1,vpts1] = extractFeatures(I1,points1);
[f2,vpts2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(f1,f2);
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

tform = fitgeotrans(matchedPoints1.Location,matchedPoints2.Location,'projective');

im1_trans = imwarp(im1,tform);
left_top = round(transformPointsForward(tform,[1 1]));
right_top = round(transformPointsForward(tform,[size(im2,2) 1]));
left_bottom = round(transformPointsForward(tform,[1 size(im2,1)]));
right_bottom = round(transformPointsForward(tform,[size(im2,2) size(im2,1)]));

im1_trans_seg = [zeros(size(im1_trans,1)+right_top(2),min(left_top(1),left_bottom(1)),3) im1_trans(-right_top(2)+1:end,:,:)]; % if right_top(2) < 0
im = im1_trans_seg(1:size(im2,1),:,:);
im(:,1:size(im2,2),:) = im2;

figure
imshow(im);
figure
imshow(im2);