function [labeled, nred, nblue] = labelRBPix( filename, withFilter )

[RGB,~,AlphaChannel] = imread(filename);%读取图片RGB
%[RGB图像张量,~,透明度通道]

%% HSV picker
[r, b] = rbSegmentRGB( RGB );%按预定HSV阈值将图像二值化，分别存于r和b

%% Label reliable pixels

% shrink borders to avoid flood leaks
mask = imerode(AlphaChannel,strel('square',7));%腐蚀 %形态学算子
mask(mask~= 255) = 0;

% Remove shaded pixels
if withFilter
    dofMask = depthOfFieldMask(RGB);%按预定RGB阈值进行滤波+形态学运算+滤除小连通域得到dofMask
else
    dofMask = zeros(size(AlphaChannel));
end
% fim(dofMask);
[~, name, ~] = fileparts(filename);
figure;imshow(RGB);title('RGB');imwrite(RGB,strcat('E:\Git-Repository\Pose-Estimation\AAA-LayerCode\LayerCode-github\matlab\sample-input-images\successful\filtered\',name,'_RGB.png'));
figure;imshow(dofMask);title('dofMask');imwrite(dofMask,strcat('E:\Git-Repository\Pose-Estimation\AAA-LayerCode\LayerCode-github\matlab\sample-input-images\successful\filtered\',name,'_dofMask.png'));
figure;imshow(mask);title('mask');imwrite(mask,strcat('E:\Git-Repository\Pose-Estimation\AAA-LayerCode\LayerCode-github\matlab\sample-input-images\successful\filtered\',name,'_mask.png'));

% Remove tiny regions
minNumPix = floor(size(AlphaChannel,1) / 20);%连通域最小面积
conn = 4;
cleanedR = bwareaopen(r, minNumPix, conn);%去除r中所有面积小于minNumPix连通域
cleanedB = bwareaopen(b, minNumPix, conn);%去除r中所有面积小于minNumPix连通域

cleanedR = cleanedR & ~cleanedB & mask & ~dofMask;
cleanedB = cleanedB & ~cleanedR & mask & ~dofMask;

cleanedR = bwareaopen(cleanedR, minNumPix, conn);%去除所有面积小于minNumPix连通域
cleanedB = bwareaopen(cleanedB, minNumPix, conn);

figure;imshow(cleanedR);title('cleanedR');imwrite(cleanedR,strcat('E:\Git-Repository\Pose-Estimation\AAA-LayerCode\LayerCode-github\matlab\sample-input-images\successful\filtered\',name,'_cleanedR.png'));
figure;imshow(cleanedB);title('cleanedB');imwrite(cleanedB,strcat('E:\Git-Repository\Pose-Estimation\AAA-LayerCode\LayerCode-github\matlab\sample-input-images\successful\filtered\',name,'_cleanedB.png'));

% Label colors with unique indices
%[标记连通性后的图片，连通块数目]
[rlabel, nred] = bwlabel( cleanedR, conn );%标注连通域R 1 2 3...
[blabel, nblue] = bwlabel( cleanedB, conn );%标注连通域B 1 2 3...
tmp = (blabel == 0);
blabel = blabel + nred;%分开R和B的连通域序号 R:1 2 3...nred B:nred+1 nred+2 ... nred+nblue
blabel(tmp) = 0;
labeled = blabel + rlabel;%全部连通块

end

