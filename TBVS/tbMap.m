function dotProd = tbMap(probeimg)
fvr = lee_region(probeimg,4,20);% Get finger region
% Extract veins using maximum curvature method
sigma = 3; % Parameter
v_max_curvature = miura_max_curvature(probeimg,fvr,sigma);

% Binarise the vein image
md = median(v_max_curvature(v_max_curvature>0));
v_max_curvature_bin = v_max_curvature > md;
% End of Segmentation & Extraction

%wvp = imbinarize(rgb2gray(imread('Capture.png')));
%wvp = wiener2(v_max_curvature_bin,[5 5]);
wvp = wiener2(v_max_curvature_bin);
%h = fspecial('gaussian',11,4);
h = fspecial('gaussian');
wvp = imfilter(wvp,h);


% Thinning of finger vein
thinnedImg = bwmorph(wvp,'thin',Inf);

% Denoising to remove burr from the image
E = bwmorph(thinnedImg, 'endpoints');
[y,x] = find(E);
mask1 = false(size(thinnedImg));
for k = 1:numel(x)
    D = bwdistgeodesic(thinnedImg,x(k),y(k));
    mask1(D < 20) =true;
    %mask1(D < 65) =true;
end
deburrImg = thinnedImg - mask1;
%End of Denoising process

%Bifurcation Detection
[imgH, imgW] = size(deburrImg);
s = 1;
P = [];
for r = 2:imgH-1
    for c = 2:imgW-1
        nbr(1) = deburrImg(r-1,c-1);
        nbr(2) = deburrImg(r-1,c);
        nbr(3) = deburrImg(r-1,c+1); 
        nbr(4) = deburrImg(r,c+1);
        nbr(5) = deburrImg(r+1,c+1);
        nbr(6) = deburrImg(r+1,c); 
        nbr(7) = deburrImg(r+1,c-1);
        nbr(8) = deburrImg(r,c-1); 
        nbrSum = 0;
        for i = 1:7
            nbrSum = nbrSum + abs(nbr(i+1) - nbr(i));
        end
        nbrSum = nbrSum + abs(nbr(1) - nbr(8)); % p9 = p1 case
        if nbrSum == 6
            P(s,:) = [ r c];
            s = s + 1;
        end      
    end
end

triBpoint = zeros(imgH,imgW);
    [pheight,~] = size(P);
for i = 1:pheight
   triBpoint(P(i,1),P(i,2)) = 1;
end
%End of Bifurcation Detection

% Branch Tracking
triBranchImg = false(size(thinnedImg));
tLen = 15; %Tracking Length
for i = 1: size(P)
    %Center Pixel
     triBranchImg(P(i,1),P(i,2)) = thinnedImg(P(i,1),P(i,2));
     pntX = P(i,1);
     pntY = P(i,2);
     if pntX-tLen >0 && pntY-tLen >0 && pntX+tLen < imgH && pntY+tLen < imgW
        triBranchImg(pntX-tLen:pntX+tLen,pntY-tLen:pntY+tLen) = thinnedImg(pntX-tLen:pntX+tLen,pntY-tLen:pntY+tLen);
     end
end
%End of Branch Tracking

%Dilation
dilatedImg = imdilate(triBranchImg, true(8));

%End of Dilation
dotProd = wvp.*dilatedImg;
end