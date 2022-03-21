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

imshow(im1_trans);

left_top = round(transformPointsForward(tform,[1 1]));
right_top = round(transformPointsForward(tform,[1 1024]));
left_bottom = round(transformPointsForward(tform,[768 1]));
right_bottom = round(transformPointsForward(tform,[768 1024]));