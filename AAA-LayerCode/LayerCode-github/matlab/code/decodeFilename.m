%useful for assessing accuracy, given files are formated as 
% decimal_base_code_viewpoint.png
function correctEncoding = decodeFilename( filename )
    [~, name, ~] = fileparts(filename);%�ļ������[path,name,extention]
    splits = strsplit(name, '_');%�ָ�str �����»���
    decimalStr = splits(1);
    decimalNum = str2double(decimalStr);%�ļ���ת������
    correctEncoding = de2bi(decimalNum,'left-msb');%�ļ���תΪ������MSB...LSB
end

