function [BBM]=calc_newLBP(ROI1,ROI2,LBP1,LBP2,step,times)

[Sm0,S0]=calcStability(LBP1,LBP2);
 
 y= size(ROI2,1);
 x=size(ROI2,2);
 total=[Sm0];
 
% taking Img1 as base, align through moving Img2 toward up direction.
 
 
for n=1:times
    shiftp=step*n;
    i2u = ROI2(mod((1:y)+y+shiftp,y)+1,:);
    overlapLBP1u{n}=LBP(ROI1(1:end-shiftp,:));
    overlapLBP2u{n}=LBP(i2u(1+shiftp:end,:));
    [Smu(n),Sup{n}]=calcStability(overlapLBP1u{n},overlapLBP2u{n});    
    total=[total,Smu(n)];
end
 
 
% taking Img1 as base, align through moving Img2 toward down direction.
 
 
for n=1:times
    shiftp=step*n;
    i2d = ROI2(mod((1:y)+y-shiftp,y)+1,:);
    overlapLBP1d{n}=LBP(ROI1(1+shiftp:end,:));
    overlapLBP2d{n}=LBP(i2d(1:end-shiftp,:));
    [Smd(n),Sdown{n}]=calcStability(overlapLBP1d{n},overlapLBP2d{n});
    total=[total,Smd(n)];
end 
 
% taking Img1 as base, align through moving Img2 toward left direction.
 
 
for n=1:times
    shiftp=step*n;
    i2l = ROI2(:,mod((1:x)+x+shiftp,x)+1);
    overlapLBP1l{n}=LBP(ROI1(:,1:end-shiftp));
    overlapLBP2l{n}=LBP(i2l(:,1+shiftp:end));
    [Sml(n),Sleft{n}]=calcStability(overlapLBP1l{n},overlapLBP2l{n});
    total=[total,Sml(n)];
end
 
 
% taking Img1 as base, align through moving Img2 toward right direction.
 
 
for n=1:times
    shiftp=step*n;
    i2r = ROI2(:,mod((1:x)+x-step,x)+1);
    overlapLBP1r{n}=LBP(ROI1(:,1+shiftp:end));
    overlapLBP2r{n}=LBP(i2r(:,1:end-shiftp));
    [Smr(n),Sright{n}]=calcStability(overlapLBP1r{n},overlapLBP2r{n});
    total=[total,Smr(n)];
end
 
 
% LBP code with maximum similarity
 
[S m]=max(total);
 
switch(m)
    case 1
        LBPsub1=LBP1;
        LBPsub2=LBP2;
        Similaritysub=S0;
    case {2,3,4,5}
        LBPsub1=overlapLBP1u{m-1};
        LBPsub2=overlapLBP2u{m-1};
        Similaritysub=Sup{m-1};
    case {6,7,8,9}
        LBPsub1=overlapLBP1d{m-5};
        LBPsub2=overlapLBP2d{m-5};
        Similaritysub=Sdown{m-5};
    case {10,11,12,13}
        LBPsub1=overlapLBP1l{m-9};
        LBPsub2=overlapLBP2l{m-9};
        Similaritysub=Sleft{m-9};
    case {14,15,16,17}
        LBPsub1=overlapLBP1r{m-13};
        LBPsub2=overlapLBP2r{m-13};
        Similaritysub=Sright{m-13};
end
 
% calculate the best bit map

BBIndex=find(Similaritysub==1);%index location of bits with similarity 1
BMap=LBPsub1(BBIndex);%bit values at BBIndex
BBM=[BBIndex,BMap];%BBM of two samples containing best bit location and value 0 or 1
end