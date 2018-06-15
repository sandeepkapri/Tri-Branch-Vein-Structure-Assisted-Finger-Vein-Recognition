function PBBM=getPBBM(R1,R2,R3,R4,L1,L2,L3,L4)

times=4;
step=1;
BBM{1}=calc_newLBP(R1,R2,L1,L2,step,times);
BBM{2}=calc_newLBP(R1,R3,L1,L3,step,times);
BBM{3}=calc_newLBP(R1,R4,L1,L4,step,times);
BBM{4}=calc_newLBP(R2,R3,L2,L3,step,times);
BBM{5}=calc_newLBP(R2,R4,L2,L4,step,times);
BBM{6}=calc_newLBP(R3,R4,L3,L4,step,times);

%  PBBM
PBBM=calcpbbmfor2(BBM{6},calcpbbmfor2(BBM{5},calcpbbmfor2(BBM{4},calcpbbmfor2(BBM{3},calcpbbmfor2(BBM{2},BBM{1})))));
end
