function trainingPBBM(handles)
 set(handles.statusText, 'String', 'Training Started for PBBM.');
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
            imgPath =  fullfile(imgLoc,userName,['/left/index_' num2str(i) '.bmp']);
            image=im2double(rgb2gray(imread(imgPath)));
            image=imresize(image,0.5);
            [~,edges1]=lee_region(image,4,20);
            x=size(edges1,2);
            ROI1=imcrop(image,[1 edges1(1,floor(x/2)) x-1 edges1(2,floor(x/2))-edges1(1,floor(x/2))]);
            ROI1=imadjust(imresize(ROI1,[64 96],'bilinear'));
            X{i}=ROI1;
            lbp{i}=LBP(ROI1);
         end
        PBBM=getPBBM(X{1},X{2},X{3},X{4},lbp{1},lbp{2},lbp{3},lbp{4});
         pathstr = handles.codeDir;
        fullFname = fullfile(pathstr,'database/dataPBBM.mat');
        if exist(fullFname, 'file')==0 
            DATA=[{userName}  {PBBM}];
            save ( fullFname,'DATA');
        else
            load(fullFname);
            m=size(DATA,1);
            DATA{m+1,1}= userName;
            DATA{m+1,2}= PBBM;
            save (fullFname,'DATA');
        end
        set(handles.statusText, 'String', ['PBBM Training is in progress...  ' num2str(sk) ' out of ' num2str(testSampleCount) ' completed.']); 
        drawnow;
    end
end