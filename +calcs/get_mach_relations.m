%returns arrays including the relationship of expansion ratios to pressure
%ratios in the supersonic regime

function [superExpRatio, superPressRatio] = get_mach_relations(gamma)

%making array of expansion ratios at different supersonic mach numbers
superExpRatio = zeros(1, (10 - 1) / .01);
count = 1;
for mach = 1:0.01:10
    expansionRatioSuper = ((((gamma + 1) / 2) ^ ((gamma + 1) / (2 * (1 - gamma)))) / mach) * ((1 + (((gamma - 1) / 2) * (mach ^ 2))) ^ ((gamma + 1) / (2 * (gamma - 1))));
    superExpRatio(count) = expansionRatioSuper;
    count = count + 1;
end
superMachs = 1:0.01:10;

%finding supersonic pressure ratios at different mach numbers
superPressRatio = zeros(1, length(superMachs));
for i = 1:length(superMachs)
    mach = superMachs(i);
    superPressRatio(i) = ((1 + (((gamma - 1) / 2) * (mach ^ 2))) ^ (gamma / (1 - gamma)));
end

end