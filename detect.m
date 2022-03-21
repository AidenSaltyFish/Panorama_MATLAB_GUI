im = rgb2gray(imread('p.jpg'));
points = detectSURFFeatures(im); % SURF features
% points = detectHarrisFeatures(im); % harris features

imshow(im); 
hold on;
title('SURF Features');
plot(points.selectStrongest(10));

% clc,clear;
% I = imread('cameraman.tif');
% 
% %% (1) detect BRISK
% points = detectBRISKFeatures(I);
%  %输入参数：
%  %'MinContrast' -最小强度差[0.2]:
%  %     角及其周围区域之间的最小强度差, 指定为由 "MinContrast" 和范围 (0 1) 中的标量组成的逗号分隔对。
%  %     最小对比度值表示图像类最大值的一小部分。增加此值以减少检测到的角的数量。
%  %'MinQuality' - -最低可接受的角质量[0.01]:
%  %     角的最小可接受质量, 指定为由 "MinQuality范围内的标量值组成的逗号分隔对 [0, 1]。
%  %     可接受的最小角质量表示图像中最大角度量值的一小部分。增加此值以删除错误的角。
%  %'NumOctaves' -八度数[4]:
%  %     要实现的八度字节数, 指定为由 "NumOctaves" 和整数标量组成的逗号分隔对, 大于或等于0。增加此值以检测较大的 blobs。建议的值介于1和4之间。
%  %     将NumOctaves设置为0, 该函数将禁用多尺度检测。它以输入图像的比例执行检测,
%  %'ROI' -矩形区域
% figure(1),imshow(I); hold on;title('BRISK Features');
% plot(points.selectStrongest(20));
% 
% %% (2) detect MSER
% regions = detectMSERFeatures(I);
% %输入参数：
% %'ThresholdDelta'阈值级别之间的步长[2]:
% %    强度阈值级别之间的步长, 指定为由 "ThresholdDelta" 组成的逗号分隔对和范围 (0, 100] 中的数值。
% %    此值表示为在测试极值区域的稳定性时用于选择极值区域时所使用的输入数据类型范围的百分比。
% %    减小此值以返回更多区域。典型值范围为0.8 到4。
% %'RegionAreaRange' -区域的大小[30 14000]:
% %    区域的大小 (以像素为单位), 指定为由 "RegionAreaRange" 和两个元素向量组成的逗号分隔对。
% %    矢量 [minArea 最大面积]允许选择包含像素的区域在minArea和最大面积之间, 包括在内。
% %'MaxAreaVariation' -极值区域之间的最大面积变化[0.25]:
% %    在不同强度阈值下, 极值区域之间的最大面积变化, 指定为由 "MaxAreaVariation和正标量值组成的逗号分隔对。
% %    增加此值将返回更多的区域, 但它们可能不太稳定。稳定的区域在不同强度阈值上的大小非常相似。典型值范围为0.1 到1.0。
% %'ROI' -感兴趣的矩形区域
% figure(2);subplot(211),imshow(I); hold on;title('MSER Features');
% plot(regions,'showPixelList',true,'showEllipses',false);
% subplot(212) ,imshow(I); hold on;plot(regions);
% 
% %% (3) detect FAST Features
% corners = detectFASTFeatures(I);
% %输入参数：
% %'MinQuality' - -最低可接受的角质量[0.1]:
% %    角的最小可接受质量, 指定为由 "MinQuality范围内的标量值组成的逗号分隔对 [0, 1]。
% %    可接受的最小角质量表示图像中最大角度量值的一小部分。较大的值可用于删除错误的边角。
% %'MinContrast' -最小强度[0.2]:
% %    角和周围区域之间的最小强度差, 指定为由 "MinContrast" 和范围 (0, 1) 中的标量值组成的逗号分隔对。
% %    最小强度表示图像类最大值的一小部分。增加该值可减少检测到的角的数量。
% %'ROI' -矩形区域
% figure(3),imshow(I); hold on;title('FAST Features');plot(corners.selectStrongest(50));
% 
% %% (4) detect Harris Features
% corners = detectHarrisFeatures(I);
% %输入参数：
% %'MinQuality' - -最低可接受的角质量[0.01]:
% %    角的最小可接受质量, 指定为由 "MinQuality范围内的标量值组成的逗号分隔对 [0, 1]。
% %    可接受的最小角质量表示图像中最大角度量值的一小部分。较大的值可用于删除错误的边角。
% %'FilterSize' -高斯滤波器尺寸[5]:
% %    高斯滤波器尺寸, 指定为由 "FilterSize" 和范围内的奇数整数值组成的逗号分隔对 [3, min(I (size))].
% %    高斯滤光片平滑输入图像的渐变。
% %    该函数使用FilterSize值计算筛选器的尺寸,FilterSize"FilterSize。它还将高斯滤波器的标准偏差定义为FilterSize。
% %'ROI' -矩形区域
% figure(4),imshow(I); hold on;title('Harris Features');plot(corners.selectStrongest(50));
% 
% %% (5) detect SURF Features
% points = detectSURFFeatures(I);
% %%输入参数：
% %'MetricThreshold' -最强的功能阈值[1000]:
% %    最强的特征阈值, 指定为由 "MetricThreshold" 和非负标量组成的逗号分隔对。若要返回更多 blobs, 请减小此阈值的值。
% %'NumOctaves' -八度数[3]:
% %    要实现的八度字节数, 指定为由 "NumOctaves" 和整数标量组成的逗号分隔对, 大于或等于1。增加此值以检测较大的 blobs。建议的值介于1和4之间.
% %    每个八度都跨越多个比例, 使用不同大小的过滤器进行分析:
% %    |  Octave  |  Filter sizes  
% %    |    1     |  9-by-9, 15-by-15, 21-by-21, 27-by-27, ...
% %    |    2     |  15-by-15, 27-by-27, 39-by-39, 51-by-51, ...
% %    |    3     |  27-by-27, 51-by-51, 75-by-75, 99-by-99, ...
% %    |    4     |  ...
% %'NumScaleLevels' -每个八度的刻度级别数[4]:
% %    要计算的每个八度刻度级别数, 指定为由 "NumScaleLevels" 和整数标量组成的逗号分隔对, 大于或等于3。
% %    增加此数字, 以检测更多的 blobs 在更精细的规模增量。建议的值介于3和6之间.
% %'ROI' -感兴趣的矩形区域
% figure(5),imshow(I); hold on;title('SURF Features');plot(points.selectStrongest(10));
% 
% %% (6)detect MinEigen Features
% corners = detectMinEigenFeatures(I);
% %输入参数：
% %'MinQuality' - -最低可接受的角质量[0.01]:
% %    角的最小可接受质量, 指定为由 "MinQuality范围内的标量值组成的逗号分隔对 [0, 1]。
% %    可接受的最小角质量表示图像中最大角度量值的一小部分。较大的值可用于删除错误的边角。
% %'FilterSize' -高斯滤波器尺寸[5]:
% %    高斯滤波器维度, 指定为由 "FilterSize" 和范围 [3, inf) 中的奇数整数值组成的逗号分隔对。
% %    高斯滤光片平滑输入图像的渐变。
% %    该函数使用FilterSize值计算筛选器的尺寸,FilterSize"FilterSize。它还将标准偏差定义为FilterSize/3。
% %'FilterSize' -高斯滤波器尺寸
% figure(6);imshow(I); hold on;title('MinEigen Features');plot(corners.selectStrongest(50));