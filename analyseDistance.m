function analyseDistance (Distance, Number_Sensor_Nodes)
Min_Distance = ones (Number_Sensor_Nodes, 1) * inf; 
for i = 1 : Number_Sensor_Nodes    
for j = 1 : Number_Sensor_Nodes
if (i == j) 
    continue;
else
    d = Distance (i, j);
    if (d < Min_Distance (i, 1))
        Min_Distance (i, 1) = d;
    end
end
end
end
max(Min_Distance)

end