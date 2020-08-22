%useful for assessing accuracy, given files are formated as 
% decimal_base_code_viewpoint.png
function correctEncoding = decodeFilename( filename )
    [~, name, ~] = fileparts(filename);%文件名拆分[path,name,extention]
    splits = strsplit(name, '_');%分割str 根据下划线
    decimalStr = splits(1);
    decimalNum = str2double(decimalStr);%文件名转成数字
    correctEncoding = de2bi(decimalNum,'left-msb');%文件名转为二进制MSB...LSB
end

