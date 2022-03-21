clear;
clc;
close all;

im1 = imread('p1.jpg');
im2 = imread('p2.jpg');

I1 = rgb2gray(im1);
I2 = rgb2gray(im2);
%% detect the features
points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

%% extract the features
[f1,vpts1] = extractFeatures(I1,points1);
[f2,vpts2] = extractFeatures(I2,points2);

%% mathch the features
indexPairs = matchFeatures(f1,f2);
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

%% find the projective matrix
tform = fitgeotrans(matchedPoints1.Location,matchedPoints2.Location,'projective');

%% project the image
im1_trans = imwarp(im1,tform);

% find the border of transformed image
left_top = round(transformPointsForward(tform,[1 1]));
right_top = round(transformPointsForward(tform,[size(im2,2) 1]));
left_bottom = round(transformPointsForward(tform,[1 size(im2,1)]));
right_bottom = round(transformPointsForward(tform,[size(im2,2) size(im2,1)]));

%% image stitching
im1_trans_seg = [zeros(size(im1_trans,1)+right_top(2),min(left_top(1),left_bottom(1)),3) im1_trans(-right_top(2)+1:end,:,:)]; % if right_top(2) < 0
im = im1_trans_seg(1:size(im2,1),:,:);
im(:,1:size(im2,2),:) = im2;
im1_trans_seg_gray = rgb2gray(im1_trans_seg);

%% image optimization
edge_left = min(left_top(1),left_bottom(1));
edge_right = size(im2,2);
edge_width = edge_right-edge_left;

for row=1:size(im,1)
    for col=edge_left:edge_right
        if im1_trans_seg_gray(row,col) == 0
            weight = 1;
        else
            weight = (edge_width - (col - edge_left)) / edge_width;
        end
        
        im(row,col,:) = uint8(double(im2(row,col,:))*weight + double(im1_trans_seg(row,col,:))*(1-weight));
    end
end

%% lets see
figure
im_handle = imshow(im);
figure
imshow(im2);

%% save it
saveas(im_handle,'stitched_image.jpg');