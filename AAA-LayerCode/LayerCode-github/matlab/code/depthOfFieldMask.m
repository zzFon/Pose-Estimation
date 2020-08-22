
function [dofMask] = depthOfFieldMask(I)%I为RGB图像
%%%%% for a 2k image, to help deal with
%%%%% shadows/foreground-background/DepthOfField%
%%%%% made with our Database colors in mind, although
%%%%% highlights and shadows are filtered otherwise
%%%%% by rescaling the image and removing local outliers

channel1Min = 0.000;
channel1Max = 255.000;
channel2Min = 0.000;
channel2Max = 118.000;
channel3Min = 1.000;
channel3Max = 131.000;

sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
seLarge = strel('square', 4);%形态学算子
dofMask = imopen( BW, seLarge );%开运算(腐蚀-膨胀)

minNumPix = 200;
conn = 4;
dofMask = bwareaopen(dofMask, minNumPix, conn);%去除所有面积小于minNumPix连通域
dofMask = ~dofMask;%取反
dofMask = bwareaopen(dofMask, minNumPix, conn);
dofMask = ~dofMask;


end

