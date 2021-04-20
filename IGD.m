function Score = IGD(PopObj,PF)
% <metric> <min>
% Inverted generational distance
% "PlatEMO"


%--------------normalizing scaled problems-------------------%
PopObj=PopObj./max(PF,[],1);
PF=PF./max(PF,[],1);
%----------------------End-----------------------------------%
    Distance = min(pdist2(PF,PopObj),[],2);
    Score    = mean(Distance);
end