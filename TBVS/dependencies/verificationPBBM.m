function verificationPBBM(probeimg,candidateVecArr,handles)
    pathstr = handles.codeDir;
    [~,fvr]=lee_region(probeimg,4,20);
    fullFname = fullfile(pathstr,'database/dataPBBM.mat');
    load(fullFname); 
    x=size(fvr,2);
    cVlen = size(candidateVecArr);
    ROI=imcrop(probeimg,[1 fvr(1,floor(x/2)) x-1 fvr(2,floor(x/2))-fvr(1,floor(x/2))]);
    ROI=imadjust(imresize(ROI,[64 96],'bilinear'));
    LBP_test=LBP(ROI);
    for sk = 1:cVlen(1)
        matchscore=zeros(cVlen(1),1);
        imgInd = str2num(candidateVecArr(sk,:));
        matchscore=PBBM_matching(DATA{imgInd,2},LBP_test);
        if(matchscore>=0.89)
            disp(['Genuine: ' ,DATA{imgInd,1},'   Score: ', num2str(matchscore)]);
        else
            disp([('Imposter: '), DATA{imgInd,1},'   Score: ', num2str(matchscore)]);
        end
    end
    
end