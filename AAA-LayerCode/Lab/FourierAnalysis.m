
clear all;
%切路径
path = 'E:\Git-Repository\Pose-Estimation\AAA-LayerCode\Lab';
userpath(path);
%读文件
%filename = 'test.PNG';
filename = 'standard2.PNG';
%filename = 'LayerCode_1a.PNG';
%filename = 'LayerCode_1a_region.PNG';
%img = imread(filename);
img = [];
n = 400;
for i = 1:n
    for j = 1:n
        img(i,j) = sin(8*(i/(n)*2*pi));
    end
end

%傅里叶变换
%gray = rgb2gray(img);%灰度图
gray = img;
f = fft2(gray);
f1 = log(abs(f)+1);%尺度变换后的傅里叶变换
fs = fftshift(f);
fs1 = log(abs(f)+1);%中心对准+尺度变换的傅里叶变换
%求峰值
peak = imregionalmax(fs1);
[value,order] = sort(fs1,'descend');

subplot(2,2,1);
imshow(gray,[]);
subplot(2,2,2);
imshow(f1,[]);
subplot(2,2,3);
imshow(fs1,[]);
subplot(2,2,4);
imshow(peak);

figure;
plot(fs1);

