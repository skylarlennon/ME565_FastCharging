% Battery Environment Params
Tambient = 298; % [K] (typically function of time, going to be constant for the sake of this project)

% Series and parallel
series = 96;
parallel = 74;

% Cell params
OCVData = readmatrix("csv/OCV.csv"); % from [@vijay: insert link]
% what's the datasheet for the cell again? (need max and min terminal
% voltage
SOC = OCVData(:,1);
Vocv = OCVData(:,2);
SOC_i = 0.2;
SOC_f = 0.8;

Vtmax_cell = 3.57; 
Vtmin_cell = 2;
Qcell = 2.25; % [Ah]

Vtmax = Vtmax_cell*series;
Vtmin = Vtmin_cell*series;

TcInit = Tambient;
TsInit = Tambient;
TcMax = 318; %K

Rs = 0.013;
R1 = 0.026;
R2 = 0.026;
C1 = 53958;
C2 = 53958;

Rc = 1.94;
Cc = 62.7;
Ru = 3.19;
Cs = 4.5;
Rm = 0.15;

% Pack Params
Qpack = Qcell*parallel;
Rs_pack = 0.013 * (series/parallel);
R1_pack = 0.026 * (series/parallel);
R2_pack = 0.026 * (series/parallel);
C1_pack = 53958 * (parallel/series);
C2_pack = 53958 * (parallel/series);

% For CCCV
I_CCCV_Init = -400;
Kaw = 1;
Ki = 50;
