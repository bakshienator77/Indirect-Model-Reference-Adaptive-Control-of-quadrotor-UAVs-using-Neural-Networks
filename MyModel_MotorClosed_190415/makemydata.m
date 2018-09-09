FileID =fopen('datafornn1.txt', 'w');
A=500*rand(10000, 4);
fprintf(FileID,'%.2f,%.2f,%.2f,%.2f\n',A);
fclose(FileID);