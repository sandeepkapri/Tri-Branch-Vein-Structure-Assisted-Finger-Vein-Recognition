function trainTriBranch(handles)
set(handles.statusText, 'String', 'Training Started for Tri Branch Vein Structure.');
    drawnow;
    %folder Property Vector
    fv = dir(handles.fLoc);
    testSampleCount =  sum([fv(~ismember({fv.name},{'.','..'})).isdir]);
    imgLoc = handles.fLoc;
    for sk = 1:testSampleCount
        if sk < 10
            userName = ['00' num2str(sk)];
        elseif sk < 100  
            userName = ['0' num2str(sk)];
        else
            userName = num2str(sk);
        end
       
         for i = 1:4
            imgPath =  fullfile(imgLoc,userName,['left/index_' num2str(i) '.bmp']);
            image=im2double(rgb2gray(imread(imgPath)));
            triBranchMap(:,:,i) = tbMap(image);
         end
         
         countSSIM = 1;
         for i = 1:4
             for j = i:4
                 if i ~= j
                     ssimval(countSSIM) = ssim(triBranchMap(:,:,i),triBranchMap(:,:,j));
                     if countSSIM == 1
                        minSSIM  = ssimval(countSSIM);
                        imgIndex(1) = i;
                        imgIndex(2) = j;
                     end
                     if minSSIM > ssimval(countSSIM)
                        minSSIM  = ssimval(countSSIM);
                        imgIndex(1) = i;
                        imgIndex(2) = j; 
                     end
                     countSSIM = countSSIM + 1; 
                 end
             end
         end   
         userSpecificThreshold = minSSIM;
        pathstr = handles.codeDir;
        %Writing Enrolled Structure in a file
        imgW1 =  fullfile(pathstr,'enrolledstruct',[ userName '_1.bmp']);
        %imgW2 =  fullfile(pathstr,'enrolledstruct',[ userName '_2.bmp']);
        imwrite( triBranchMap(:,:,imgIndex(1)),imgW1);
        %imwrite( triBranchMap(:,:,imgIndex(2)),imgW2);
        %Writing User Specific threshold to database 
        fullFname = fullfile(pathstr,'database/dataTbVS.mat');
        if exist(fullFname, 'file')==0 
            DATA=[{userName}  {userSpecificThreshold}];
            save ( fullFname,'DATA');
        else
            load(fullFname);
            m=size(DATA,1);
            DATA{m+1,1}= userName;
            DATA{m+1,2}= userSpecificThreshold;
            save (fullFname,'DATA');
        end
        set(handles.statusText, 'String', ['Tri Branch training is in progress...  ' num2str(sk) ' out of ' num2str(testSampleCount) ' completed.']); 
        drawnow;
    end
end