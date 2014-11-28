% Write to a file 
function writeToFile (File_Name, Sensor_Nodes_Pos)
File_ID = fopen (File_Name, 'w');
Num_Sensor_Nodes = length (Sensor_Nodes_Pos);
for i = 1 : Num_Sensor_Nodes
    fprintf(File_ID,'%f\t%f\r\n',Sensor_Nodes_Pos(i, 1), Sensor_Nodes_Pos(i, 2));    
end
fclose(File_ID);
end