


function [] = viewAngleCheck( obj_basename )

    logFileName = sprintf('%s/statLog.txt', obj_basename );
    fileID = fopen(logFileName,'a');%��log
    picturesName = sprintf('%s/*.png', obj_basename );
    files = dir(picturesName);%��ȡ�ļ���������.png
    %finishedFolderName = sprintf('%s/finished_%s', obj_basename, obj_basename );
    finishedFolderName = sprintf('%s/finished', obj_basename);%��������·��
    fprintf('���·�� %s\n',finishedFolderName);
    if ~exist(finishedFolderName, 'dir')%���·�������� �½�
        % Folder does not exist so create it.
        %mkdir('./1pp')
        %finishedFolderName
        %fileID
        mkdir(finishedFolderName);
    end  
    
    for file = files' %�����ļ�
        currPic = sprintf('%s/%s', obj_basename, file.name);%��ǰ�ļ���
        fprintf('\n���ڴ��� %s\n',currPic);
        tic;
        if runningVote( currPic, 1 ) %��������ʹ��filter
            %fprintf(fileID,'%s %d\n',file.name, 1 );
            toc;
            fprintf('%s %s\n',file.name, 'successful' );
            fprintf(fileID,'%s %s\n',file.name, 'successful' );%д��log
        else
            %fprintf(fileID,'%s %d\n',file.name, 0 );
            toc;
            fprintf('%s %s\n',file.name, 'failed' );
            fprintf(fileID,'%s %s\n',file.name, 'failed' );%д��log
        end
        %movefile( currPic, finishedFolderName );%���������png�͵����Ŀ¼
        break;%�ȸ�1��ͼ
    end
    fclose(fileID);%�ر�log
%     exit(0);
end
