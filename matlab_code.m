clc;
clear;
close all;

%% STEP 1 - Read MRI Image

I = imread('brainMRI.jpg');

if size(I,3)==3
    I = rgb2gray(I);
end

%% Display Original Image

figure;
imshow(I);
title('Step 1 - Original MRI Image');

%% STEP 2 - Noise Removal using Median Filter

I_med = medfilt2(I,[3 3]);

figure;
imshow(I_med);
title('Step 2 - Median Filtered Image');

%% STEP 3 - Contrast Enhancement

I_eq = histeq(I_med);

figure;
imshow(I_eq);
title('Step 3 - Histogram Equalized Image');

%% STEP 4 - Thresholding

level = graythresh(I_eq);

BW = imbinarize(I_eq,level);

figure;
imshow(BW);
title('Step 4 - Thresholded Image');

%% STEP 5 - Remove Small Objects

BW_clean = bwareaopen(BW,200);

figure;
imshow(BW_clean);
title('Step 5 - Small Objects Removed');

%% STEP 6 - Morphological Closing

se = strel('disk',5);

BW_close = imclose(BW_clean,se);

figure;
imshow(BW_close);
title('Step 6 - Morphological Closing');

%% STEP 7 - Fill Holes

BW_fill = imfill(BW_close,'holes');

figure;
imshow(BW_fill);
title('Step 7 - Hole Filling');

%% STEP 8 - Extract Largest Region

CC = bwconncomp(BW_fill);

numPixels = cellfun(@numel,CC.PixelIdxList);

[~,idx] = max(numPixels);

TumourMask = false(size(BW_fill));

TumourMask(CC.PixelIdxList{idx}) = true;

figure;
imshow(TumourMask);
title('Step 8 - Final Tumour Mask');

%% STEP 9 - Overlay Tumour Boundary

figure;
imshow(I);
hold on;
visboundaries(TumourMask,'Color','r','LineWidth',2);
title('Final Tumour Segmentation Result');

%% STEP 10 - Comparison

figure;

subplot(2,3,1)
imshow(I)
title('Original')

subplot(2,3,2)
imshow(I_med)
title('Median Filter')

subplot(2,3,3)
imshow(I_eq)
title('Enhanced')

subplot(2,3,4)
imshow(BW)
title('Threshold')

subplot(2,3,5)
imshow(TumourMask)
title('Tumour Mask')

subplot(2,3,6)
imshow(I)
hold on
visboundaries(TumourMask,'Color','r')
title('Final Result')
