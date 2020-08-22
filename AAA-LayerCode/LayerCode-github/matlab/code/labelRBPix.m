function [labeled, nred, nblue] = labelRBPix( filename, withFilter )

[RGB,~,AlphaChannel] = imread(filename);%��ȡͼƬRGB
%[RGBͼ������,~,͸����ͨ��]

%% HSV picker
[r, b] = rbSegmentRGB( RGB );%��Ԥ��HSV��ֵ��ͼ���ֵ�����ֱ����r��b

%% Label reliable pixels

% shrink borders to avoid flood leaks
mask = imerode(AlphaChannel,strel('square',7));%��ʴ %��̬ѧ����
mask(mask~= 255) = 0;

% Remove shaded pixels
if withFilter
    dofMask = depthOfFieldMask(RGB);%��Ԥ��RGB��ֵ�����˲�+��̬ѧ����+�˳�С��ͨ��õ�dofMask
else
    dofMask = zeros(size(AlphaChannel));
end
% fim(dofMask);
[~, name, ~] = fileparts(filename);
figure;imshow(RGB);title('RGB');imwrite(RGB,strcat('E:\Git-Repository\Pose-Estimation\AAA-LayerCode\LayerCode-github\matlab\sample-input-images\successful\filtered\',name,'_RGB.png'));
figure;imshow(dofMask);title('dofMask');imwrite(dofMask,strcat('E:\Git-Repository\Pose-Estimation\AAA-LayerCode\LayerCode-github\matlab\sample-input-images\successful\filtered\',name,'_dofMask.png'));
figure;imshow(mask);title('mask');imwrite(mask,strcat('E:\Git-Repository\Pose-Estimation\AAA-LayerCode\LayerCode-github\matlab\sample-input-images\successful\filtered\',name,'_mask.png'));

% Remove tiny regions
minNumPix = floor(size(AlphaChannel,1) / 20);%��ͨ����С���
conn = 4;
cleanedR = bwareaopen(r, minNumPix, conn);%ȥ��r���������С��minNumPix��ͨ��
cleanedB = bwareaopen(b, minNumPix, conn);%ȥ��r���������С��minNumPix��ͨ��

cleanedR = cleanedR & ~cleanedB & mask & ~dofMask;
cleanedB = cleanedB & ~cleanedR & mask & ~dofMask;

cleanedR = bwareaopen(cleanedR, minNumPix, conn);%ȥ���������С��minNumPix��ͨ��
cleanedB = bwareaopen(cleanedB, minNumPix, conn);

figure;imshow(cleanedR);title('cleanedR');imwrite(cleanedR,strcat('E:\Git-Repository\Pose-Estimation\AAA-LayerCode\LayerCode-github\matlab\sample-input-images\successful\filtered\',name,'_cleanedR.png'));
figure;imshow(cleanedB);title('cleanedB');imwrite(cleanedB,strcat('E:\Git-Repository\Pose-Estimation\AAA-LayerCode\LayerCode-github\matlab\sample-input-images\successful\filtered\',name,'_cleanedB.png'));

% Label colors with unique indices
%[�����ͨ�Ժ��ͼƬ����ͨ����Ŀ]
[rlabel, nred] = bwlabel( cleanedR, conn );%��ע��ͨ��R 1 2 3...
[blabel, nblue] = bwlabel( cleanedB, conn );%��ע��ͨ��B 1 2 3...
tmp = (blabel == 0);
blabel = blabel + nred;%�ֿ�R��B����ͨ����� R:1 2 3...nred B:nred+1 nred+2 ... nred+nblue
blabel(tmp) = 0;
labeled = blabel + rlabel;%ȫ����ͨ��

end

