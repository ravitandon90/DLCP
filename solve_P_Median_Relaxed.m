% We get the value of v(LtSPlambda) here, subject to constraints (2, 3, 4)
function [Y, value] = solve_P_Median_Relaxed (Number_Sensor_Nodes, Sensor_Node_Energy, Min_Energy, Lm, p, t, Inverse_Cost, Cluster_Radius, Distance)
B = zeros (Number_Sensor_Nodes, 2);
Y = zeros (Number_Sensor_Nodes, Number_Sensor_Nodes);
value=0;


% Solving Equation 6 - Calculation of B
for j = 1: Number_Sensor_Nodes
    if(Sensor_Node_Energy(j) < Min_Energy) % If a sensor node is dead, it cannot become a cluster head
        B(j, 1) = j;
        B(j, 2) = inf;
        continue;
    end
      for i = 1 : Number_Sensor_Nodes
        if((Sensor_Node_Energy(i)> Min_Energy) && (Distance(i, j) < Cluster_Radius))
          x1 = Inverse_Cost(i,j) - (t*Lm(i));       % Costij  – t* lambdai  %
          B(j,2) = B(j,2) +  min([0,x1]); % B stores (index, value), Summation(Bi) being done %   
          %if (x1<0)
          %I = Inverse_Cost(i,j)
          %Lm(i)
          %end
        end
       end
      B(j,1) = j;
end
% Sorting B to get those sensor nodes with the lowest cost 
B = sortrows (B, 2);

% Satisfying Constraint 2
for i = 1 : p
    index = B (i, 1);
    Y (index, index) = 1;
end

% Assigning Cluster Heads To Sensor Nodes
for j = 1: Number_Sensor_Nodes
    if ((Sensor_Node_Energy(j)> Min_Energy) && (Y(j, j ) == 1))
        for i = 1 : Number_Sensor_Nodes      
            if(Sensor_Node_Energy(i)> Min_Energy)                
                x1 = Inverse_Cost(i,j) - (t*Lm(i));       % Costij  – t* lambdai  %
                if (x1 < 0)
                    Y (i, j) = 1;                    
                else                    
                end
            end
        end
    end
end

% Calculating v(LtSPlambda)
for i = 1 : p 
    index = B (i, 1);
    if (Sensor_Node_Energy (index) > Min_Energy)
        value = value + B (i, 2); %Y(i, i) is 1 for the first p values of the
    end    
end
for i = 1: Number_Sensor_Nodes
    if (Sensor_Node_Energy (i) > Min_Energy)
        value = value + t*Lm (i);
    end    
end
end