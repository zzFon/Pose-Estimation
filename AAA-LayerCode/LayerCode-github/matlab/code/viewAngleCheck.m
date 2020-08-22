


function [] = viewAngleCheck( obj_basename )

    logFileName = sprintf('%s/statLog.txt', obj_basename );
    fileID = fopen(logFileName,'a');%打开log
    picturesName = sprintf('%s/*.png', obj_basename );
    files = dir(picturesName);%获取文件夹下所有.png
    %finishedFolderName = sprintf('%s/finished_%s', obj_basename, obj_basename );
    finishedFolderName = sprintf('%s/finished', obj_basename);%计算的输出路径
    fprintf('输出路径 %s\n',finishedFolderName);
    if ~exist(finishedFolderName, 'dir')%输出路径不存在 新建
        % Folder does not exist so create it.
        %mkdir('./1pp')
        %finishedFolderName
        %fileID
        mkdir(finishedFolderName);
    end  
    
    for file = files' %遍历文件
        currPic = sprintf('%s/%s', obj_basename, file.name);%当前文件名
        fprintf('\n正在处理 %s\n',currPic);
        tic;
        if runningVote( currPic, 1 ) %主函数，使用filter
            %fprintf(fileID,'%s %d\n',file.name, 1 );
            toc;
            fprintf('%s %s\n',file.name, 'successful' );
            fprintf(fileID,'%s %s\n',file.name, 'successful' );%写入log
        else
            %fprintf(fileID,'%s %d\n',file.name, 0 );
            toc;
            fprintf('%s %s\n',file.name, 'failed' );
            fprintf(fileID,'%s %s\n',file.name, 'failed' );%写入log
        end
        %movefile( currPic, finishedFolderName );%计算结束，png送到输出目录
        break;%先搞1个图
    end
    fclose(fileID);%关闭log
%     exit(0);
end
