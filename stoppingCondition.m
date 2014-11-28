function to_Stop = stoppingCondition (Pi, ub, lb, norm_G)
if ((Pi <= 0.5) || (ub-lb<1) || (norm_G==0)) 
    to_Stop = 1;
else
    to_Stop =0;
end