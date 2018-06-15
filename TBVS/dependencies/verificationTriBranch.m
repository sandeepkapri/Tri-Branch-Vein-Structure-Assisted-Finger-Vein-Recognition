function candidateVec = verificationTriBranch(probeimg,handles)
    probeTbMap = tbMap(probeimg);
    pathstr = handles.codeDir;
    %Reading stored Tri Branch vein structure (Enrolled Structure Map) 
    enrolledStructPath =  fullfile(pathstr, 'enrolledstruct/*.bmp');
    structDir = dir(enrolledStructPath);
    testFolderCount =  size(structDir,1);
    countCand = 2;
    candidateVec{1,1} = 'userName';
    candidateVec{1,2} = 'Similarity';
    candidateVec{1,3} = 'User Specific Threshold';
    %Reading Erolled Threshold Value 
    thrDatabase = fullfile(pathstr,'database/dataTbVS.mat');
    load(thrDatabase);
        
    for sk = 1:testFolderCount
        if sk < 10
            userName = ['00' num2str(sk)];
        elseif sk < 100  
            userName = ['0' num2str(sk)];
        else
            userName = num2str(sk);
        end
        enrolledImgpath = fullfile(pathstr,'enrolledstruct',[ userName '_1.bmp']);
        enrolledImg = im2double(imread(enrolledImgpath));
        
        %Similarity between Enrolled and Probe Image
        si = ssim(enrolledImg, probeTbMap);
        usThr = DATA{sk,2} ;
        
        %Implementing User Specific Threshold Algo.
        if si > usThr
            candidateVec{countCand,1} = userName;
            candidateVec{countCand,2} = num2str(si);
            candidateVec{countCand,3} = num2str(usThr);
            countCand = countCand + 1;
        end
        
    end
    if exist('candidateVec','var')
        candidateVec
    else
        disp('No Match');
    end
end